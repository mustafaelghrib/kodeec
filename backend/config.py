import os


class BaseConfig:
    DEBUG = os.environ.get('FLASK_DEBUG', default=True)
    ENV = os.environ.get('FLASK_ENV', default='development')
    TESTING = os.environ.get('FLASK_TESTING', default=True)
    SECRET_KEY = os.environ.get('FLASK_SECRET_KEY', default='change_me_to_strong_secret_key')

    DB_NAME = os.environ.get('POSTGRES_DB')
    DB_USER = os.environ.get('POSTGRES_USER')
    DB_PASS = os.environ.get('POSTGRES_PASSWORD')
    DB_HOST = os.environ.get('POSTGRES_HOST')
    DB_PORT = os.environ.get('POSTGRES_PORT')

    SQLALCHEMY_DATABASE_URI = f'postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}'


class ProductionConfig(BaseConfig):
    DEBUG = os.environ.get('FLASK_DEBUG', default=False)
    ENV = os.environ.get('FLASK_ENV', default='production')
    TESTING = os.environ.get('FLASK_TESTING', default=False)
    SECRET_KEY = os.environ.get('FLASK_SECRET_KEY', default='change_me_to_strong_secret_key')

    DB_NAME = os.environ.get('POSTGRES_DB')
    DB_USER = os.environ.get('POSTGRES_USER')
    DB_PASS = os.environ.get('POSTGRES_PASSWORD')
    DB_HOST = os.environ.get('POSTGRES_HOST')
    DB_PORT = os.environ.get('POSTGRES_PORT')

    SQLALCHEMY_DATABASE_URI = f'postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}'
