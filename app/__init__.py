
from flask import Flask, jsonify


def create_app():
    app = Flask(__name__)

    @app.get("/")
    def home():
        return jsonify({
            "project": "Trivy DevSecOps IA",
            "status": "running",
            "message": "Application is operational"
        })

    @app.get("/health")
    def health():
        return jsonify({"status": "healthy"}), 200

    return app


if __name__ == "__main__":
    create_app().run(host="0.0.0.0", port=5000)
