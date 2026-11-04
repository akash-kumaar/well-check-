# WellCheck – Disaster Response & Management Platform

WellCheck is an independent disaster-response platform with a vanilla JavaScript/Leaflet frontend, a Java Spring Boot REST backend, PostgreSQL/PostGIS data model, and a Python FastAPI AI service. It is designed to support human decision-makers; it never autonomously dispatches rescue services.

## Run locally with Docker

1. Copy `.env.example` to `.env` and replace `POSTGRES_PASSWORD` and `JWT_SECRET` with strong local values.
2. Run `docker compose up --build`.
3. Open `http://localhost:8090`.

The first registered account is a `CITIZEN`. Roles are deliberately administered only through the database/controlled administrative process in this initial implementation. For local role testing, use the seed SQL described in `docs/deployment-guide.md`.

## Architecture

`frontend` is served by Nginx and proxies `/api` to Spring Boot. Spring Boot owns authentication, authorisation, persistence, audit events, uploads and REST APIs. The Python service is called only by Spring Boot for AI analysis and aerial mission processing. PostgreSQL with PostGIS is the system of record.

## Important safety notes

- External official feeds are adapter contracts only until credentials and source permissions are configured; the UI reports them as unavailable rather than inventing live data.
- Aerial candidates are unverified until an authorised user reviews them. When telemetry is insufficient, the AI service returns exactly: `Location estimation unavailable – insufficient telemetry.`
- This project contains no real emergency data. Add sample records only in an explicitly labelled development environment.

See `docs/implementation-status.md`, `docs/api-documentation.md`, and `docs/deployment-guide.md` for current scope and operational requirements.

