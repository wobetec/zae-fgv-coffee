"""
Views to handle product information and operations
"""

from django.shortcuts import get_object_or_404
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import permission_classes, authentication_classes
from rest_framework.authentication import TokenAuthentication, SessionAuthentication

from app.views.notification import ZeroStockFavoriteProductsObserver
from app import models
from app.utils.observer import Subject, Observer


class ZeroStockPublisher(Subject):
    _observers: list[Observer] = []

    def attach(self, observer: Observer) -> None:
        self._observers.append(observer)
        print(self._observers)

    def detach(self, observer: Observer) -> None:
        self._observers.remove(observer)

    def notify(self, zero_stocks: list) -> None:
        for observer in self._observers:
            observer.update(zero_stocks)


zero_stock_publisher = ZeroStockPublisher()
zero_stock_publisher.attach(ZeroStockFavoriteProductsObserver())


@api_view(["POST"])
@authentication_classes([TokenAuthentication, SessionAuthentication])
@permission_classes([IsAuthenticated])
def purchase(request):
    user = request.user
    if request.method == "POST":
        vm_id = request.data.get("vm_id")
        if not vm_id:
            return Response(
                {"error": "Missing vending machine ID"},
                status=status.HTTP_400_BAD_REQUEST,
            )
        vending_machine = get_object_or_404(models.VendingMachine, vm_id=vm_id)

        products_ = request.data.get("products")
        if not products_ or not isinstance(products_, list) or len(products_) == 0:
            return Response(
                {"error": "Missing products"}, status=status.HTTP_400_BAD_REQUEST
            )

        products = []
        for product in products_:
            prod_id = product.get("prod_id")
            if not prod_id:
                return Response(
                    {"error": "Missing product ID"}, status=status.HTTP_400_BAD_REQUEST
                )
            product_obj = get_object_or_404(models.Product, prod_id=prod_id)

            quantity = product.get("quantity")
            if not quantity:
                return Response(
                    {"error": "Missing quantity"}, status=status.HTTP_400_BAD_REQUEST
                )

            stock_obj = get_object_or_404(
                models.Stock, vending_machine=vending_machine, product=product_obj
            )
            if stock_obj.stock_quantity < quantity:
                return Response(
                    {"error": "Not enough stock"}, status=status.HTTP_400_BAD_REQUEST
                )

            products.append((product_obj, stock_obj, quantity))

        order = models.Order.objects.create(
            user=user, vending_machine=vending_machine, order_total=0,
        )
        total = 0
        for product_obj, stock_obj, quantity in products:
            models.Sell.objects.create(
                order=order,
                product=product_obj,
                sell_quantity=quantity,
            )
            total += product_obj.prod_price * quantity
        order.order_total = total
        order.save()

        zero_stock = []
        for product_obj, stock_obj, quantity in products:
            stock_obj.stock_quantity -= quantity
            stock_obj.save()
            if stock_obj.stock_quantity == 0:
                zero_stock.append(stock_obj)

        if zero_stock:
            zero_stock_publisher.notify(zero_stock)

        return Response({"success": "Purchase successful"}, status=status.HTTP_200_OK)

    return Response(
        {"error": "Method not allowed"}, status=status.HTTP_405_METHOD_NOT_ALLOWED
    )
