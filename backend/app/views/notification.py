"""
Views to handle user authentication
"""
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status

from app.serializers import FCMDeviceSerializer

from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import permission_classes, authentication_classes
from rest_framework.authentication import TokenAuthentication, SessionAuthentication

from fcm_django.models import FCMDevice


@api_view(["POST"])
@authentication_classes([TokenAuthentication, SessionAuthentication])
@permission_classes([IsAuthenticated])
def register_device(request):
    serializer = FCMDeviceSerializer(data=request.data)
    if serializer.is_valid():
        FCMDevice.objects.filter(device_id=request.data["device_id"]).delete()
        device, created = FCMDevice.objects.get_or_create(
            user=request.user,
            device_id=request.data["device_id"],
            defaults={
                "type": request.data["type"],
                "registration_id": request.data["registration_id"]
            }
        )
        return Response({"created": created}, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
