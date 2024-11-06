from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from rest_framework.authtoken.models import Token
from app import factories, models
from app.views.notification import notify_out_of_stock_favorite_products


class RegisterDeviceTests(APITestCase):

    def setUp(self):
        self.url = reverse("app:register_device")
        self.user = models.User.objects.create_user(
            username="testuser", password="testpassword", email="testuser@email.com"
        )
        self.token = Token.objects.create(user=self.user)

    def test_register_device(self):
        data = {
            "device_id": "1234567890",
            "type": "android",
            "registration_id": "fcm_token",
        }
        response = self.client.post(
            self.url, data, format="json", HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_recreate_registration_id(self):
        data = {
            "device_id": "1234567890",
            "type": "android",
            "registration_id": "fcm_token",
        }
        response = self.client.post(
            self.url, data, format="json", HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        response = self.client.post(
            self.url, data, format="json", HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_recreate_device(self):
        data = {
            "device_id": "1234567890",
            "type": "android",
            "registration_id": "fcm_token",
        }
        response = self.client.post(
            self.url, data, format="json", HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        data["registration_id"] = "new_fcm_token"
        response = self.client.post(
            self.url, data, format="json", HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)


class NotifyOutOfStockFavoriteProductsTests(APITestCase):

    def setUp(self):
        self.user = models.User.objects.create_user(
            username="testuser", password="testpassword", email="testuser@email.com"
        )
        self.token = Token.objects.create(user=self.user)

    def test_notify_out_of_stock_favorite_products(self):
        stock = factories.StockFactory(stock_quantity=0)
        factories.WishlistFactory(product=stock.product, user=self.user)
        notify_out_of_stock_favorite_products([stock])
