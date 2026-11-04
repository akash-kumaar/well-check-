# Implementation status

## Implemented in source

- Docker Compose topology; PostGIS schema/migration; Spring Boot auth, reports, review, incidents, map, rescue, relief, alert and AI/aerial gateway APIs.
- FastAPI report analysis and asynchronous aerial processing contract with telemetry safety guard.
- Vanilla-JavaScript public/citizen/admin pages, reusable API client, authentication handling, live Leaflet maps, report submission and key management flows.
- Backend, AI-service and browser-oriented test sources.

## Implemented but not fully tested in this workspace

- The local machine has Java 21, Python and Docker but no Maven executable. Maven tests therefore have **not** been run here; see `docs/testing-report.md`.
- Docker Compose has been supplied and its configuration validated, but it could not be started here because the local Docker Desktop Linux daemon was not running.

## Waiting for external API credentials / permitted access

- IMD, CWC, NDMA/SACHET, state sources, routing and geocoding integrations. Interfaces and source-health states are provided; no live data is fabricated.

## Requires physical drone or additional hardware

- Reliable aerial telemetry, calibration, orientation, terrain inputs and validated production model weights. The processing API supports these inputs but does not assert person coordinates from drone position alone.

## Not implemented as production-ready scope

- Real provider adapters, email/SMS delivery, object-store virus scanning, background job broker, model training/evaluation and a controlled admin bootstrap workflow need deployment-specific implementation and security review.

