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
  /*
  This class is the main classe that initializes all the other classes that are used to interact with the backend.
  */

  Auth auth = Auth();
  Notification notification = Notification();
  Order order = Order();
  Product product = Product();
  Purchase purchase = Purchase();
  Rating rating = Rating();
  VendingMachine vendingMachine = VendingMachine();
  SimpleReport simpleReport = SimpleReport();

  BackendApi._privateConstructor();

  static final BackendApi _instance = BackendApi._privateConstructor();

  factory BackendApi() {
    return _instance;
  }
  
  initialize() {
    auth.initialize(EndPointAuth());
    auth.loadState();

    notification.initialize(EndPointNotification());
    order.initialize(EndPointOrder());
    product.initialize(EndPointProduct());
    purchase.initialize(EndPointPurchase());
    rating.initialize(EndPointRating());
    vendingMachine.initialize(EndPointVendingMachine());
    simpleReport.initialize(EndPointSimpleReport());
  }
}