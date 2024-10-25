"""
Views to handle user authentication
"""
from django.shortcuts import get_object_or_404
from rest_framework.decorators import api_view
from rest_framework.response import Response

from app.serializers import UserSerializer
from django.contrib.auth.models import User
from rest_framework import status
from rest_framework.authtoken.models import Token
from fcm_django.models import FCMDevice

from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import permission_classes, authentication_classes
from rest_framework.authentication import TokenAuthentication, SessionAuthentication


@api_view(["POST"])
@authentication_classes([])
@permission_classes([])
def login(request):
    """
    This view logs in a user and returns a token

    request format:
        {
            "username": username,
            "password": password
        }

    response format:
        {
            "token": token,
        }
    """
    if "username" not in request.data:
        return Response({"error": "Missing username"}, status=status.HTTP_400_BAD_REQUEST)

    if "password" not in request.data:
        return Response({"error": "Missing password"}, status=status.HTTP_400_BAD_REQUEST)

    user = get_object_or_404(User, username=request.data["username"])

    if not user.check_password(request.data["password"]):
        return Response({"error": "Invalid password"}, status=status.HTTP_400_BAD_REQUEST)

    token, created = Token.objects.get_or_create(user=user)

    return Response({"token": token.key}, status=status.HTTP_200_OK)


@api_view(["POST"])
@authentication_classes([TokenAuthentication, SessionAuthentication])
@permission_classes([IsAuthenticated])
def logout(request):
    """
    This view logs out a user by deleting their token

    request format:
        {
            "device_id": device_id
        }

    response format:
        {
            "success": "Successfully logged out"
        }
    """
    try:
        if "device_id" not in request.data:
            return Response({"error": "Missing device_id"}, status=status.HTTP_400_BAD_REQUEST)

        # Delete device
        device = get_object_or_404(FCMDevice, device_id=request.data["device_id"])
        device.delete()

        # Delete the token
        token = get_object_or_404(Token, user=request.user)
        token.delete()

        return Response({"success": "Successfully logged out"}, status=status.HTTP_200_OK)
    except Token.DoesNotExist:
        return Response({"error": "Invalid token"}, status=status.HTTP_400_BAD_REQUEST)


@api_view(["POST"])
@authentication_classes([])
@permission_classes([])
def signup(request):
    """
    This view creates a new user and returns a token

    request format:
        {
            "username": username,
            "email": email,
            "password": password
        }

    response format:
        {
            "token": token,
        }
    """
    serializer = UserSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        user = User.objects.get(username=request.data["username"])
        user.set_password(request.data["password"])
        user.save()
        token = Token.objects.create(user=user)
        return Response({"token": token.key, "user": serializer.data}, status=status.HTTP_201_CREATED)

    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(["GET"])
@authentication_classes([TokenAuthentication, SessionAuthentication])
@permission_classes([IsAuthenticated])
def test_token(request):
    """
    Verifies that the token is valid and returns the username
    """
    return Response({"username": request.user.username}, status=status.HTTP_200_OK)
