from rest_framework.test import APITestCase

from app.models import SupportUser, User


class TestUserModel(APITestCase):
    def setUp(self):
        self.user = User.objects.create(
            username='testuser',
            password='testpassword',
            email='testuser@email.com'
        )

    def test_user_model(self):
        self.assertEqual(self.user.username, 'testuser')
        self.assertEqual(self.user.password, 'testpassword')
        self.assertEqual(self.user.email, 'testuser@email.com')
        self.assertFalse(self.user.is_support_user)


class TestSupportUserModel(APITestCase):
    def setUp(self):
        self.user = User.objects.create(
            username='supportuser',
            password='supportpassword',
            email='supportuser@email.com',
        )
        self.support_user = SupportUser.objects.create(user=self.user)

    def test_support_user_model(self):
        self.assertEqual(self.support_user.user.username, 'supportuser')
        self.assertEqual(self.support_user.user.password, 'supportpassword')
        self.assertEqual(self.support_user.user.email, 'supportuser@email.com')
        self.assertTrue(self.support_user.user.is_support_user)
