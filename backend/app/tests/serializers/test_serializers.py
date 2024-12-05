from rest_framework.test import APITestCase
from app import factories, serializers, models


class SerializersTests(APITestCase):

    def test_user(self):
        user = factories.UserFactory()
        serializer = serializers.UserSerializer(user)
        self.assertEqual(serializer.data["username"], user.username)
        for filed in ["id", "username", "email"]:
            self.assertIn(filed, serializer.data)
        for filed in ["password"]:
            self.assertNotIn(filed, serializer.data)

    def test_support_user(self):
        support_user = factories.SupportUserFactory()
        user = models.User.objects.get(id=support_user.id)
        serializer = serializers.SupportUserSerializer(support_user)

        self.assertEqual(serializer.data["username"], user.username)
        for filed in ["id", "username", "email"]:
            self.assertIn(filed, serializer.data)
        for filed in ["password"]:
            self.assertNotIn(filed, serializer.data)

    def test_vending_machine(self):
        vending_machine = factories.VendingMachineFactory()
        serializer = serializers.VendingMachineSerializer(vending_machine)
        self.assertEqual(serializer.data["vm_id"], vending_machine.vm_id)
        self.assertEqual(serializer.data["vm_floor"], vending_machine.vm_floor)
        for filed in ["vm_id", "vm_floor"]:
            self.assertIn(filed, serializer.data)

    def test_stock(self):
        stock = factories.StockFactory()
        serializer = serializers.StockSerializer(stock)

        self.assertEqual(serializer.data["stock_quantity"], stock.stock_quantity)
        self.assertEqual(serializer.data["product"], stock.product.prod_id)
        self.assertEqual(
            serializer.data["vending_machine"], stock.vending_machine.vm_id
        )

    def test_product(self):
        stock = factories.StockFactory.create_batch(10)
        product = stock[0].product
        factories.RatingFactory.create_batch(10, product=product)
        serializer = serializers.ProductSerializer(product)

        self.assertEqual(serializer.data["prod_id"], product.prod_id)
        self.assertEqual(serializer.data["prod_name"], product.prod_name)
        self.assertEqual(serializer.data["prod_description"], product.prod_description)
        self.assertEqual(serializer.data["prod_price"], f"{product.prod_price:.2f}")
        self.assertIn("stock", serializer.data)
        self.assertIsInstance(serializer.data["stock"], list)
        self.assertIn("vending_machine", serializer.data["stock"][0])
        self.assertIn("stock_quantity", serializer.data["stock"][0])
        self.assertIn("rating", serializer.data)

    def test_order(self):
        order = factories.OrderFactory()
        serializer = serializers.OrderSerializer(order)

        self.assertEqual(serializer.data["order_id"], order.order_id)
        self.assertEqual(serializer.data["order_total"], f"{order.order_total:.2f}")
        self.assertEqual(
            serializer.data["order_date"],
            order.order_date.strftime("%Y-%m-%dT%H:%M:%S.%fZ"),
        )
        self.assertEqual(serializer.data["user"], order.user.id)
        self.assertEqual(
            serializer.data["vending_machine"]["vm_id"], order.vending_machine.vm_id
        )
        self.assertIn("sells", serializer.data)
        self.assertIsInstance(serializer.data["sells"], list)

    def test_rating(self):
        rating = factories.RatingFactory()
        serializer = serializers.RatingSerializer(rating)

        self.assertEqual(
            serializer.data["rating_date_update"],
            rating.rating_date_update.strftime("%Y-%m-%dT%H:%M:%S.%fZ"),
        )
        self.assertEqual(serializer.data["rating_star"], rating.rating_star)
        self.assertEqual(
            serializer.data["rating_description"], rating.rating_description
        )
        self.assertEqual(serializer.data["product"], rating.product.prod_id)
        self.assertEqual(serializer.data["user"], rating.user.id)

    def test_sell(self):
        sell = factories.SellFactory()
        serializer = serializers.SellSerializer(sell)

        self.assertEqual(serializer.data["product"]["prod_id"], sell.product.prod_id)
        self.assertEqual(serializer.data["sell_quantity"], sell.sell_quantity)
        self.assertEqual(
            serializer.data["sell_create_date"],
            sell.sell_create_date.strftime("%Y-%m-%dT%H:%M:%S.%fZ"),
        )

    def test_wishlist(self):
        wishlist = factories.WishlistFactory()
        serializer = serializers.WishlistSerializer(wishlist)

        self.assertEqual(serializer.data["user"], wishlist.user.id)
        self.assertEqual(
            serializer.data["product"]["prod_id"], wishlist.product.prod_id
        )
        self.assertEqual(
            serializer.data["vending_machine"]["vm_id"], wishlist.vending_machine.vm_id
        )
