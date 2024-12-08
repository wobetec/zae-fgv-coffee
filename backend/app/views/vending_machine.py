"""
Views to handle product information and operations
"""

from rest_framework.decorators import api_view
from rest_framework.response import Response

from rest_framework import status

from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import permission_classes, authentication_classes
from rest_framework.authentication import TokenAuthentication, SessionAuthentication

from app import models, serializers

@api_view(["GET"])
@authentication_classes([TokenAuthentication, SessionAuthentication])
@permission_classes([IsAuthenticated])
def vending_machine(request):
    vending_machines = models.VendingMachine.objects.all()
    serializer = serializers.VendingMachineSerializer(vending_machines, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)
