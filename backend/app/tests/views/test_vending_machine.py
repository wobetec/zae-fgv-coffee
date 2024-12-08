from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from rest_framework.authtoken.models import Token
from app import models, factories


class VendingMachineTests(APITestCase):
    def setUp(self):
        self.url = reverse("app:vending_machine")
        self.user = models.User.objects.create(username="testuser")
        self.user.set_password("testpassword")
        self.user.save()
        self.token = Token.objects.create(user=self.user)

        self.vending_machines = factories.VendingMachineFactory.create_batch(10)

    def test_vending_machines(self):
        response = self.client.get(
            self.url, HTTP_AUTHORIZATION=f"Token {self.token.key}"
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 10)

        vending_machine = response.data[0]
        self.assertIn("vm_id", vending_machine)
        self.assertIn("vm_floor", vending_machine)
