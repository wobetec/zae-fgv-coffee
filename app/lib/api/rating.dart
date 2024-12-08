import 'auth.dart';
import 'dart:convert';

import 'endpoints/endpoint_rating.dart';


class Rating {
  EndPointRating? _ratingEndPoint;
  Auth _auth = Auth();

  Rating._privateConstructor();

  static final Rating _instance = Rating._privateConstructor();

  factory Rating() {
    return _instance;
  }

  initialize(EndPointRating? ratingEndPoint, {bool force = false}) {
    if (_ratingEndPoint == null || force) {
      _ratingEndPoint = ratingEndPoint;
    } else {
      _ratingEndPoint = EndPointRating();
    }
  }

  Future<dynamic> rateProduct(String productId, int rating, String description) async {
    if (!_auth.hasToken()) {
      throw Exception('No token');
    }
    return await _ratingEndPoint!.rateProduct(_auth.getToken()!, productId, rating, description)
      .then((response) {
        if (response.statusCode != 200) {
          throw Exception('Failed to rate product');
        }
        return jsonDecode(response.body);
      })
      .catchError((error) {
        throw Exception('Failed to rate product');
      });
  }

  Future<dynamic> getRating() async {
    if (!_auth.hasToken()) {
      throw Exception('No token');
    }
    return await _ratingEndPoint!.getRating(_auth.getToken()!)
      .then((response) {
        if (response.statusCode != 200) {
          throw Exception('Failed to get rating');
        }
        return jsonDecode(response.body);
      })
      .catchError((error) {
        throw Exception('Failed to get rating');
      });
  }

  Future<void> unrateProduct(String productId) async {
    if (!_auth.hasToken()) {
      throw Exception('No token');
    }
    await _ratingEndPoint!.unrateProduct(_auth.getToken()!, productId)
      .then((response) {
        if (response.statusCode != 204) {
          throw Exception('Failed to unrate product');
        }
      })
      .catchError((error) {
        throw Exception('Failed to unrate product');
      });
  }
}
