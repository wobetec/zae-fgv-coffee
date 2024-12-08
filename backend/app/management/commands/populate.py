import random
import os
from django.core.management.base import BaseCommand
from django.core.management import call_command
from django.conf import settings
from app.factories import (
    OrderFactory,
    RatingFactory,
    SellFactory,
    SupportUserFactory,
    UserFactory,
    ProductFactory,
    VendingMachineFactory,
    StockFactory,
    WishlistFactory,
)


class Command(BaseCommand):
    help = 'Populate the database with random data using python Faker'

    def add_arguments(self, parser):
        parser.add_argument('--users', '-u', type=int, default=20, help='Number of users to create')
        parser.add_argument('--products', '-p', type=int, default=10, help='Number of products to create')
        parser.add_argument('--machines', '-m', type=int, default=10, help='Number of machines to create')
        parser.add_argument('--orders', '-o', type=int, default=5, help='Create orders per user to create')
        parser.add_argument('--ratings', '-r', type=int, default=4, help='Create ratings per user to create')
        parser.add_argument('--sells', '-s', type=int, default=4, help='Create sells per order to create')

    def handle(self, *args, **kwargs):
        db_file = settings.DATABASES['default']['NAME']
        self.stdout.write('Populating database')

        self.stdout.write('\tReseting database')
        if os.path.exists(db_file):
            os.remove(db_file)
            self.stdout.write('\t\tDatabase file deleted.')
        self.stdout.write('\t\tApplying migrations')
        call_command('migrate')

        self.stdout.write('\tCreating admin user')
        UserFactory.create(
            username='admin',
            email='admin@admin.com',
            password='admin',
            is_superuser=True,
            is_staff=True
        )

        self.stdout.write('\tCreating users')
        users = UserFactory.create_batch(kwargs['users'])

        self.stdout.write('\tCreating support users')
        SupportUserFactory.create_batch(3)

        self.stdout.write('\tCreating products')
        products = ProductFactory.create_batch(kwargs['products'])

        self.stdout.write('\tCreating vending machines')
        machines = VendingMachineFactory.create_batch(kwargs['machines'])

        self.stdout.write('\tCreating stock')
        stocks = []
        for product in products:
            for machine in machines:
                stocks.append(StockFactory.create(product=product, vending_machine=machine))

        self.stdout.write('\tCreating orders')
        orders = []
        for user in users:
            for machine in random.sample(machines, kwargs['orders']):
                orders.append(OrderFactory.create(user=user, vending_machine=machine))

        self.stdout.write('\tCreating ratings')
        ratings = []
        for user in users:
            for product in random.sample(products, kwargs['ratings']):
                ratings.append(RatingFactory.create(user=user, product=product))

        self.stdout.write('\tCreating sells')
        sells = []
        for order in orders:
            for product in random.sample(products, random.randint(1, kwargs['sells'])):
                sells.append(SellFactory.create(order=order, product=product))

        self.stdout.write('\tCreating wishlists')
        wishlists = []
        for user in users:
            for product in random.sample(products, random.randint(1, kwargs['ratings'])):
                wishlists.append(WishlistFactory.create(user=user, product=product))

        self.stdout.write(self.style.SUCCESS('Successfully created'))
