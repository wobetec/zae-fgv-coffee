import 'package:http/http.dart';
import 'dart:convert';
import 'endpoint.dart';


class EndPointRating extends EndPoint {
  Future<Response> rateProduct(String token, String productId, int rating, String description) async {
    final url = Uri.parse('${EndPoint.baseUrl}rating');

    final response = await post(
      url,
      headers: headers(token),
      body: jsonEncode({
        'prod_id': productId,
        'rating_star': rating,
        'rating_description': description,
      }),
    );
    return response;
  }

  Future<Response> getRating(String token) async {
    final url = Uri.parse('${EndPoint.baseUrl}rating');

    final response = await get(
      url,
      headers: headers(token),
    );
    return response;
  }

  Future<Response> unrateProduct(String token, String productId) async {
    final url = Uri.parse('${EndPoint.baseUrl}rating');

    final response = await delete(
      url,
      headers: headers(token),
      body: jsonEncode({
        'prod_id': productId,
      }),
    );
    return response;
  }
}