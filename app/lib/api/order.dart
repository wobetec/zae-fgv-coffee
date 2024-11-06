import 'auth.dart';
import 'dart:convert';

import 'endpoints/endpoint_order.dart';


class Order {
  static EndPointOrder? _endPointOrder;

  static initialize(EndPointOrder? endPointOrder, {bool force = false}) {
    if (_endPointOrder == null || force) {
      _endPointOrder = endPointOrder;
    } else {
      _endPointOrder = EndPointOrder();
    }
  }

  static Future<dynamic> getOrders() async {
    if (!Auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointOrder!.getOrders(Auth.getToken()!)
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

  static Future<dynamic> getOrder(String orderId) async {
    if (!Auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointOrder!.getOrder(Auth.getToken()!, orderId)
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