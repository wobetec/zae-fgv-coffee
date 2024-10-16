"""
Define the URL patterns for the backend application.
"""
from django.urls import path
from django.urls import include

urlpatterns = [
    path("", include("app.urls")),
]
