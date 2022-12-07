from ..models.models import User


def test_user():
    user = User(name="user one")
    assert user.name == "user one"
