# Testing report

Test suites are included under `backend/src/test`, `ai-service/tests`, and `tests/frontend`.

| Suite | Intended command | Result in this workspace |
| --- | --- | --- |
| Spring Boot | `cd backend && mvn test` | Not run: Maven is not installed |
| AI service | `cd ai-service && python -m pytest` | Full pytest suite not run: dependencies deliberately not installed. A dependency-free report-analysis unit check was run and passed. |
| Frontend smoke checks | `node tests/frontend/smoke.mjs` | Not run: no browser-test dependency installed |

No test is represented as passed without execution. See individual test names for covered behaviours.

Additional checks actually run on 2026-11-05: `node --check` for the four frontend scripts (passed), `node tests/frontend/smoke.mjs` (passed), `python -m py_compile` for AI source (passed), and `docker compose config --no-interpolate` (passed). Docker integration build/run was not possible because the local Docker Desktop Linux daemon was not running.

