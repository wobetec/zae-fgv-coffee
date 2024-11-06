import 'auth.dart';
import 'dart:convert';

import 'endpoints/endpoint_product.dart';

class Product {
  static EndPointProduct? _endPointProduct;

  static initialize(EndPointProduct? endPointProduct, {bool force = false}) {
    if (_endPointProduct == null || force) {
      _endPointProduct = endPointProduct;
    } else {
      _endPointProduct = EndPointProduct();
    }
  }

  static Future<dynamic> getProduct(String productId) async {
    if (!Auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointProduct!.getProduct(Auth.getToken()!, productId)
      .then((response) {
        if (response.statusCode != 200) {
          throw Exception('Failed to get product');
        }
        return jsonDecode(response.body);
      })
      .catchError((error) {
        throw Exception('Failed to get product');
      });
  }

  static Future<dynamic> getProducts({String? vmId}) async {
    if (!Auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointProduct!.getProducts(Auth.getToken()!, vmId: vmId)
      .then((response) {
        if (response.statusCode != 200) {
          throw Exception('Failed to get products');
        }
        return jsonDecode(response.body);
      })
      .catchError((error) {
        throw Exception('Failed to get products');
      });
  }

  static Future<dynamic> getFavoriteProducts() async {
    if (!Auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointProduct!.getFavoriteProducts(Auth.getToken()!)
      .then((response) {
        if (response.statusCode != 200) {
          throw Exception('Failed to get favorite products');
        }
        return jsonDecode(response.body);
      })
      .catchError((error) {
        throw Exception('Failed to get favorite products');
      });
  }

  static Future<dynamic> addFavoriteProduct(String productId, String vmId) async {
    if (!Auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointProduct!.addFavoriteProduct(Auth.getToken()!, productId, vmId)
      .then((response) {
        if (response.statusCode != 200) {
          throw Exception('Failed to add favorite product');
        }
        return jsonDecode(response.body);
      })
      .catchError((error) {
        throw Exception('Failed to add favorite product');
      });
  }

  static Future<void> removeFavoriteProduct(String productId, String vmId) async {
    if (!Auth.hasToken()) {
      throw Exception('No token');
    }
    await _endPointProduct!.removeFavoriteProduct(Auth.getToken()!, productId, vmId)
      .then((response) {
        if (response.statusCode != 204) {
          throw Exception('Failed to remove favorite product');
        }
      })
      .catchError((error) {
        throw Exception('Failed to remove favorite product');
      });
  }

  static Future<dynamic> getRatings(String productId) async {
    if (!Auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointProduct!.getRatings(Auth.getToken()!, productId)
      .then((response) {
        if (response.statusCode != 200) {
          throw Exception('Failed to get ratings');
        }
        return jsonDecode(response.body);
      })
      .catchError((error) {
        throw Exception('Failed to get ratings');
      });
  }
}