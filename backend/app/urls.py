"""
Define the URL patterns for the app application.
"""
from django.urls import re_path
from .views import auth

app_name = 'app'

urlpatterns = [
    re_path(r"login", auth.login, name="login"),
    re_path(r"signup", auth.signup, name="signup"),
    re_path(r"test_token", auth.test_token, name="test_token"),
]