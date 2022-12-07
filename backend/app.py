import os

from flask import Flask
from flask_migrate import Migrate
from flask_restful import Api

from api.urls.user_urls import create_user_urls

migrate = Migrate(directory='.migrations')


def create_app():
    app = Flask(__name__)

    app.config.from_object(os.environ.get('FLASK_CONFIG'))

    from api.models.models import db
    db.init_app(app)

    migrate.init_app(app, db)

    api = Api(app, prefix="/api")
    create_urls(api)

    @app.route('/')
    def home():
        return f"<h1>WELCOME TO FLASK | {os.environ.get('FLASK_CONFIG')}</h1>"

    return app


def create_urls(api):
    create_user_urls(api)


if __name__ == "__main__":
    flask_app = create_app()
    flask_app.run()
