import os


class BaseConfig:
    DEBUG = os.environ.get('FLASK_DEBUG', default=True)
    ENV = os.environ.get('FLASK_ENV', default='development')
    TESTING = os.environ.get('FLASK_TESTING', default=True)
    SECRET_KEY = os.environ.get('FLASK_SECRET_KEY', default='change_me_to_strong_secret_key')
