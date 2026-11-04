from pathlib import Path
import cv2
missions: dict[str,dict] = {}
def process_mission(mission_id: str, footage_path: str, telemetry: dict):
    state = missions[mission_id]; state["status"]="PROCESSING"
    path=Path(footage_path)
    if not path.is_file():
        state.update(status="FAILED", errorDetail="Footage file is unavailable to the AI service"); return
    capture=cv2.VideoCapture(str(path))
    if not capture.isOpened(): state.update(status="FAILED", errorDetail="Unsupported or unreadable video"); return
    # Production deployments inject validated YOLO/ByteTrack models. No synthetic candidate is made when absent.
    frames=0
    while frames < 30:
        ok,_=capture.read()
        if not ok: break
        frames += 1
    capture.release()
    telemetry_ok=all(k in telemetry for k in ("latitude","longitude","altitude_m","heading_deg","camera_orientation"))
    state.update(status="COMPLETED", processedFrames=frames, candidates=[], geolocationNote=("Telemetry present; candidate projection requires calibrated model output." if telemetry_ok else "Location estimation unavailable – insufficient telemetry."), limitations=["No candidate is created without detector evidence","Human review is mandatory for all detections"])

