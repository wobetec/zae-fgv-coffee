from django.contrib import admin
from .models import Product, VendingMachine, Stock, Wishlist

admin.site.register(Product)
admin.site.register(VendingMachine)
admin.site.register(Stock)
admin.site.register(Wishlist)
