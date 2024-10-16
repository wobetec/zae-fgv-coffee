"""
Define the URL patterns for the app application.
"""
from django.urls import re_path
from .views import auth

app_name = 'app'

urlpatterns = [
    re_path(r"^auth/login", auth.login, name="login"),
    re_path(r"^auth/logout", auth.logout, name="logout"),
    re_path(r"^auth/signup", auth.signup, name="signup"),
    re_path(r"^auth/test_token", auth.test_token, name="test_token"),
]