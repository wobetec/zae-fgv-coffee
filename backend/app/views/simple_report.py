from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import permission_classes, authentication_classes
from rest_framework.authentication import TokenAuthentication, SessionAuthentication
from django.db.models import Sum
from datetime import datetime
from app.models import VendingMachine, Order, Sell
from app.permissions import IsSupportUser

from app.views.report_builder import *

@api_view(["GET"])
@authentication_classes([TokenAuthentication, SessionAuthentication])
@permission_classes([IsAuthenticated, IsSupportUser])
def daily_report(request):
    # Extract the date from the query parameters
    report_date_str = request.query_params.get("date")
    if not report_date_str:
        return Response(
            {"error": "The 'date' parameter is required."},
            status=status.HTTP_400_BAD_REQUEST,
        )

    try:
        # Parse the date
        report_date = datetime.strptime(report_date_str, "%Y-%m-%d").date()
    except ValueError:
        return Response(
            {"error": "Invalid date format. Use 'YYYY-MM-DD'."},
            status=status.HTTP_400_BAD_REQUEST,
        )

    # Fetch vending machine data
    vending_machines = VendingMachine.objects.all()
    vending_machine_count = vending_machines.count()

    # Fetch purchase data for the given date
    orders = Order.objects.filter(order_date__date=report_date)
    total_sales = orders.aggregate(Sum("order_total"))["order_total__sum"] or 0
    total_orders = orders.count()

    # Fetch sold products for the given date
    sells = Sell.objects.filter(order__order_date__date=report_date)
    total_items_sold = sells.aggregate(Sum("sell_quantity"))["sell_quantity__sum"] or 0

    builder = DetailedReportBuilder()

    director = ReportDirector(builder)
    report = director.construct_report(report_date, vending_machines, total_orders, total_sales, total_items_sold)

    response = Response(
        {
            "date": report_date_str,
            "content": report.as_html(),
        },
        status=status.HTTP_200_OK,
    )

    return response
