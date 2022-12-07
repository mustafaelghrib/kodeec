import os
from flask import Flask


def create_app():

    app = Flask(__name__)

    app.config.from_object(os.environ.get('FLASK_CONFIG'))

    @app.route('/')
    def home():
        return f"<h1>WELCOME TO FLASK | {os.environ.get('FLASK_CONFIG')}</h1>"

    return app


if __name__ == "__main__":
    flask_app = create_app()
    flask_app.run()
