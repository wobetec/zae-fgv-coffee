import "package:namer_app/api/auth.dart";
import "package:namer_app/api/endpoints/endpoint_auth.dart";

import "package:namer_app/api/purchase.dart";
import "package:namer_app/api/endpoints/endpoint_purchase.dart";

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart';
import 'purchase_test.mocks.dart';


@GenerateMocks([EndPointPurchase])
void main(){
  group("Test purchase", (){
    test("Purchase with correct token, vmId and products", () async {
      EndPointPurchase endPointPurchase = MockEndPointPurchase();
      when(endPointPurchase.purchase("123", "123", [{"product": 123}])).thenAnswer((_) async => Response('{}', 200));
      Auth.initialize(EndPointAuth(), force: true);
      Auth.setToken("123");
      Purchase.initialize(endPointPurchase, force: true);

      await Purchase.purchase("123", [{"product": 123}]);
    });

    test("Purchase with no token", () async {
      EndPointPurchase endPointPurchase = MockEndPointPurchase();

      Auth.initialize(EndPointAuth(), force: true, resetToken: true);
      Purchase.initialize(endPointPurchase, force: true);

      expect(() async => await Purchase.purchase("123", [{"product": 123}]), throwsException);
    });
  });
}
