import json
import pathlib
from flask import Flask, request, jsonify
import os
import pprint

pp = pprint.PrettyPrinter(indent=4)

database_file = pathlib.Path(__file__).parent / "database.json"
db = json.load(database_file.open())

app = Flask(__name__)

@app.route('/', methods=["POST"])
def studies():
    body = request.get_json()
    parent_id = body.get("parent", {}).get("id", None)

    client_studies = db['clientStudies']

    data = None
    if parent_id:
        data = client_studies.get(parent_id, None)
    
    pp.pprint(data)

    return jsonify(data), 200

if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0',port=int(os.environ.get('PORT', 8080)))
