from django.contrib import admin
from .models import (
    Product,
    VendingMachine,
    Stock,
    Wishlist,
    SupportUser,
    Order,
    Rating,
    Sell
)

admin.site.register(Product)
admin.site.register(VendingMachine)
admin.site.register(Stock)
admin.site.register(Wishlist)
admin.site.register(SupportUser)
admin.site.register(Order)
admin.site.register(Rating)
admin.site.register(Sell)
