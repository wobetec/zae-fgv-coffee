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
    vm_id = models.CharField(max_length=50, primary_key=True)
    vm_floor = models.IntegerField()

    def __str__(self):
        return self.vm_id


class Stock(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    vending_machine = models.ForeignKey(VendingMachine, on_delete=models.CASCADE)
    stock_quantity = models.IntegerField()

    class Meta:
        unique_together = ('product', 'vending_machine')


class Wishlist(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    vending_machine = models.ForeignKey(VendingMachine, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('user', 'product', 'vending_machine')
    
    def __str__(self):
        return self.product.prod_name + ' in ' + self.vending_machine.vm_id + ' for ' + self.user.username