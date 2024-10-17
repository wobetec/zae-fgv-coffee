"""
Define serializers for the app application.
"""
from rest_framework import serializers
from django.contrib.auth.models import User
from .models import *

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'password']

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ['prod_id', 'prod_name', 'prod_description', 'prod_price']
        
class VendingMachineSerializer(serializers.ModelSerializer):
    class Meta:
        model = VendingMachine
        fields = ['vm_id', 'vm_floor']

class StockSerializer(serializers.ModelSerializer):
    class Meta:
        model = Stock
        fields = ['product', 'vending_machine', 'stock_quantity']

class WishlistSerializer(serializers.ModelSerializer):
    class Meta:
        model = Wishlist
        fields = ['user', 'product', 'vending_machine']

