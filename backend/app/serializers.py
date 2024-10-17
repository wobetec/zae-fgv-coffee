"""
Define serializers for the app application.
"""
from rest_framework import serializers
from django.contrib.auth.models import User
from fcm_django.models import FCMDevice


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'password']


class FCMDeviceSerializer(serializers.ModelSerializer):
    class Meta:
        model = FCMDevice
        fields = ['id', 'name', 'device_id', 'registration_id', 'type', 'user']
        read_only_fields = ['id', 'user']
        extra_kwargs = {
            'device_id': {'required': True},
            'registration_id': {'required': True},
            'type': {'required': True},
        }
