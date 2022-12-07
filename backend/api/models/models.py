import uuid
from datetime import datetime

from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


def generate_uuid(): return str(uuid.uuid1()).replace("-", "")


class User(db.Model):
    __tablename__ = 'api_users'

    user_id = db.Column(db.String, primary_key=True, default=generate_uuid())

    name = db.Column(db.String, unique=True)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, onupdate=datetime.utcnow)
