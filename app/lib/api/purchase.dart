import 'auth.dart';
import 'dart:convert';

import 'endpoints/endpoint_purchase.dart';


class Purchase {
  static EndPointPurchase? _endPointPurchase;

  static initialize(EndPointPurchase? endPointPurchase, {bool force = false}) {
    if (_endPointPurchase == null || force) {
      _endPointPurchase = endPointPurchase;
    } else {
      _endPointPurchase = EndPointPurchase();
    }
  }

  static Future<dynamic> purchase(String vmId, List<Map<String, int>> products) async {
    if (!Auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointPurchase!.purchase(Auth.getToken()!, vmId, products)
      .then((response) {
        if (response.statusCode != 200) {
          throw Exception('Failed to purchase');
        }
        return jsonDecode(response.body);
      })
      .catchError((error) {
        throw Exception('Failed to purchase');
      });
  }
}


