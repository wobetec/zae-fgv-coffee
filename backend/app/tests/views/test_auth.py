from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from rest_framework.authtoken.models import Token
from fcm_django.models import FCMDevice
from app import models


class LoginTests(APITestCase):

    def setUp(self):
        self.url = reverse("app:login")
        self.user = models.User.objects.create_user(
            username="testuser",
            password="testpassword",
            email="testuser@email.com",
        )

    def test_login(self):
        data = {
            "username": "testuser",
            "password": "testpassword",
        }
        response = self.client.post(self.url, data, format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("token", response.data)

    def test_invalid_password(self):
        data = {
            "username": "testuser",
            "password": "wrongpassword",
        }
        response = self.client.post(self.url, data, format="json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn("error", response.data)
        self.assertEqual(response.data["error"], "Invalid password")

    def test_invalid_username(self):
        data = {
            "username": "wronguser",
            "password": "testpassword",
        }
        response = self.client.post(self.url, data, format="json")
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_missing_username(self):
        data = {
            "password": "testpassword",
        }
        response = self.client.post(self.url, data, format="json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn("error", response.data)
        self.assertEqual(response.data["error"], "Missing username")

    def test_missing_password(self):
        data = {
            "username": "testuser",
        }
        response = self.client.post(self.url, data, format="json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn("error", response.data)
        self.assertEqual(response.data["error"], "Missing password")


class LoginSupportUserTests(APITestCase):

    def setUp(self):
        self.url = reverse("app:login_support_user")
        self.user = models.User.objects.create_user(
            username="testuser",
            password="testpassword",
            email="testuser@email.com",
        )
        self.support_user = models.SupportUser.objects.create(user=self.user)

    def test_login(self):
        data = {
            "username": "testuser",
            "password": "testpassword",
        }
        response = self.client.post(self.url, data, format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("token", response.data)

    def test_invalid_password(self):
        data = {
            "username": "testuser",
            "password": "wrongpassword",
        }
        response = self.client.post(self.url, data, format="json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn("error", response.data)
        self.assertEqual(response.data["error"], "Invalid password")

    def test_invalid_username(self):
        data = {
            "username": "wronguser",
            "password": "testpassword",
        }
        response = self.client.post(self.url, data, format="json")
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_missing_username(self):
        data = {
            "password": "testpassword",
        }
        response = self.client.post(self.url, data, format="json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn("error", response.data)
        self.assertEqual(response.data["error"], "Missing username")

    def test_missing_password(self):
        data = {
            "username": "testuser",
        }
        response = self.client.post(self.url, data, format="json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn("error", response.data)
        self.assertEqual(response.data["error"], "Missing password")


class LogoutTests(APITestCase):

    def setUp(self):
        self.url = reverse("app:logout")
        self.user = models.User.objects.create_user(
            username="testuser",
            password="testpassword",
            email="testuser@email.com",
        )
        self.token = Token.objects.create(user=self.user)
        self.device = FCMDevice.objects.create(
            device_id="1234567890",
            type="android",
            registration_id="fcm_token",
        )

    def test_logout(self):
        # Verify token
        response = self.client.get(
            reverse("app:test_token"), HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        response = self.client.post(
            self.url,
            data={"device_id": self.device.device_id},
            HTTP_AUTHORIZATION=f"Token {self.token.key}",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Verify token
        response = self.client.get(
            reverse("app:test_token"), HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


class LogoutSupportUserTests(APITestCase):

    def setUp(self):
        self.url = reverse("app:logout_support_user")
        self.user = models.User.objects.create_user(
            username="testuser",
            password="testpassword",
            email="testuser@email.com",
        )
        self.support_user = models.SupportUser.objects.create(user=self.user)
        self.token = Token.objects.create(user=self.user)
        self.device = FCMDevice.objects.create(
            device_id="1234567890",
            type="android",
            registration_id="fcm_token",
        )

    def test_logout(self):
        # Verify token
        response = self.client.get(
            reverse("app:test_token_support_user"),
            HTTP_AUTHORIZATION=f"Token {self.token.key}",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        response = self.client.post(
            self.url,
            data={"device_id": self.device.device_id},
            HTTP_AUTHORIZATION=f"Token {self.token.key}",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Verify token
        response = self.client.get(
            reverse("app:test_token_support_user"),
            HTTP_AUTHORIZATION=f"Token {self.token.key}",
        )
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


class SignUpTests(APITestCase):

    def setUp(self):
        self.url = reverse("app:signup")

    def test_signup(self):
        data = {
            "username": "testuser",
            "password": "testpassword",
            "email": "testuser@email.com",
        }
        response = self.client.post(self.url, data, format="json")
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIn("token", response.data)

    def test_missing_username(self):
        data = {
            "password": "testpassword",
            "email": "testuser@email.com",
        }
        response = self.client.post(self.url, data, format="json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_missing_password(self):
        data = {
            "username": "testuser",
            "email": "testuser@email.com",
        }
        response = self.client.post(self.url, data, format="json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_existing_user(self):
        data = {
            "username": "testuser",
            "password": "testpassword",
            "email": "testuser@email.com",
        }
        response = self.client.post(self.url, data, format="json")
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        response = self.client.post(self.url, data, format="json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)


class TestTokenTests(APITestCase):

    def setUp(self):
        self.url = reverse("app:test_token")
        self.user = models.User.objects.create_user(
            username="testuser",
            password="testpassword",
            email="testuser@email.com",
        )
        self.token = Token.objects.create(user=self.user)

    def test_test_token(self):
        response = self.client.get(
            self.url, HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("username", response.data)
        self.assertEqual(response.data["username"], self.user.username)

    def test_invalid_token(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION="Token invalid_token")

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


class TestTokenSupportUserTests(APITestCase):

    def setUp(self):
        self.url = reverse("app:test_token_support_user")
        self.user = models.User.objects.create_user(
            username="testuser",
            password="testpassword",
            email="testuser@email.com",
        )
        self.support_user = models.SupportUser.objects.create(user=self.user)
        self.token = Token.objects.create(user=self.user)

    def test_test_token(self):
        response = self.client.get(
            self.url, HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("username", response.data)
        self.assertEqual(response.data["username"], self.user.username)

    def test_invalid_token(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION="Token invalid_token")

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_not_support_user(self):
        user = models.User.objects.create_user(
            username="testuser2",
            password="testpassword",
            email="testuser@email.com",
        )
        token = Token.objects.create(user=user)
        response = self.client.get(self.url, HTTP_AUTHORIZATION=f"Token {token.key}")
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
