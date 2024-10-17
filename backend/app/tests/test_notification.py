from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from django.contrib.auth.models import User
from rest_framework.authtoken.models import Token


class TestRegisterDevice(APITestCase):
    
    def setUp(self):
        self.url = reverse("app:register_device")
        self.user = User.objects.create_user(
            username="testuser",
            password="testpassword",
            email="testuser@email.com"
        )
        self.token = Token.objects.create(user=self.user)

    def test_register_device(self):
        data = {
            "device_id": "1234567890",
            "type": "android",
            "registration_id": "fcm_token"
        }
        response = self.client.post(self.url, data, format="json", HTTP_AUTHORIZATION=f"Token {self.token.key}")

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_recreate_registration_id(self):
        data = {
            "device_id": "1234567890",
            "type": "android",
            "registration_id": "fcm_token"
        }
        response = self.client.post(self.url, data, format="json", HTTP_AUTHORIZATION=f"Token {self.token.key}")

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        response = self.client.post(self.url, data, format="json", HTTP_AUTHORIZATION=f"Token {self.token.key}")

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_recreate_device(self):
        data = {
            "device_id": "1234567890",
            "type": "android",
            "registration_id": "fcm_token"
        }
        response = self.client.post(self.url, data, format="json", HTTP_AUTHORIZATION=f"Token {self.token.key}")

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        data["registration_id"] = "new_fcm_token"
        response = self.client.post(self.url, data, format="json", HTTP_AUTHORIZATION=f"Token {self.token.key}")

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
