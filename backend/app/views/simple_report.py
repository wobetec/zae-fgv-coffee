from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import permission_classes, authentication_classes
from rest_framework.authentication import TokenAuthentication, SessionAuthentication
from django.db.models import Sum
from datetime import datetime
from app.models import VendingMachine, Order, Sell

@api_view(["GET"])
@authentication_classes([TokenAuthentication, SessionAuthentication])
@permission_classes([IsAuthenticated])
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

    # Compile the report content
    report_content = f"""
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Daily Report for {report_date}</title>
            <style>
                body {{
                    font-family: Arial, sans-serif;
                    line-height: 1.6;
                    margin: 20px;
                    padding: 20px;
                    background-color: #f9f9f9;
                    color: #333;
                }}
                h1 {{
                    color: #2c3e50;
                }}
                .report {{
                    border: 1px solid #ddd;
                    padding: 15px;
                    background: #fff;
                    border-radius: 5px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }}
                .report h2 {{
                    margin-top: 0;
                }}
                .highlight {{
                    color: #e74c3c;
                    font-weight: bold;
                }}
            </style>
        </head>
        <body>
            <div class="report">
                <h1>Daily Report for {report_date}</h1>
                <hr>
                <h2>Summary:</h2>
                <p><strong>Number of vending machines:</strong> <span class="highlight">{vending_machine_count}</span></p>
                <p><strong>Total orders placed:</strong> <span class="highlight">{total_orders}</span></p>
                <p><strong>Total sales amount:</strong> <span class="highlight">${total_sales:.2f}</span></p>
                <p><strong>Total items sold:</strong> <span class="highlight">{total_items_sold}</span></p>
            </div>
        </body>
        </html>
    """

    response = Response(
        {
            "date": report_date_str,
            "content": report_content,
        },
        status=status.HTTP_200_OK,
    )

    return response