import factory
from factory.django import DjangoModelFactory
from factory.faker import faker

from app.models import (
    User,
    Product,
    VendingMachine,
    Stock,
    Wishlist,
    SupportUser,
    Order,
    Rating,
    Sell
)

FAKE = faker.Faker()


class UserFactory(DjangoModelFactory):
    class Meta:
        model = User

    username = factory.Faker('user_name')
    email = factory.Faker('email')
    password = factory.PostGenerationMethodCall(
        'set_password', 'defaultpassword'
    )


class SupportUserFactory(DjangoModelFactory):
    class Meta:
        model = SupportUser

    user = factory.SubFactory(UserFactory)


class ProductFactory(DjangoModelFactory):
    class Meta:
        model = Product

    prod_id = factory.Faker('uuid4')
    prod_name = factory.Faker('sentence', nb_words=3)
    prod_description = factory.Faker('sentence')
    prod_price = factory.Faker('random_int', min=2, max=20)


class VendingMachineFactory(DjangoModelFactory):
    class Meta:
        model = VendingMachine

    vm_id = factory.Faker('uuid4')
    vm_floor = factory.Faker('random_int', min=2, max=13)


class StockFactory(DjangoModelFactory):
    class Meta:
        model = Stock

    product = factory.SubFactory(ProductFactory)
    vending_machine = factory.SubFactory(VendingMachineFactory)
    stock_quantity = factory.Faker('random_int', min=0, max=20)
    stock_date_update = factory.Faker('date_time_this_month')


class OrderFactory(DjangoModelFactory):
    class Meta:
        model = Order

    order_id = factory.Faker('uuid4')
    order_total = factory.Faker('random_int', min=10, max=100)
    order_date = factory.Faker('date_time_this_month')
    user = factory.SubFactory(UserFactory)
    vending_machine = factory.SubFactory(VendingMachineFactory)


class RatingFactory(DjangoModelFactory):
    class Meta:
        model = Rating

    user = factory.SubFactory(UserFactory)
    product = factory.SubFactory(ProductFactory)
    rating_star = factory.Faker('random_int', min=1, max=5)
    rating_description = factory.Faker('sentence')
    rating_date_update = factory.Faker('date_time_this_month')


class SellFactory(DjangoModelFactory):
    class Meta:
        model = Sell

    order = factory.SubFactory(OrderFactory)
    product = factory.SubFactory(ProductFactory)
    sell_quantity = factory.Faker('random_int', min=0, max=20)
    sell_create_date = factory.Faker('date_time_this_month')


class WishlistFactory(DjangoModelFactory):
    class Meta:
        model = Wishlist

    user = factory.SubFactory(UserFactory)
    product = factory.SubFactory(ProductFactory)
    vending_machine = factory.SubFactory(VendingMachineFactory)
