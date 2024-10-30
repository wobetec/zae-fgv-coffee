"""
Define the URL patterns for the app application.
"""
from django.urls import re_path
from .views import auth, notification, purchase

app_name = 'app'

urlpatterns = [
    re_path(r"^auth/login$", auth.login, name="login"),
    re_path(r"^auth/logout$", auth.logout, name="logout"),
    re_path(r"^auth/signup$", auth.signup, name="signup"),
    re_path(r"^auth/test_token$", auth.test_token, name="test_token"),

    re_path(r"^auth/support/login$", auth.login_support_user, name="login_support_user"),
    re_path(r"^auth/support/logout$", auth.logout_support_user, name="logout_support_user"),
    re_path(r"^auth/support/test_token$", auth.test_token_support_user, name="test_token_support_user"),

    re_path(r"^notification/register_device$", notification.register_device, name="register_device"),
    re_path(r"^purchase$", purchase.purchase, name="purchase"),
]
