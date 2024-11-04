from django.db import models
from django.contrib.auth.models import User


class Product(models.Model):
    prod_id = models.CharField(max_length=50, primary_key=True, auto_created=True)
    prod_name = models.CharField(max_length=50)
    prod_description = models.CharField(max_length=200)
    prod_price = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return self.prod_name


class VendingMachine(models.Model):
    vm_id = models.CharField(max_length=50, primary_key=True, auto_created=True)
    vm_floor = models.IntegerField()

    def __str__(self):
        return f'Vending Machine {self.vm_id}'


class Stock(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='stocks')
    vending_machine = models.ForeignKey(VendingMachine, on_delete=models.CASCADE, related_name='stocks')
    stock_quantity = models.IntegerField()
    stock_date_update = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ('product', 'vending_machine')

    def __str__(self):
        return f'{self.product.prod_name} in {self.vending_machine.vm_id}'


class SupportUser(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)

    def __str__(self):
        return self.user.username


class Order(models.Model):
    order_id = models.CharField(max_length=50, primary_key=True, auto_created=True)
    order_total = models.DecimalField(max_digits=65, decimal_places=2)
    order_date = models.DateTimeField(auto_now_add=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='orders')
    vending_machine = models.ForeignKey(VendingMachine, on_delete=models.CASCADE, related_name='orders')

    def __str__(self):
        return f'Order {self.order_id}'


class Rating(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='ratings')
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='ratings')
    rating_star = models.IntegerField()
    rating_description = models.CharField(max_length=140)
    rating_date_update = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ('user', 'product', 'rating_date_update')

    def __str__(self):
        return f'Rating by {self.user.username} for {self.product.prod_name} on {self.rating_date_update}'


class Sell(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='sells')
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='sells')
    sell_quantity = models.IntegerField()
    sell_create_date = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('order', 'product')

    def __str__(self):
        return f'Sell {self.product.prod_name} in Order {self.order.order_id}'


class Wishlist(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='wishlist')
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='wishlist')
    vending_machine = models.ForeignKey(VendingMachine, on_delete=models.CASCADE, related_name='wishlist')

    class Meta:
        unique_together = ('user', 'product', 'vending_machine')

    def __str__(self):
        return f'{self.product.prod_name} in {self.vending_machine.vm_id} for {self.user.username}'
