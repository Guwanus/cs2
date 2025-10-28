import os, json, boto3, uuid, datetime as dt

TABLE = os.environ.get("DDB_TABLE")
REGION = os.environ.get("AWS_REGION", "eu-central-1")
ddb = boto3.resource("dynamodb", region_name=REGION).Table(TABLE)

def handler(event, context):
    # Minimal example "response" that writes an action record
    action_id = str(uuid.uuid4())
    ddb.put_item(Item={
        "id": action_id,
        "ts": dt.datetime.utcnow().isoformat() + "Z",
        "payload": {"event": event},
        "source": "lambda-response"
    })
    return {"ok": True, "action_id": action_id}