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


@api_view(["GET", "POST", "DELETE"])
@authentication_classes([TokenAuthentication, SessionAuthentication])
@permission_classes([IsAuthenticated])
def rating(request):
    user = request.user

    if request.method == "GET":
        ratings = models.Rating.objects.filter(user=user)
        serializer = serializers.RatingSerializer(ratings, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    if request.method == "POST":
        data = request.data
        data["user"] = user.id
        data["product"] = data.get("prod_id")
        serializer = serializers.RatingSerializer(data=data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        rating = models.Rating.objects.create(**serializer.validated_data)
        serializer = serializers.RatingSerializer(rating)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    if request.method == "DELETE":
        prod_id = request.data.get("prod_id")
        if not prod_id:
            return Response(
                {"error": "Missing product ID"}, status=status.HTTP_400_BAD_REQUEST
            )

        product = get_object_or_404(models.Product, prod_id=prod_id)
        rating = get_object_or_404(models.Rating, user=user, product=product)
        rating.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
