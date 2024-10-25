"""
Views to handle user authentication
"""
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status

from rest_framework.decorators import permission_classes, authentication_classes

from fcm_django.models import FCMDevice
from firebase_admin.messaging import Message, Notification


@api_view(["POST"])
@authentication_classes([])
@permission_classes([])
def purchase(request):
    devices = FCMDevice.objects.all()
    if devices:
        devices.send_message(
            Message(
                notification=Notification(
                    title="Produto esgotado",
                    body="O produto X da VendingMachine Y está esgotado"
                )
            )
        )
        return Response({"success": "Notification sent"}, status=status.HTTP_200_OK)
    return Response({"error": "No devices registered"}, status=status.HTTP_400_BAD_REQUEST)
