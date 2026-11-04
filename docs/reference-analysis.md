# Reference analysis and licence-aware design

| Reference | Findings studied | WellCheck adaptation | Licence / reuse position |
| --- | --- | --- | --- |
| RescueMap-AI | Leaflet operational maps; transparent confidence, recency, severity and clustering signals | Explainable analysis response separates confidence, severity, evidence quality and priority | No root licence identified; no source code reused |
| DISHA-platform | Indian data aggregation, source freshness, emergency-service lookup, citizen reports | Provider adapters persist source health and explicitly expose unconfigured/error states | Custom source-available licence restricts reuse; no source code reused |
| Sahana Eden | Mature incident, resource, relief and coordination workflows | Relational incident, team, assignment and relief-centre model | MIT; architecture ideas only, no copied code |
| Ushahidi Platform | Crowdsourced reports, categories, geolocation and REST separation | Report/incident APIs and persisted geospatial map markers | AGPL; no source code reused to avoid derivative ambiguity |
| DisasterSIGHT | OpenCV + YOLO + tracking flow, telemetry limits and human review | Async aerial mission contract, candidate review and explicit uncertainty | MIT; workflow ideas only, no copied code |

The implementation deliberately uses the requested Java/Spring Boot, PostgreSQL/PostGIS, FastAPI and vanilla JavaScript stack rather than inheriting any reference stack.

