from app.report_analysis.engine import analyse_report
def test_analysis_separates_confidence_and_priority():
    result=analyse_report({"description":"People trapped on roof during flood", "nearby_report_count":3, "verified_nearby_count":1})
    assert result["classification"]["modelConfidence"] != result["priorityRecommendation"]
    assert result["priorityRecommendation"] in {"CRITICAL","HIGH","MEDIUM","LOW"}
def test_no_telemetry_claim_is_not_invented():
    from app.video_processing.worker import missions,process_mission
    missions["x"]={"missionId":"x","status":"QUEUED","candidates":[]}; process_mission("x","missing.mp4",{})
    assert missions["x"]["status"]=="FAILED"

