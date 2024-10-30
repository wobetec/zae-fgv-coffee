"""
Define serializers for the app application.
"""
from rest_framework import serializers
from fcm_django.models import FCMDevice
from .models import (
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


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'password']


class FCMDeviceSerializer(serializers.ModelSerializer):
    class Meta:
        model = FCMDevice
        fields = ['id', 'name', 'device_id', 'registration_id', 'type', 'user']
        read_only_fields = ['id', 'user']
        extra_kwargs = {
            'device_id': {'required': True},
            'registration_id': {'required': True},
            'type': {'required': True},
        }


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


class SupportUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = SupportUser
        fields = ['id', 'username', 'email', 'password']


class OrderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Order
        fields = ['order_id', 'order_total', 'order_date', 'user', 'vending_machine']


class RatingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Rating
        fields = ['user', 'product', 'rating_star', 'rating_description', 'rating_date_update']


class SellSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sell
        fields = ['product', 'vending_machine', 'sell_quantity', 'sell_date_update']


class WishlistSerializer(serializers.ModelSerializer):
    class Meta:
        model = Wishlist
        fields = ['user', 'product', 'vending_machine']
