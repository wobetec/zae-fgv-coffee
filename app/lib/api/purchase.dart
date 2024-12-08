import 'auth.dart';
import 'dart:convert';

import 'endpoints/endpoint_purchase.dart';


class Purchase {
  EndPointPurchase? _endPointPurchase;
  Auth _auth = Auth();

  Purchase._privateConstructor();

  static final Purchase _instance = Purchase._privateConstructor();

  factory Purchase() {
    return _instance;
  }

  initialize(EndPointPurchase? endPointPurchase, {bool force = false}) {
    if (_endPointPurchase == null || force) {
      _endPointPurchase = endPointPurchase;
    } else {
      _endPointPurchase = EndPointPurchase();
    }
  }

  Future<dynamic> purchase(String vmId, List<dynamic> products) async {
    if (!_auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointPurchase!.purchase(_auth.getToken()!, vmId, products)
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


