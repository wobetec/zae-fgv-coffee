from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from rest_framework.authtoken.models import Token
from app import models, factories
from datetime import datetime
import random


class VendingMachineReportTests(APITestCase):
    def setUp(self):
        # Create user and token
        self.url = reverse("app:daily_report")
        self.user = models.User.objects.create(username="testuser")
        self.user.set_password("testpassword")
        self.support_user = models.SupportUser.objects.create(user=self.user)
        self.token = Token.objects.create(user=self.user)

        # Create data for the report
        self.vending_machines = factories.VendingMachineFactory.create_batch(5)
        self.products = factories.ProductFactory.create_batch(10)

        # Create orders and sales for a specific date
        self.report_date = datetime(2024, 12, 5)
        for vm in self.vending_machines:
            order = factories.OrderFactory.create(
                user=self.user, vending_machine=vm, order_date=self.report_date
            )
            factories.SellFactory.create(
                order=order, product=random.choice(self.products), sell_quantity=5
            )

    def test_get_report_valid_date(self):
        """
        Test that the report view returns a valid JSON response for a given date.
        """
        response = self.client.get(
            f'{self.url}?date={self.report_date.strftime("%Y-%m-%d")}',
            HTTP_AUTHORIZATION=f"Token {self.token.key}",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("date", response.data)
        self.assertIn("content", response.data)

    def test_get_report_missing_date(self):
        """
        Test that the report view returns a 400 error when the date is missing.
        """
        response = self.client.get(self.url, HTTP_AUTHORIZATION=f"Token {self.token.key}")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn("error", response.data)

    def test_get_report_no_data(self):
        """
        Test the report view for a date with no orders or vending machines.
        """
        empty_date = "2024-12-01"
        response = self.client.get(
            f"{self.url}?date={empty_date}", HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("date", response.data)
        self.assertIn("content", response.data)
