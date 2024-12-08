import 'auth.dart';
import 'dart:convert';

import 'endpoints/endpoint_product.dart';

class Product {
  EndPointProduct? _endPointProduct;
  Auth _auth = Auth();

  Product._privateConstructor();

  static final Product _instance = Product._privateConstructor();

  factory Product() {
    return _instance;
  }

  initialize(EndPointProduct? endPointProduct, {bool force = false}) {
    if (_endPointProduct == null || force) {
      _endPointProduct = endPointProduct;
    } else {
      _endPointProduct = EndPointProduct();
    }
  }

  Future<dynamic> getProduct(String productId) async {
    if (!_auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointProduct!.getProduct(_auth.getToken()!, productId)
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

  Future<dynamic> getProducts({String? vmId}) async {
    if (!_auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointProduct!.getProducts(_auth.getToken()!, vmId: vmId)
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

  Future<dynamic> getFavoriteProducts() async {
    if (!_auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointProduct!.getFavoriteProducts(_auth.getToken()!)
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

  Future<dynamic> addFavoriteProduct(String productId, String vmId) async {
    if (!_auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointProduct!.addFavoriteProduct(_auth.getToken()!, productId, vmId)
      .then((response) {
        if (response.statusCode != 201) {
          throw Exception('Failed to add favorite product');
        }
        return jsonDecode(response.body);
      })
      .catchError((error) {
        throw Exception('Failed to add favorite product');
      });
  }

  Future<void> removeFavoriteProduct(String productId, String vmId) async {
    if (!_auth.hasToken()) {
      throw Exception('No token');
    }
    await _endPointProduct!.removeFavoriteProduct(_auth.getToken()!, productId, vmId)
      .then((response) {
        if (response.statusCode != 204) {
          throw Exception('Failed to remove favorite product');
        }
      })
      .catchError((error) {
        throw Exception('Failed to remove favorite product');
      });
  }

  Future<dynamic> getRatings(String productId) async {
    if (!_auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointProduct!.getRatings(_auth.getToken()!, productId)
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