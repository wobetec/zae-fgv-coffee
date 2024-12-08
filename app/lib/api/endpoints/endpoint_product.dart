import 'package:http/http.dart';
import 'dart:convert';
import 'endpoint.dart';


class EndPointProduct extends EndPoint {
  Future<Response> getProduct(String token, String productId) async {
    final url = Uri.parse('${EndPoint.baseUrl}product/?prod_id=$productId');

    final response = await get(
      url,
      headers: headers(token),
    );
    return response;
  }

  Future<Response> getProducts(String token, {String? vmId}) async {
    final url = Uri.parse('${EndPoint.baseUrl}product/all${vmId != null ? '?vm_id=$vmId' : ''}');

    final response = await get(
      url,
      headers: headers(token),
    );
    return response;
  }

  Future<Response> getFavoriteProducts(String token) async {
    final url = Uri.parse('${EndPoint.baseUrl}product/favorite');

    final response = await get(
      url,
      headers: headers(token),
    );
    return response;
  }

  Future<Response> addFavoriteProduct(String token, String productId, String vmId) async {
    final url = Uri.parse('${EndPoint.baseUrl}product/favorite');

    final response = await post(
      url,
      headers: headers(token),
      body: jsonEncode({
        'prod_id': productId,
        'vm_id': vmId,
      }),
    );
    return response;
  }

  Future<Response> removeFavoriteProduct(String token, String productId, String vmId) async {
    final url = Uri.parse('${EndPoint.baseUrl}product/favorite');

    final response = await delete(
      url,
      headers: headers(token),
      body: jsonEncode({
        'prod_id': productId,
        'vm_id': vmId,
      }),
    );
    return response;
  }

  Future<Response> getRatings(String token, String productId) async {
    final url = Uri.parse('${EndPoint.baseUrl}product/rating?prod_id=$productId');

    final response = await get(
      url,
      headers: headers(token),
    );
    return response;
  }
}