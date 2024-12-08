import "package:namer_app/api/auth.dart";
import "package:namer_app/api/endpoints/endpoint_auth.dart";

import "package:namer_app/api/order.dart";
import "package:namer_app/api/endpoints/endpoint_order.dart";

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart';
import 'order_test.mocks.dart';


@GenerateMocks([EndPointOrder])
void main(){
  Auth auth = Auth();
  Order order = Order();

  group("Test getOrders", (){
    test("Get orders with correct token", () async {
      EndPointOrder endPointOrder = MockEndPointOrder();
      when(endPointOrder.getOrders("123")).thenAnswer((_) async => Response('[]', 200));
      auth.initialize(EndPointAuth(), force: true);
      auth.setToken("123");
      order.initialize(endPointOrder, force: true);

      dynamic orderResult = await order.getOrders();

      expect(orderResult, []);
    });

    test("Get orders with no token", () async {
      EndPointOrder endPointOrder = MockEndPointOrder();

      auth.initialize(EndPointAuth(), force: true, resetToken: true);
      order.initialize(endPointOrder, force: true);

      expect(() async => await order.getOrders(), throwsException);
    });
  });

  group("Test getOrder", (){
    test("Get order with correct token and orderId", () async {
      EndPointOrder endPointOrder = MockEndPointOrder();
      when(endPointOrder.getOrder("123", "123")).thenAnswer((_) async => Response('{"order_id": "123"}', 200));
      auth.initialize(EndPointAuth(), force: true);
      auth.setToken("123");
      order.initialize(endPointOrder, force: true);

      dynamic orderResult = await order.getOrder("123");

      expect(orderResult, {"order_id": "123"});
    });

    test("Get order with no token", () async {
      EndPointOrder endPointOrder = MockEndPointOrder();

      auth.initialize(EndPointAuth(), force: true, resetToken: true);
      order.initialize(endPointOrder, force: true);

      expect(() async => await order.getOrder("123"), throwsException);
    });
  });
}