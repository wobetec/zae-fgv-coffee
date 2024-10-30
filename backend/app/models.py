from django.db import models
from django.contrib.auth.models import AbstractUser, Group, Permission


class User(AbstractUser):
    is_support_user = models.BooleanField(default=False)

    # Set related_name to avoid clashes with the default User model
    groups = models.ManyToManyField(
        Group,
        related_name='custom_user_set',  # Change to something unique
        blank=True,
        help_text='The groups this user belongs to. A user will get all permissions granted to each of their groups.',
        verbose_name='groups',
    )

    user_permissions = models.ManyToManyField(
        Permission,
        related_name='custom_user_set',  # Change to something unique
        blank=True,
        help_text='Specific permissions for this user.',
        verbose_name='user permissions',
    )

    def __str__(self):
        return self.username


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
    user = models.OneToOneField(User, on_delete=models.DO_NOTHING)

    def save(self, *args, **kwargs):
        if not self.user.is_support_user:
            self.user.is_support_user = True
            self.user.save()
        super().save(*args, **kwargs)

    def delete(self, *args, **kwargs):
        if self.user.is_support_user:
            self.user.is_support_user = False
            self.user.save()
        super().delete(*args, **kwargs)

    def __str__(self):
        return self.user.username


class Order(models.Model):
    order_id = models.CharField(max_length=50, primary_key=True, auto_created=True)
    order_total = models.DecimalField(max_digits=100, decimal_places=2)
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
