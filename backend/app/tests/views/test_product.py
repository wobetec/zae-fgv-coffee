import random
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from rest_framework.authtoken.models import Token
from urllib.parse import urlencode
from app import models, factories


class ProductTests(APITestCase):
    def setUp(self):
        self.url = reverse("app:product")
        self.user = models.User.objects.create(username="testuser")
        self.user.set_password("testpassword")
        self.user.save()
        self.token = Token.objects.create(user=self.user)

        self.products = factories.ProductFactory.create_batch(10)

    def test_get_product(self):
        prod_id = self.products[0].prod_id
        url = f'{self.url}?{urlencode({"prod_id": prod_id})}'
        response = self.client.get(url, HTTP_AUTHORIZATION=f"Token {self.token.key}")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["prod_id"], prod_id)
        self.assertIn("prod_name", response.data)
        self.assertIn("prod_price", response.data)

    def test_get_product_missing_id(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=f"Token {self.token.key}")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)


class ProductAllTests(APITestCase):
    def setUp(self):
        self.url = reverse("app:product/all")
        self.user = models.User.objects.create(username="testuser")
        self.user.set_password("testpassword")
        self.user.save()
        self.token = Token.objects.create(user=self.user)

        self.products = factories.ProductFactory.create_batch(10)

    def test_get_product_all(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=f"Token {self.token.key}")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 10)

        product = response.data[0]
        self.assertIn("prod_id", product)
        self.assertIn("prod_name", product)
        self.assertIn("prod_price", product)
        self.assertIn("prod_description", product)

    def test_get_product_all_no_products(self):
        models.Product.objects.all().delete()
        response = self.client.get(self.url, HTTP_AUTHORIZATION=f"Token {self.token.key}")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

    def test_filter_vending_machine(self):
        stock = factories.StockFactory.create_batch(2)
        vending_machine = stock[0].vending_machine.vm_id

        url = f'{self.url}?{urlencode({"vm_id": vending_machine})}'
        response = self.client.get(url, HTTP_AUTHORIZATION=f"Token {self.token.key}")

        self.assertEqual(response.status_code, status.HTTP_200_OK)


class ProductFavoriteTests(APITestCase):

    def setUp(self):
        self.url = reverse("app:product/favorite")
        self.user = models.User.objects.create(username="testuser")
        self.user.set_password("testpassword")
        self.user.save()
        self.token = Token.objects.create(user=self.user)

        self.products = factories.ProductFactory.create_batch(10)
        self.vending_machines = factories.VendingMachineFactory.create_batch(10)
        self.wishlist = []
        for product, vending_machine in random.sample(list(zip(self.products, self.vending_machines)), 5):
            item = factories.WishlistFactory.create(user=self.user, product=product, vending_machine=vending_machine)
            self.wishlist.append(item)

    def test_get_product_favorite(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=f"Token {self.token.key}")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 5)

    def test_add_product_favorite(self):
        product = self.products[0]
        vending_machine = self.vending_machines[-1]
        data = {
            "prod_id": product.prod_id,
            "vm_id": vending_machine.vm_id
        }
        response = self.client.post(self.url, data, HTTP_AUTHORIZATION=f"Token {self.token.key}")

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        wishlist = models.Wishlist.objects.filter(user=self.user)
        self.assertEqual(len(wishlist), 6)

    def test_delete_product_favorite(self):
        item = self.wishlist[0]
        data = {
            "prod_id": item.product.prod_id,
            "vm_id": item.vending_machine.vm_id
        }
        response = self.client.delete(self.url, data, HTTP_AUTHORIZATION=f"Token {self.token.key}")

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)

        wishlist = models.Wishlist.objects.filter(user=self.user)
        self.assertEqual(len(wishlist), 4)


class ProductRatingTests(APITestCase):

    def setUp(self):
        self.url = reverse("app:product/rating")
        self.user = models.User.objects.create(username="testuser")
        self.user.set_password("testpassword")
        self.user.save()
        self.token = Token.objects.create(user=self.user)

        self.product = factories.ProductFactory.create()
        users = factories.UserFactory.create_batch(10)
        self.ratings = []
        for user in users:
            item = factories.RatingFactory.create(user=user, product=self.product)
            self.ratings.append(item)

    def test_product_rating(self):
        url = f'{self.url}?{urlencode({"prod_id": self.product.prod_id})}'
        response = self.client.get(url, HTTP_AUTHORIZATION=f"Token {self.token.key}")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 10)
