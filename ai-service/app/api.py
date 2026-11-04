from fastapi import BackgroundTasks, FastAPI, HTTPException
from pydantic import BaseModel, Field
from typing import Any
from app.report_analysis.engine import analyse_report
from app.video_processing.worker import process_mission, missions

app = FastAPI(title="WellCheck AI Service", version="1.0.0")

class ReportInput(BaseModel):
    description: str = Field(min_length=5, max_length=5000)
    category: str | None = None
    nearby_report_count: int = Field(default=0, ge=0)
    verified_nearby_count: int = Field(default=0, ge=0)

class MissionInput(BaseModel):
    mission_id: str
    footage_path: str = ""
    telemetry: dict[str, Any] = {}

@app.get("/health")
def health(): return {"status":"UP","model":"heuristic-fallback; optional YOLO is not bundled"}

@app.post("/v1/report-analysis")
def report_analysis(payload: ReportInput):
    return analyse_report(payload.model_dump())

@app.post("/v1/aerial/missions")
def create_mission(payload: MissionInput, tasks: BackgroundTasks):
    if not payload.footage_path:
        raise HTTPException(400, "A securely stored footage path is required before processing")
    missions[payload.mission_id] = {"missionId":payload.mission_id,"status":"QUEUED","candidates":[]}
    tasks.add_task(process_mission, payload.mission_id, payload.footage_path, payload.telemetry)
    return missions[payload.mission_id]

@app.get("/v1/aerial/missions/{mission_id}")
def mission(mission_id: str):
    if mission_id not in missions: raise HTTPException(404, "Mission not found")
    return missions[mission_id]

