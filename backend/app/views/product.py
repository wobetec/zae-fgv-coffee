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

from app import models, serializers


@api_view(["GET"])
@authentication_classes([TokenAuthentication, SessionAuthentication])
@permission_classes([IsAuthenticated])
def product(request):
    prod_id = request.query_params.get("prod_id")
    if not prod_id:
        return Response(
            {"error": "Missing product ID"}, status=status.HTTP_400_BAD_REQUEST
        )

    product = models.Product.objects.filter(prod_id=prod_id)
    if not product:
        return Response(
            {"error": "Product not found"}, status=status.HTTP_404_NOT_FOUND
        )
    serializer = serializers.ProductSerializer(product[0])
    return Response(serializer.data, status=status.HTTP_200_OK)


@api_view(["GET"])
@authentication_classes([TokenAuthentication, SessionAuthentication])
@permission_classes([IsAuthenticated])
def product_all(request):
    products = models.Product.objects.all()

    if vm_id := request.query_params.get("vm_id"):
        vending_machine = models.VendingMachine.objects.filter(vm_id=vm_id)

        if not vending_machine:
            return Response(
                {"error": "Vending machine not found"}, status=status.HTTP_404_NOT_FOUND
            )

        stock = models.Stock.objects.filter(vending_machine=vending_machine[0])
        stock_products = [s.product for s in stock]
        if stock:
            products = [p for p in products if p in stock_products]

    serializer = serializers.ProductSerializer(products, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)


@api_view(["GET", "POST", "DELETE"])
@authentication_classes([TokenAuthentication, SessionAuthentication])
@permission_classes([IsAuthenticated])
def product_favorite(request):
    if request.method == "GET":
        user = request.user
        wishlist = models.Wishlist.objects.filter(user=user)
        serializer = serializers.WishlistSerializer(wishlist, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    user = request.user
    prod_id = request.data.get("prod_id")
    if not prod_id:
        return Response(
            {"error": "Missing product ID"}, status=status.HTTP_400_BAD_REQUEST
        )
    vm_id = request.data.get("vm_id")
    if not vm_id:
        return Response(
            {"error": "Missing vending machine ID"}, status=status.HTTP_400_BAD
        )

    product = get_object_or_404(models.Product, prod_id=prod_id)
    vending_machine = get_object_or_404(models.VendingMachine, vm_id=vm_id)

    exists = models.Wishlist.objects.filter(
        user=user, product=product, vending_machine=vending_machine
    ).exists()

    if request.method == "POST":
        if exists:
            return Response(
                {"error": "Product already in wishlist"}, status=status.HTTP_400_BAD_REQUEST
            )
        wishlist = models.Wishlist.objects.create(
            user=user, product=product, vending_machine=vending_machine
        )
        serializer = serializers.WishlistSerializer(wishlist)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    if request.method == "DELETE":
        if not exists:
            return Response(
                {"error": "Product not in wishlist"}, status=status.HTTP_400_BAD_REQUEST
            )
        wishlist = get_object_or_404(
            models.Wishlist, user=user, product=product, vending_machine=vending_machine
        )
        wishlist.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


@api_view(["GET"])
@authentication_classes([TokenAuthentication, SessionAuthentication])
@permission_classes([IsAuthenticated])
def product_rating(request):
    prod_id = request.query_params.get("prod_id")
    if not prod_id:
        return Response(
            {"error": "Missing product ID"}, status=status.HTTP_400_BAD_REQUEST
        )

    product = get_object_or_404(models.Product, prod_id=prod_id)
    ratings = models.Rating.objects.filter(product=product)
    serializer = serializers.RatingSerializer(ratings, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)
