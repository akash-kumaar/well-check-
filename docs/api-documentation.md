# REST API documentation

All JSON endpoints are under `/api`. Send `Authorization: Bearer <JWT>` after login. Backend authorisation—not UI visibility—protects `/api/admin/**`.

| Area | Endpoint | Access | Purpose |
|---|---|---|---|
| Authentication | `POST /auth/register`, `POST /auth/login`, `GET /auth/me` | public/public/authenticated | Register citizen, issue JWT, profile |
| Citizen reports | `POST /reports`, `GET /reports/my` | citizen | Create and view own reports |
| Public map | `GET /public/incidents/markers`, `/public/relief-centres`, `/public/alerts` | public | Persisted map markers, centres, published alerts |
| Review | `GET /admin/reports`, `PATCH /admin/reports/{id}/review` | authorised admin | Review/reject/verify reports |
| Incidents | `GET,POST /admin/incidents`, `PATCH /admin/incidents/{id}/verify` | authorised admin | Incident creation and verification |
| Rescue | `GET,POST /admin/rescue-teams`, `POST /admin/rescue-assignments` | authorised admin | Team and assignment management |
| Relief | `GET,POST /admin/relief-centres` | authorised admin | Centre management |
| Alerts | `GET,POST /admin/alerts`, `PATCH /admin/alerts/{id}/publish` | authorised admin | Draft and publish alert |
| Data sources | `GET /admin/data-sources` | authorised admin | Source configuration/health state |
| AI | `POST /admin/ai/analyse-report` | authorised admin | Calls FastAPI; failure is explicit |
| Aerial | `GET,POST /admin/aerial/missions` | authorised admin | Create/list asynchronous missions |

Pagination, attachment upload, password-reset delivery, source-adapter management, full audit viewing and detection review endpoints remain marked for further implementation in `docs/implementation-status.md`; they are not represented as available APIs.

