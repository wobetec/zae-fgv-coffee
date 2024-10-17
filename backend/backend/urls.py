"""
Define the URL patterns for the backend application.
"""
from django.urls import path
from django.urls import include
from django.contrib import admin

urlpatterns = [
    path("", include("app.urls")),
    path("admin/", admin.site.urls),
]
