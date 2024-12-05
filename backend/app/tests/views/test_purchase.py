from django.urls import reverse
from rest_framework import status
from app import factories, models
from rest_framework.test import APITestCase
from rest_framework.authtoken.models import Token


class PurchaseTests(APITestCase):

    def setUp(self):
        self.url = reverse("app:purchase")
        self.user = models.User.objects.create_user(
            username="testuser", password="testpassword", email="testuser@email.com"
        )
        self.token = Token.objects.create(user=self.user)
        self.products = factories.ProductFactory.create_batch(10)
        self.vending_machine = factories.VendingMachineFactory()
        self.stocks = []
        for product in self.products:
            self.stocks.append(
                factories.StockFactory(
                    product=product,
                    vending_machine=self.vending_machine,
                    stock_quantity=2,
                )
            )

    def test_purchase_missing_vm_id(self):
        data = {
            "products": [
                {"prod_id": self.products[0].prod_id, "quantity": 1},
                {"prod_id": self.products[1].prod_id, "quantity": 1},
            ]
        }
        response = self.client.post(
            self.url, data, HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_purchase_missing_products(self):
        data = {
            "vm_id": self.vending_machine.vm_id,
        }
        response = self.client.post(
            self.url, data, HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_purchase_empty_products(self):
        data = {"vm_id": self.vending_machine.vm_id, "products": []}
        response = self.client.post(
            self.url, data, HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_purchase_missing_product_id(self):
        data = {
            "vm_id": self.vending_machine.vm_id,
            "products": [
                {"quantity": 1},
                {"prod_id": self.products[1].prod_id, "quantity": 1},
            ],
        }
        response = self.client.post(
            self.url, data, HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_purchase_missing_quantity(self):
        data = {
            "vm_id": self.vending_machine.vm_id,
            "products": [
                {"prod_id": self.products[0].prod_id},
                {"prod_id": self.products[1].prod_id, "quantity": 1},
            ],
        }
        response = self.client.post(
            self.url, data, HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_purchase_not_enough_stock(self):
        data = {
            "vm_id": self.vending_machine.vm_id,
            "products": [
                {"prod_id": self.products[0].prod_id, "quantity": 3},
                {"prod_id": self.products[1].prod_id, "quantity": 1},
            ],
        }
        response = self.client.post(
            self.url, data, HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_purchase(self):
        data = {
            "vm_id": self.vending_machine.vm_id,
            "products": [
                {"prod_id": self.products[0].prod_id, "quantity": 1},
                {"prod_id": self.products[1].prod_id, "quantity": 1},
            ],
        }
        response = self.client.post(
            self.url, data, HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
