import 'auth.dart';
import 'dart:convert';

import 'endpoints/endpoint_rating.dart';


class Rating {
  static EndPointRating? _ratingEndPoint;

  static initialize(EndPointRating? ratingEndPoint, {bool force = false}) {
    if (_ratingEndPoint == null || force) {
      _ratingEndPoint = ratingEndPoint;
    } else {
      _ratingEndPoint = EndPointRating();
    }
  }

  static Future<dynamic> rateProduct(String productId, int rating, String description) async {
    if (!Auth.hasToken()) {
      throw Exception('No token');
    }
    return await _ratingEndPoint!.rateProduct(Auth.getToken()!, productId, rating, description)
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

  static Future<dynamic> getRating() async {
    if (!Auth.hasToken()) {
      throw Exception('No token');
    }
    return await _ratingEndPoint!.getRating(Auth.getToken()!)
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

  static Future<void> unrateProduct(String productId) async {
    if (!Auth.hasToken()) {
      throw Exception('No token');
    }
    await _ratingEndPoint!.unrateProduct(Auth.getToken()!, productId)
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
