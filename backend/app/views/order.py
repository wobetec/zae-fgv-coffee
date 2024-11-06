"""
Views to handle product information and operations
"""

from django.shortcuts import get_object_or_404
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
def order(request):
    order_id = request.query_params.get("order_id")
    if not order_id:
        return Response(
            {"error": "Missing order ID"}, status=status.HTTP_400_BAD_REQUEST
        )

    order = get_object_or_404(models.Order, order_id=order_id, user=request.user)

    serializer = serializers.OrderSerializer(order)
    return Response(serializer.data, status=status.HTTP_200_OK)


@api_view(["GET"])
@authentication_classes([TokenAuthentication, SessionAuthentication])
@permission_classes([IsAuthenticated])
def order_all(request):
    orders = models.Order.objects.filter(user=request.user)

    serializer = serializers.OrderSerializer(orders, many=True)

    return Response(serializer.data, status=status.HTTP_200_OK)
