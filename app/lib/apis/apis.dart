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

import 'package:namer_app/fcm/fcm.dart';


class APIs {
  /*
  This class is a facade that initializes and interact with all the other classes that are used to interact with the backend/firebase.
  */

  Auth auth = Auth();
  Notification notification = Notification();
  Order order = Order();
  Product product = Product();
  Purchase purchase = Purchase();
  Rating rating = Rating();
  VendingMachine vendingMachine = VendingMachine();
  SimpleReport simpleReport = SimpleReport();
  FCM fcm = FCM();

  APIs._privateConstructor();

  static final APIs _instance = APIs._privateConstructor();

  factory APIs() {
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

    fcm.initialize();
  }

  Future<void> login(String username, String password, bool isAdmin) async {
    await auth.login(username, password, isAdmin ? UserType.support : UserType.user);
    auth.saveState();
    await notification.registerDevice(
      fcm.registrationId!,
      fcm.deviceType!,
      fcm.deviceId!,
    );
  }

  Future<void> signup(String username, String email, String password) async {
    await auth.signup(username, email, password);
    auth.saveState();
    await notification.registerDevice(
      fcm.registrationId!,
      fcm.deviceType!,
      fcm.deviceId!,
    );
  }

  Future<void> logout() async {
    await auth.logout(fcm.deviceId!);
    auth.deleteState();
  }
}