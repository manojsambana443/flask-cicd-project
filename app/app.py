from flask import Flask, request, jsonify

app = Flask(__name__)

store = {"message": "hello world"}

@app.get("/health")
def health():
    return jsonify(ok=True)

@app.get("/message")
def get_message():
    return jsonify(store)

@app.post("/message")
def set_message():
    data = request.get_json() or {}
    msg = data.get("message")
    if not msg:
        return jsonify(error="no message"), 400
    store["message"] = msg
    return jsonify(store)

if __name__ == "__main__":
    # For local development only; production uses gunicorn
    app.run(host="0.0.0.0", port=3000)
