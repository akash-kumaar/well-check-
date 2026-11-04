# Deployment guide

Use Docker Compose for local development only after reviewing `.env`. Production deployment needs TLS termination, a managed PostgreSQL/PostGIS backup policy, secret management, object storage with malware scanning, an authenticated background-job queue, monitoring and a retained audit-log policy.

For role testing, create a user through the registration page, then assign roles only through a controlled database migration or administrative procedure. Never expose an unauthenticated role-assignment endpoint.

