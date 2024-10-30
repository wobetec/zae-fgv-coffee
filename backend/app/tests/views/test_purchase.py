from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from rest_framework.authtoken.models import Token
from fcm_django.models import FCMDevice
from app.models import User


class TestPurchase(APITestCase):
    
    def setUp(self):
        self.url = reverse("app:purchase")
        self.user = User.objects.create_user(
            username="testuser",
            password="testpassword",
            email="testuser@email.com"
        )
        self.token = Token.objects.create(user=self.user)

    def test_purchase_without_devices(self):
        response = self.client.post(self.url, format="json")

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(response.data, {"error": "No devices registered"})
    
    def test_purchase_with_devices(self):
        FCMDevice.objects.create(
            user=self.user,
            device_id="1234567890",
            type="android",
            registration_id="fcm_token"
        )
        response = self.client.post(self.url, format="json")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, {"success": "Notification sent"})
