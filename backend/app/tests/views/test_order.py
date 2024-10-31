from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from rest_framework.authtoken.models import Token
from app import models, factories
from urllib.parse import urlencode


class OrderTests(APITestCase):
    def setUp(self):
        self.url = reverse("app:order")
        self.user = models.User.objects.create(username="testuser")
        self.user.set_password("testpassword")
        self.user.save()
        self.token = Token.objects.create(user=self.user)

        self.orders = []
        for i in range(10):
            order = factories.OrderFactory(user=self.user)
            self.orders.append(order)

    def test_get_order(self):
        order_id = self.orders[0].order_id
        url = f'{self.url}?{urlencode({"order_id": order_id})}'
        response = self.client.get(url, HTTP_AUTHORIZATION=f"Token {self.token.key}")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["order_id"], order_id)
        self.assertIn("order_date", response.data)
        self.assertIn("order_total", response.data)

    def test_get_order_missing_id(self):
        response = self.client.get(
            self.url, HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)


class OrderAllTests(APITestCase):
    def setUp(self):
        self.url = reverse("app:order/all")
        self.user = models.User.objects.create(username="testuser")
        self.user.set_password("testpassword")
        self.user.save()
        self.token = Token.objects.create(user=self.user)

        self.orders = []
        for i in range(10):
            order = factories.OrderFactory(user=self.user)
            self.orders.append(order)

    def test_get_order_all(self):
        response = self.client.get(
            self.url, HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 10)

        order = response.data[0]
        self.assertIn("order_id", order)
        self.assertIn("order_date", order)
        self.assertIn("order_total", order)
        self.assertIn("user", order)
        self.assertIn("vending_machine", order)
        self.assertIn("products", order)

    def test_get_order_all_no_orders(self):
        models.Order.objects.all().delete()
        response = self.client.get(
            self.url, HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)
