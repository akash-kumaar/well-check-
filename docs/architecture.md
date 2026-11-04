# Architecture

```text
Browser (vanilla JS + Leaflet) -> Nginx -> Spring Boot API -> PostgreSQL/PostGIS
                                           |-> FastAPI AI service
                                           |-> external-data adapters (not configured by default)
```

The central backend enforces roles (`CITIZEN`, `FIELD_OFFICER`, `DATA_OFFICER`, `COORDINATOR`, `SUPER_ADMIN`) with Spring Security. The browser never decides access. Geographic records use PostGIS `geography(Point,4326)` and map APIs return persisted records only.

Report lifecycle: `SUBMITTED -> UNDER_REVIEW -> VERIFIED -> ASSIGNED -> IN_PROGRESS -> RESOLVED`, with `REJECTED` permitted only with a reviewer explanation. Aerial processing is asynchronous in FastAPI; its candidate output remains unverified until a coordinator reviews it.

