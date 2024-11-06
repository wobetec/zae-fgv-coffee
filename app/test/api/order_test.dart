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
  group("Test getOrders", (){
    test("Get orders with correct token", () async {
      EndPointOrder endPointOrder = MockEndPointOrder();
      when(endPointOrder.getOrders("123")).thenAnswer((_) async => Response('[]', 200));
      Auth.initialize(EndPointAuth(), force: true);
      Auth.setToken("123");
      Order.initialize(endPointOrder, force: true);

      dynamic order = await Order.getOrders();

      expect(order, []);
    });

    test("Get orders with no token", () async {
      EndPointOrder endPointOrder = MockEndPointOrder();

      Auth.initialize(EndPointAuth(), force: true, resetToken: true);
      Order.initialize(endPointOrder, force: true);

      expect(() async => await Order.getOrders(), throwsException);
    });
  });

  group("Test getOrder", (){
    test("Get order with correct token and orderId", () async {
      EndPointOrder endPointOrder = MockEndPointOrder();
      when(endPointOrder.getOrder("123", "123")).thenAnswer((_) async => Response('{"order_id": "123"}', 200));
      Auth.initialize(EndPointAuth(), force: true);
      Auth.setToken("123");
      Order.initialize(endPointOrder, force: true);

      dynamic order = await Order.getOrder("123");

      expect(order, {"order_id": "123"});
    });

    test("Get order with no token", () async {
      EndPointOrder endPointOrder = MockEndPointOrder();

      Auth.initialize(EndPointAuth(), force: true, resetToken: true);
      Order.initialize(endPointOrder, force: true);

      expect(() async => await Order.getOrder("123"), throwsException);
    });
  });
}