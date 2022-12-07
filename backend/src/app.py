import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate


def create_app():

    app = Flask(__name__)

    app.config.from_object(os.environ.get('FLASK_CONFIG'))

    db = SQLAlchemy(app)
    db.init_app(app)

    migrate = Migrate(app, db, directory='.migrations')
    migrate.init_app(app, db)

    @app.route('/')
    def home():
        return f"<h1>WELCOME TO FLASK | {os.environ.get('FLASK_CONFIG')}</h1>"

    return app
