import "package:namer_app/api/auth.dart";
import "package:namer_app/api/endpoints/endpoint_auth.dart";

import "package:namer_app/api/rating.dart";
import "package:namer_app/api/endpoints/endpoint_rating.dart";

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart';
import 'rating_test.mocks.dart';


@GenerateMocks([EndPointRating])
void main(){
  Auth auth = Auth();
  Rating rating = Rating();

  group("Test rateProduct", (){
    test("Rate product with correct token, productId, rating, and description", () async {
      EndPointRating endPointRating = MockEndPointRating();
      when(endPointRating.rateProduct("123", "123", 5, "good")).thenAnswer((_) async => Response('{"prod_id": "123"}', 200));
      auth.initialize(EndPointAuth(), force: true);
      auth.setToken("123");
      rating.initialize(endPointRating, force: true);

      dynamic ratingResult = await rating.rateProduct("123", 5, "good");
      expect(ratingResult, {"prod_id": "123"});
    });

    test("Rate product with no token", () async {
      EndPointRating endPointRating = MockEndPointRating();

      auth.initialize(EndPointAuth(), force: true, resetToken: true);
      rating.initialize(endPointRating, force: true);

      expect(() async => await rating.rateProduct("123", 5, "good"), throwsException);
    });
  });

  group("Test getRating", (){
    test("Get rating with correct token and productId", () async {
      EndPointRating endPointRating = MockEndPointRating();
      when(endPointRating.getRating("123")).thenAnswer((_) async => Response('[]', 200));
      auth.initialize(EndPointAuth(), force: true);
      auth.setToken("123");
      rating.initialize(endPointRating, force: true);

      dynamic ratings = await rating.getRating();
      expect(ratings, []);
    });

    test("Get rating with no token", () async {
      EndPointRating endPointRating = MockEndPointRating();

      auth.initialize(EndPointAuth(), force: true, resetToken: true);
      rating.initialize(endPointRating, force: true);

      expect(() async => await rating.getRating(), throwsException);
    });
  });

  group("Test unrateProduct", (){
    test("Unrate product with correct token and productId", () async {
      EndPointRating endPointRating = MockEndPointRating();
      when(endPointRating.unrateProduct("123", "123")).thenAnswer((_) async => Response('', 204));
      auth.initialize(EndPointAuth(), force: true);
      auth.setToken("123");
      rating.initialize(endPointRating, force: true);

      await rating.unrateProduct("123");
    });

    test("Unrate product with no token", () async {
      EndPointRating endPointRating = MockEndPointRating();
      when(endPointRating.unrateProduct("123", "123")).thenAnswer((_) async => Response('', 204));
      auth.initialize(EndPointAuth(), force: true, resetToken: true);
      rating.initialize(endPointRating, force: true);

      expect(() async => await rating.unrateProduct("123"), throwsException);
    });
  });
}

