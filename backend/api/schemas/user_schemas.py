from marshmallow import Schema, fields


class UserSchema(Schema):
    user_id = fields.String()
    name = fields.String(
        required=True,
        error_messages={"required": "Name is required"},
    )
    created_at = fields.DateTime()
    updated_at = fields.DateTime()
