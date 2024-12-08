import 'package:namer_app/api/auth.dart';
import 'package:namer_app/api/endpoints/endpoint_auth.dart';

import 'package:namer_app/api/notification.dart';
import 'package:namer_app/api/endpoints/endpoint_notification.dart';

import 'package:namer_app/api/order.dart';
import 'package:namer_app/api/endpoints/endpoint_order.dart';

import 'package:namer_app/api/product.dart';
import 'package:namer_app/api/endpoints/endpoint_product.dart';

import 'package:namer_app/api/purchase.dart';
import 'package:namer_app/api/endpoints/endpoint_purchase.dart';

import 'package:namer_app/api/rating.dart';
import 'package:namer_app/api/endpoints/endpoint_rating.dart';

import 'package:namer_app/api/vending_machine.dart';
import 'package:namer_app/api/endpoints/endpoint_vending_machine.dart';

import 'package:namer_app/api/simple_report.dart';
import 'package:namer_app/api/endpoints/endpoint_simple_report.dart';

class BackendApi {
  static var _initialized = false;

  static initialize(
      {EndPointAuth? endPointAuth,
      EndPointNotification? endPointNotification,
      EndPointOrder? endPointOrder,
      EndPointProduct? endPointProduct,
      EndPointPurchase? endPointPurchase,
      EndPointRating? endPointRating,
      EndPointVendingMachine? endPointVendingMachine,
      EndPointSimpleReport? endPointSimpleReport}) {
    if (!_initialized) {
      Auth.initialize(endPointAuth ?? EndPointAuth());
      Notification.initialize(endPointNotification ?? EndPointNotification());
      Order.initialize(endPointOrder ?? EndPointOrder());
      Product.initialize(endPointProduct ?? EndPointProduct());
      Purchase.initialize(endPointPurchase ?? EndPointPurchase());
      Rating.initialize(endPointRating ?? EndPointRating());
      VendingMachine.initialize(endPointVendingMachine ?? EndPointVendingMachine());
      SimpleReport.initialize(endPointSimpleReport ?? EndPointSimpleReport());

      _initialized = true;
    }
  }
}
