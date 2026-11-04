# Database design

The V1 Flyway migration creates the requested security, report, incident, AI, aerial, rescue, relief, external-data, alert, notification, audit and settings tables. `reports`, `incidents`, `relief_centres`, `rescue_teams`, `incident_locations`, weather/water data and alert coverage use PostGIS spatial columns; GiST indexes exist for primary incident/report geometry.

Key relationships: users have roles; a user owns reports; reports can link to incidents; incidents receive evidence/history/assignments; teams receive members/equipment/assignments; centres own resources/inventory; aerial missions own footage/telemetry/candidates/tracks/reviews/geolocation estimates; published alerts can produce notifications.

All operational tables use foreign keys and timestamps where applicable. Large-list API pagination is a documented next implementation item; it must be added before production deployment.

