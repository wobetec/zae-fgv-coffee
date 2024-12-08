import "package:namer_app/api/auth.dart";
import "package:namer_app/api/endpoints/endpoint_auth.dart";

import "package:namer_app/api/product.dart";
import "package:namer_app/api/endpoints/endpoint_product.dart";

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart';
import 'product_test.mocks.dart';


@GenerateMocks([EndPointProduct])
void main(){
  Auth auth = Auth();
  Product product = Product();

  group("Test getProduct", (){
    test("Get product with correct token and productId", () async {
      EndPointProduct endPointProduct = MockEndPointProduct();
      when(endPointProduct.getProduct("123", "123")).thenAnswer((_) async => Response('{"prod_id": "123"}', 200));

      auth.initialize(EndPointAuth(), force: true);
      auth.setToken("123");
      product.initialize(endPointProduct, force: true);

      dynamic productResult = await product.getProduct("123");
      expect(productResult, {"prod_id": "123"});
    });

    test("Get product with no token", () async {
      EndPointProduct endPointProduct = MockEndPointProduct();

      auth.initialize(EndPointAuth(), force: true, resetToken: true);
      product.initialize(endPointProduct, force: true);

      expect(() async => await product.getProduct("123"), throwsException);
    });
  });

  group("Test getProducts", (){
    test("Get products with correct token", () async {
      EndPointProduct endPointProduct = MockEndPointProduct();
      when(endPointProduct.getProducts("123")).thenAnswer((_) async => Response('[]', 200));
      auth.initialize(EndPointAuth(), force: true);
      auth.setToken("123");
      product.initialize(endPointProduct, force: true);

      dynamic products = await product.getProducts();
      expect(products, []);
    });

    test("Get products with no token", () async {
      EndPointProduct endPointProduct = MockEndPointProduct();

      auth.initialize(EndPointAuth(), force: true, resetToken: true);
      product.initialize(endPointProduct, force: true);

      expect(() async => await product.getProducts(), throwsException);
    });
  });

  group("Test getFavoriteProducts", (){
    test("Get favorite products with correct token", () async {
      EndPointProduct endPointProduct = MockEndPointProduct();
      when(endPointProduct.getFavoriteProducts("123")).thenAnswer((_) async => Response('[]', 200));
      auth.initialize(EndPointAuth(), force: true);
      auth.setToken("123");
      product.initialize(endPointProduct, force: true);

      dynamic wishlist = await product.getFavoriteProducts();
      expect(wishlist, []);
    });

    test("Get favorite products with no token", () async {
      EndPointProduct endPointProduct = MockEndPointProduct();

      auth.initialize(EndPointAuth(), force: true, resetToken: true);
      product.initialize(endPointProduct, force: true);

      expect(() async => await product.getFavoriteProducts(), throwsException);
    });
  });

  group("Test addFavoriteProduct", (){
    test("Add favorite product with correct token, productId and vmId", () async {
      EndPointProduct endPointProduct = MockEndPointProduct();
      when(endPointProduct.addFavoriteProduct("123", "123", "123")).thenAnswer((_) async => Response('{}', 201));
      auth.initialize(EndPointAuth(), force: true);
      auth.setToken("123");
      product.initialize(endPointProduct, force: true);

      dynamic wishlist = await product.addFavoriteProduct("123", "123");
      expect(wishlist, {});
    });

    test("Add favorite product with no token", () async {
      EndPointProduct endPointProduct = MockEndPointProduct();

      auth.initialize(EndPointAuth(), force: true, resetToken: true);
      product.initialize(endPointProduct, force: true);

      expect(() async => await product.addFavoriteProduct("123", "123"), throwsException);
    });
  });

  group("Test removeFavoriteProduct", (){
    test("Remove favorite product with correct token, productId and vmId", () async {
      EndPointProduct endPointProduct = MockEndPointProduct();
      when(endPointProduct.removeFavoriteProduct("123", "123", "123")).thenAnswer((_) async => Response('{"message": "Product removed from favorite"}', 204));
      auth.initialize(EndPointAuth(), force: true);
      auth.setToken("123");
      product.initialize(endPointProduct, force: true);

      await product.removeFavoriteProduct("123", "123");
    });

    test("Remove favorite product with no token", () async {
      EndPointProduct endPointProduct = MockEndPointProduct();

      auth.initialize(EndPointAuth(), force: true, resetToken: true);
      product.initialize(endPointProduct, force: true);

      expect(() async => await product.removeFavoriteProduct("123", "123"), throwsException);
    });
  });

  group("Test getRatings", (){
    test("Get ratings with correct token and productId", () async {
      EndPointProduct endPointProduct = MockEndPointProduct();
      when(endPointProduct.getRatings("123", "123")).thenAnswer((_) async => Response('[]', 200));
      auth.initialize(EndPointAuth(), force: true);
      auth.setToken("123");
      product.initialize(endPointProduct, force: true);

      dynamic ratings = await product.getRatings("123");
      expect(ratings, []);
    });

    test("Get ratings with no token", () async {
      EndPointProduct endPointProduct = MockEndPointProduct();

      auth.initialize(EndPointAuth(), force: true, resetToken: true);
      product.initialize(endPointProduct, force: true);

      expect(() async => await product.getRatings("123"), throwsException);
    });
  });
}
