import random
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from rest_framework.authtoken.models import Token
from app import models, factories


class RatingTests(APITestCase):
    def setUp(self):
        self.url = reverse("app:rating")
        self.user = models.User.objects.create(username="testuser")
        self.user.set_password("testpassword")
        self.user.save()
        self.token = Token.objects.create(user=self.user)

        self.ratings = []
        for i in range(10):
            item = factories.RatingFactory.create(user=self.user)
            self.ratings.append(item)

    def test_get_rating(self):
        response = self.client.get(
            self.url, HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 10)
        rating = response.data[0]
        self.assertIn("user", rating)
        self.assertIn("product", rating)
        self.assertIn("rating_star", rating)
        self.assertIn("rating_description", rating)
        self.assertIn("rating_date_update", rating)

    def test_post_rating(self):
        product = factories.ProductFactory()
        data = {
            "prod_id": product.prod_id,
            "rating_star": random.randint(1, 5),
            "rating_description": "Test description",
        }
        response = self.client.post(
            self.url, data, HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIn("user", response.data)
        self.assertIn("product", response.data)
        self.assertIn("rating_star", response.data)
        self.assertIn("rating_description", response.data)
        self.assertIn("rating_date_update", response.data)

    def test_delete_rating(self):
        rating = self.ratings[0]
        data = {"prod_id": rating.product.prod_id}
        response = self.client.delete(
            self.url, data, HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
