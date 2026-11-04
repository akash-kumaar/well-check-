import re

KEYWORDS = {
    "Flood": ["flood", "waterlogged", "inundat", "river", "submerged"],
    "Fire": ["fire", "smoke", "burn", "flame"],
    "Landslide": ["landslide", "mudslide", "debris"],
    "Earthquake": ["earthquake", "tremor", "collapsed"],
}
HIGH_RISK = ["trapped", "roof", "collapsed", "injured", "sos", "children", "hospital"]
def analyse_report(data: dict) -> dict:
    text = data["description"].lower()
    category = data.get("category") or next((k for k,v in KEYWORDS.items() if any(x in text for x in v)), "Other")
    matched = [word for word in HIGH_RISK if word in text]
    severity = "HIGH" if len(matched) >= 2 else "MEDIUM" if matched else "LOW"
    nearby = data.get("nearby_report_count",0); verified = data.get("verified_nearby_count",0)
    priority = "CRITICAL" if severity == "HIGH" and verified > 0 else "HIGH" if severity == "HIGH" or nearby >= 3 else "MEDIUM" if nearby else "LOW"
    confidence = min(.90, .38 + .12*len(matched) + (.10 if category != "Other" else 0))
    return {"classification":{"category":category,"modelConfidence":round(confidence,2)},"severity":severity,"evidenceQuality":"UNVERIFIED_TEXT_ONLY","priorityRecommendation":priority,"explanation":{"positiveSignals":matched or ["No high-risk terms identified"],"relatedReportCount":nearby,"verifiedNearbyCount":verified,"limitations":["This is a recommendation, not a dispatch decision","Text-only analysis cannot verify an incident"]}}

