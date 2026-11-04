CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE roles (id BIGSERIAL PRIMARY KEY, name VARCHAR(40) UNIQUE NOT NULL);
INSERT INTO roles(name) VALUES ('CITIZEN'),('FIELD_OFFICER'),('DATA_OFFICER'),('COORDINATOR'),('SUPER_ADMIN') ON CONFLICT DO NOTHING;
CREATE TABLE users (
  id UUID PRIMARY KEY, email VARCHAR(254) UNIQUE NOT NULL, password_hash VARCHAR(255) NOT NULL,
  display_name VARCHAR(120) NOT NULL, active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(), updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE user_roles (user_id UUID REFERENCES users(id) ON DELETE CASCADE, role_id BIGINT REFERENCES roles(id), PRIMARY KEY(user_id, role_id));
CREATE TABLE user_sessions (id UUID PRIMARY KEY, user_id UUID NOT NULL REFERENCES users(id), expires_at TIMESTAMPTZ NOT NULL, revoked_at TIMESTAMPTZ);
CREATE TABLE login_attempts (id BIGSERIAL PRIMARY KEY, email VARCHAR(254) NOT NULL, success BOOLEAN NOT NULL, source_ip VARCHAR(64), attempted_at TIMESTAMPTZ NOT NULL DEFAULT now());

CREATE TABLE reports (
  id UUID PRIMARY KEY, reference_no VARCHAR(32) UNIQUE NOT NULL, reporter_id UUID NOT NULL REFERENCES users(id),
  category VARCHAR(50) NOT NULL, description TEXT NOT NULL, status VARCHAR(32) NOT NULL DEFAULT 'SUBMITTED',
  reviewer_note TEXT, location geography(Point,4326), location_label VARCHAR(255), created_at TIMESTAMPTZ NOT NULL DEFAULT now(), updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT report_status_check CHECK (status IN ('SUBMITTED','UNDER_REVIEW','VERIFIED','ASSIGNED','IN_PROGRESS','RESOLVED','REJECTED'))
);
CREATE INDEX reports_location_idx ON reports USING GIST(location);
CREATE INDEX reports_status_created_idx ON reports(status, created_at DESC);
CREATE TABLE report_attachments (id UUID PRIMARY KEY, report_id UUID NOT NULL REFERENCES reports(id) ON DELETE CASCADE, stored_name VARCHAR(255) NOT NULL, media_type VARCHAR(100) NOT NULL, bytes BIGINT NOT NULL, uploaded_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE report_status_history (id BIGSERIAL PRIMARY KEY, report_id UUID NOT NULL REFERENCES reports(id) ON DELETE CASCADE, old_status VARCHAR(32), new_status VARCHAR(32) NOT NULL, note TEXT, changed_by UUID REFERENCES users(id), changed_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE report_comments (id UUID PRIMARY KEY, report_id UUID NOT NULL REFERENCES reports(id) ON DELETE CASCADE, author_id UUID NOT NULL REFERENCES users(id), body TEXT NOT NULL, created_at TIMESTAMPTZ NOT NULL DEFAULT now());

CREATE TABLE incidents (id UUID PRIMARY KEY, title VARCHAR(180) NOT NULL, category VARCHAR(50) NOT NULL, status VARCHAR(32) NOT NULL DEFAULT 'OPEN', priority VARCHAR(20) NOT NULL DEFAULT 'MEDIUM', verified BOOLEAN NOT NULL DEFAULT FALSE, location geography(Point,4326), created_at TIMESTAMPTZ NOT NULL DEFAULT now(), updated_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE INDEX incidents_location_idx ON incidents USING GIST(location);
CREATE TABLE incident_reports (incident_id UUID REFERENCES incidents(id) ON DELETE CASCADE, report_id UUID REFERENCES reports(id) ON DELETE CASCADE, PRIMARY KEY(incident_id, report_id));
CREATE TABLE incident_locations (id UUID PRIMARY KEY, incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE, location geography(Point,4326) NOT NULL, label VARCHAR(255));
CREATE TABLE incident_status_history (id BIGSERIAL PRIMARY KEY, incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE, status VARCHAR(32) NOT NULL, note TEXT, changed_by UUID REFERENCES users(id), changed_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE incident_evidence (id UUID PRIMARY KEY, incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE, attachment_id UUID REFERENCES report_attachments(id), description TEXT, created_at TIMESTAMPTZ NOT NULL DEFAULT now());

CREATE TABLE ai_analyses (id UUID PRIMARY KEY, report_id UUID REFERENCES reports(id), category VARCHAR(50), confidence NUMERIC(4,3), severity VARCHAR(20), evidence_quality VARCHAR(20), created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE ai_recommendations (id UUID PRIMARY KEY, analysis_id UUID NOT NULL REFERENCES ai_analyses(id) ON DELETE CASCADE, priority VARCHAR(20) NOT NULL, explanation TEXT NOT NULL, created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE report_clusters (id UUID PRIMARY KEY, centroid geography(Point,4326), created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE priority_scores (id UUID PRIMARY KEY, incident_id UUID REFERENCES incidents(id), score NUMERIC(6,2), factors JSONB NOT NULL DEFAULT '{}', created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE model_versions (id UUID PRIMARY KEY, name VARCHAR(100) NOT NULL, version VARCHAR(100) NOT NULL, active BOOLEAN NOT NULL DEFAULT FALSE, created_at TIMESTAMPTZ NOT NULL DEFAULT now());

CREATE TABLE aerial_missions (id UUID PRIMARY KEY, name VARCHAR(180) NOT NULL, status VARCHAR(32) NOT NULL DEFAULT 'QUEUED', requested_by UUID REFERENCES users(id), error_detail TEXT, created_at TIMESTAMPTZ NOT NULL DEFAULT now(), updated_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE drone_footage (id UUID PRIMARY KEY, mission_id UUID NOT NULL REFERENCES aerial_missions(id) ON DELETE CASCADE, stored_name VARCHAR(255) NOT NULL, content_type VARCHAR(100), bytes BIGINT NOT NULL, created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE drone_telemetry (id UUID PRIMARY KEY, mission_id UUID NOT NULL REFERENCES aerial_missions(id) ON DELETE CASCADE, latitude DOUBLE PRECISION, longitude DOUBLE PRECISION, altitude_m DOUBLE PRECISION, heading_deg DOUBLE PRECISION, camera_orientation JSONB, captured_at TIMESTAMPTZ);
CREATE TABLE detection_candidates (id UUID PRIMARY KEY, mission_id UUID NOT NULL REFERENCES aerial_missions(id) ON DELETE CASCADE, confidence NUMERIC(4,3), tracking_seconds NUMERIC(8,2), review_status VARCHAR(32) NOT NULL DEFAULT 'UNVERIFIED', priority VARCHAR(20), latitude DOUBLE PRECISION, longitude DOUBLE PRECISION, uncertainty_m DOUBLE PRECISION, geolocation_method VARCHAR(100), created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE detection_frames (id UUID PRIMARY KEY, candidate_id UUID NOT NULL REFERENCES detection_candidates(id) ON DELETE CASCADE, evidence_path VARCHAR(255), video_timestamp_ms BIGINT, created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE detection_tracks (id UUID PRIMARY KEY, candidate_id UUID NOT NULL REFERENCES detection_candidates(id) ON DELETE CASCADE, tracker_id VARCHAR(100), observed_frames INT NOT NULL DEFAULT 0);
CREATE TABLE detection_reviews (id UUID PRIMARY KEY, candidate_id UUID NOT NULL REFERENCES detection_candidates(id) ON DELETE CASCADE, reviewer_id UUID NOT NULL REFERENCES users(id), decision VARCHAR(32) NOT NULL, note TEXT, created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE geolocation_estimates (id UUID PRIMARY KEY, candidate_id UUID NOT NULL REFERENCES detection_candidates(id) ON DELETE CASCADE, location geography(Point,4326), uncertainty_m DOUBLE PRECISION, method VARCHAR(100) NOT NULL, inputs JSONB NOT NULL DEFAULT '{}');

CREATE TABLE rescue_teams (id UUID PRIMARY KEY, name VARCHAR(120) UNIQUE NOT NULL, capabilities TEXT, availability VARCHAR(32) NOT NULL DEFAULT 'AVAILABLE', location geography(Point,4326), created_at TIMESTAMPTZ NOT NULL DEFAULT now(), updated_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE rescue_team_members (id UUID PRIMARY KEY, team_id UUID NOT NULL REFERENCES rescue_teams(id) ON DELETE CASCADE, name VARCHAR(120) NOT NULL, role_name VARCHAR(100), contact VARCHAR(100));
CREATE TABLE rescue_equipment (id UUID PRIMARY KEY, team_id UUID NOT NULL REFERENCES rescue_teams(id) ON DELETE CASCADE, name VARCHAR(120) NOT NULL, quantity INT NOT NULL CHECK(quantity >= 0));
CREATE TABLE rescue_assignments (id UUID PRIMARY KEY, incident_id UUID NOT NULL REFERENCES incidents(id), team_id UUID NOT NULL REFERENCES rescue_teams(id), status VARCHAR(32) NOT NULL DEFAULT 'ASSIGNED', detail TEXT, assigned_at TIMESTAMPTZ NOT NULL DEFAULT now(), completed_at TIMESTAMPTZ);
CREATE TABLE rescue_updates (id UUID PRIMARY KEY, assignment_id UUID NOT NULL REFERENCES rescue_assignments(id) ON DELETE CASCADE, author_id UUID REFERENCES users(id), body TEXT NOT NULL, created_at TIMESTAMPTZ NOT NULL DEFAULT now());

CREATE TABLE relief_centres (id UUID PRIMARY KEY, name VARCHAR(180) NOT NULL, address TEXT, contact VARCHAR(100), capacity INT NOT NULL CHECK(capacity >= 0), available_beds INT NOT NULL CHECK(available_beds >= 0), operational BOOLEAN NOT NULL DEFAULT TRUE, location geography(Point,4326), created_at TIMESTAMPTZ NOT NULL DEFAULT now(), updated_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE relief_resources (id UUID PRIMARY KEY, centre_id UUID NOT NULL REFERENCES relief_centres(id) ON DELETE CASCADE, resource_type VARCHAR(60) NOT NULL, available BOOLEAN NOT NULL DEFAULT FALSE);
CREATE TABLE relief_inventory (id UUID PRIMARY KEY, centre_id UUID NOT NULL REFERENCES relief_centres(id) ON DELETE CASCADE, item VARCHAR(120) NOT NULL, quantity INT NOT NULL CHECK(quantity >= 0), updated_at TIMESTAMPTZ NOT NULL DEFAULT now());

CREATE TABLE data_sources (id UUID PRIMARY KEY, name VARCHAR(120) UNIQUE NOT NULL, source_type VARCHAR(60), configured BOOLEAN NOT NULL DEFAULT FALSE, health VARCHAR(32) NOT NULL DEFAULT 'NOT_CONFIGURED', last_success_at TIMESTAMPTZ, last_error TEXT, freshness_seconds INT);
CREATE TABLE data_source_logs (id UUID PRIMARY KEY, source_id UUID NOT NULL REFERENCES data_sources(id), status VARCHAR(32), detail TEXT, created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE weather_records (id UUID PRIMARY KEY, source_id UUID REFERENCES data_sources(id), observed_at TIMESTAMPTZ NOT NULL, location geography(Point,4326), rainfall_mm NUMERIC(8,2), temperature_c NUMERIC(5,2), raw JSONB NOT NULL DEFAULT '{}');
CREATE TABLE water_level_records (id UUID PRIMARY KEY, source_id UUID REFERENCES data_sources(id), observed_at TIMESTAMPTZ NOT NULL, station_name VARCHAR(120), location geography(Point,4326), level_m NUMERIC(8,3), warning_level_m NUMERIC(8,3));
CREATE TABLE traffic_records (id UUID PRIMARY KEY, source_id UUID REFERENCES data_sources(id), observed_at TIMESTAMPTZ NOT NULL, road_name VARCHAR(180), status VARCHAR(32), geometry geometry(Geometry,4326), detail TEXT);
CREATE TABLE satellite_metadata (id UUID PRIMARY KEY, source_id UUID REFERENCES data_sources(id), captured_at TIMESTAMPTZ, coverage geometry(Geometry,4326), licence TEXT, url TEXT);

CREATE TABLE alerts (id UUID PRIMARY KEY, title VARCHAR(180) NOT NULL, body TEXT NOT NULL, severity VARCHAR(20) NOT NULL, status VARCHAR(32) NOT NULL DEFAULT 'DRAFT', expires_at TIMESTAMPTZ, created_by UUID REFERENCES users(id), created_at TIMESTAMPTZ NOT NULL DEFAULT now(), updated_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE alert_locations (id UUID PRIMARY KEY, alert_id UUID NOT NULL REFERENCES alerts(id) ON DELETE CASCADE, coverage geometry(Geometry,4326));
CREATE TABLE notifications (id UUID PRIMARY KEY, user_id UUID REFERENCES users(id), alert_id UUID REFERENCES alerts(id), title VARCHAR(180) NOT NULL, body TEXT NOT NULL, read_at TIMESTAMPTZ, created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE audit_logs (id BIGSERIAL PRIMARY KEY, actor_id UUID REFERENCES users(id), action VARCHAR(120) NOT NULL, resource_type VARCHAR(80), resource_id UUID, detail JSONB NOT NULL DEFAULT '{}', created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE system_settings (setting_key VARCHAR(120) PRIMARY KEY, setting_value JSONB NOT NULL, updated_by UUID REFERENCES users(id), updated_at TIMESTAMPTZ NOT NULL DEFAULT now());

