import json
import pathlib

database_file = pathlib.Path(__file__).parent / "common/database.json"
db = json.load(database_file.open())

def handle(req):
    body = req.get_json()
    parent_id = body.get("parent", {}).get("id", None)

    study_subjects = db['studySubjects']

    data = None
    if parent_id:
        data = study_subjects.get(parent_id, {}).get("site", {})

    return data, 200, {"Content-Type":"application/json"}
