import 'auth.dart';
import 'dart:convert';

import 'endpoints/endpoint_order.dart';


class Order {
  EndPointOrder? _endPointOrder;
  Auth _auth = Auth();

  Order._privateConstructor();

  static final Order _instance = Order._privateConstructor();

  factory Order() {
    return _instance;
  }

  initialize(EndPointOrder? endPointOrder, {bool force = false}) {
    if (_endPointOrder == null || force) {
      _endPointOrder = endPointOrder;
    } else {
      _endPointOrder = EndPointOrder();
    }
  }

  Future<dynamic> getOrders() async {
    if (!_auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointOrder!.getOrders(_auth.getToken()!)
      .then((response) {
        if (response.statusCode != 200) {
          throw Exception('Failed to get orders');
        }
        return jsonDecode(response.body);
      })
      .catchError((error) {
        throw Exception('Failed to get orders');
      });
    
  }

  Future<dynamic> getOrder(String orderId) async {
    if (!_auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointOrder!.getOrder(_auth.getToken()!, orderId)
      .then((response) {
        if (response.statusCode != 200) {
          throw Exception('Failed to get order');
        }
        return jsonDecode(response.body);
      })
      .catchError((error) {
        throw Exception('Failed to get order');
      });
  }
}