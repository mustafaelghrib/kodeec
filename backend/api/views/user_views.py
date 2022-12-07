from flask import jsonify, request
from flask_restful import Resource
from marshmallow import ValidationError

from ..models.models import *
from ..schemas.user_schemas import *


class UsersAPI(Resource):

    def post(self):
        return self.add_user()

    def get(self):
        return self.get_users()

    @staticmethod
    def get_users():

        users = User.query.all()

        return jsonify(
            status=200,
            message="Users fetched successfully!",
            users=UserSchema(many=True).dump(users)
        )

    @staticmethod
    def add_user():

        try:
            user_schema = UserSchema(only=["name"])
            result = user_schema.load(request.get_json())
        except ValidationError as error:
            return jsonify(
                status=400,
                message="Error",
                error=error.messages
            )

        current_user = User.query.filter_by(name=result["name"]).one_or_none()
        if current_user:
            return jsonify(
                status=400,
                message="User already added!",
            )

        user = User(name=result["name"])

        db.session.add(user)
        db.session.commit()

        return jsonify(
            status=200,
            message="User added successfully!",
            user=UserSchema().dump(user)
        )


class UserAPI(Resource):

    def get(self, user_id):
        return self.get_user(user_id)

    def put(self, user_id):
        return self.update_user(user_id)

    def patch(self, user_id):
        return self.update_user(user_id)

    def delete(self, user_id):
        return self.delete_user(user_id)

    @staticmethod
    def get_user(user_id):

        user = User.query.filter_by(user_id=user_id).one_or_none()
        if not user:
            return jsonify(
                status=400,
                message="User is not found!",
            )

        return jsonify(
            status=200,
            message=f"User fetched successfully!",
            user=UserSchema().dump(user)
        )

    @staticmethod
    def update_user(user_id):

        user = User.query.filter_by(user_id=user_id).one_or_none()
        if not user:
            return jsonify(
                status=400,
                message="User is not found!",
            )

        payload = request.get_json()

        if 'name' in payload:
            user.name = payload['name']
            db.session.add(user)
            db.session.commit()

        return jsonify(
            status=200,
            message=f"User updated successfully!",
            user=UserSchema().dump(user)
        )

    @staticmethod
    def delete_user(user_id):

        user = User.query.filter_by(user_id=user_id).one_or_none()
        if not user:
            return jsonify(
                status=400,
                message="User is not found!",
            )

        db.session.delete(user)
        db.session.commit()

        return jsonify(
            status=200,
            message=f"User deleted successfully!"
        )
