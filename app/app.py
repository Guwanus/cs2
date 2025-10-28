from flask import Flask, request, jsonify
import os
import boto3
import uuid
import datetime as dt

app = Flask(__name__)
table_name = os.getenv("DDB_TABLE")
region = os.getenv("AWS_REGION", "eu-central-1")
ddb = boto3.resource("dynamodb", region_name=region).Table(table_name)

@app.get("/health")
def health():
    return {"ok": True}, 200

@app.post("/ingest")
def ingest():
    body = request.get_json(silent=True) or {}
    item_id = str(uuid.uuid4())
    item = {
        "id": item_id,
        "ts": dt.datetime.utcnow().isoformat() + "Z",
        "payload": body,
        "source": "ecs-listener"
    }
    ddb.put_item(Item=item)
    return jsonify({"id": item_id, "status": "stored"}), 201

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "8080")))