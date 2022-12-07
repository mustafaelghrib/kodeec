from ..views.user_views import *


def create_user_urls(api):
    api.add_resource(UsersAPI, '/users')
    api.add_resource(UserAPI, '/users/<user_id>')
