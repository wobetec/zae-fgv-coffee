"""
Define serializers for the app application.
"""
from rest_framework import serializers
from fcm_django.models import FCMDevice
from django.db.models import Avg
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
        fields = ['id', 'username', 'email']


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


class StockSerializer(serializers.ModelSerializer):

    class Meta:
        model = Stock
        fields = ['product', 'vending_machine', 'stock_quantity']


class VendingMachineSerializer(serializers.ModelSerializer):
    class Meta:
        model = VendingMachine
        fields = ['vm_id', 'vm_floor']


class ProductSerializer(serializers.ModelSerializer):
    stock = serializers.SerializerMethodField()
    rating = serializers.SerializerMethodField()

    class Meta:
        model = Product
        fields = ['prod_id', 'prod_name', 'prod_description', 'prod_price', 'stock', 'rating']

    def get_stock(self, obj):
        stock = Stock.objects.filter(product=obj)
        serializer = StockSerializer(stock, many=True)
        stock = serializer.data
        for s in stock:
            vending_machine = VendingMachine.objects.get(vm_id=s['vending_machine'])
            vending_machine = VendingMachineSerializer(vending_machine).data
            s['vending_machine'] = vending_machine
            s.pop('product')
        return stock

    def get_rating(self, obj):
        ratings = Rating.objects.filter(product=obj)
        avg_rating = ratings.aggregate(Avg('rating_star'))['rating_star__avg']
        return avg_rating


class _SimpleProductSerializer(serializers.ModelSerializer):

    class Meta:
        model = Product
        fields = ['prod_id', 'prod_name', 'prod_description', 'prod_price']


class SupportUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = SupportUser
        fields = []

    def to_representation(self, instance):
        user = User.objects.get(id=instance.id)
        serializer = UserSerializer(user)
        return serializer.data


class SellSerializer(serializers.ModelSerializer):
    product = serializers.SerializerMethodField()

    class Meta:
        model = Sell
        fields = ['product', 'sell_quantity', 'sell_create_date']

    def get_product(self, obj):
        product = Product.objects.get(prod_id=obj.product.prod_id)
        serializer = _SimpleProductSerializer(product)
        return serializer.data


class OrderSerializer(serializers.ModelSerializer):
    vending_machine = serializers.SerializerMethodField()
    sells = serializers.SerializerMethodField()

    class Meta:
        model = Order
        fields = ['order_id', 'order_total', 'order_date', 'user', 'vending_machine', 'sells']

    def get_vending_machine(self, obj):
        vending_machine = VendingMachine.objects.get(vm_id=obj.vending_machine.vm_id)
        serializer = VendingMachineSerializer(vending_machine)
        return serializer.data

    def get_sells(self, obj):
        sells = Sell.objects.filter(order=obj)
        serializer = SellSerializer(sells, many=True)
        return serializer.data


class RatingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Rating
        fields = ['user', 'product', 'rating_star', 'rating_description', 'rating_date_update']


class WishlistSerializer(serializers.ModelSerializer):
    vending_machine = serializers.SerializerMethodField()
    product = serializers.SerializerMethodField()

    class Meta:
        model = Wishlist
        fields = ['user', 'product', 'vending_machine']

    def get_vending_machine(self, obj):
        vending_machine = VendingMachine.objects.get(vm_id=obj.vending_machine.vm_id)
        serializer = VendingMachineSerializer(vending_machine)
        return serializer.data

    def get_product(self, obj):
        product = Product.objects.get(prod_id=obj.product.prod_id)
        serializer = _SimpleProductSerializer(product)
        return serializer.data
