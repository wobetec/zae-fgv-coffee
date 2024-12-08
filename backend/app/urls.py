"""
Define the URL patterns for the app application.
"""
from django.urls import re_path

from .views import product, vending_machine, rating, order, simple_report
from .views import auth, notification, purchase

app_name = 'app'

urlpatterns = [
    # Auth
    re_path(r"^auth/login", auth.login, name="login"),
    re_path(r"^auth/logout", auth.logout, name="logout"),
    re_path(r"^auth/signup", auth.signup, name="signup"),
    re_path(r"^auth/test_token", auth.test_token, name="test_token"),

    re_path(r"^auth/support/login", auth.login_support_user, name="login_support_user"),
    re_path(r"^auth/support/logout", auth.logout_support_user, name="logout_support_user"),
    re_path(r"^auth/support/test_token", auth.test_token_support_user, name="test_token_support_user"),

    # Notification
    re_path(r"^notification/register_device$", notification.register_device, name="register_device"),

    # Product
    re_path(r"^product/?$", product.product, name="product"),
    re_path(r"^product/all", product.product_all, name="product/all"),
    re_path(r"^product/favorite", product.product_favorite, name="product/favorite"),
    re_path(r"^product/rating", product.product_rating, name="product/rating"),

    # Vending Machine
    re_path(r"^vending_machine", vending_machine.vending_machine, name="vending_machine"),

    # Order
    re_path(r"^order/?$", order.order, name="order"),
    re_path(r"^order/all", order.order_all, name="order/all"),

    # Rating
    re_path(r"^rating", rating.rating, name="rating"),

    # Purchase
    re_path(r"^purchase$", purchase.purchase, name="purchase"),

    # Report
    re_path(r"^report$", simple_report.daily_report, name="daily_report"),
]
