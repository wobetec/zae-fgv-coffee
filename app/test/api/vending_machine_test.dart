import "package:namer_app/api/auth.dart";
import "package:namer_app/api/endpoints/endpoint_auth.dart";

import "package:namer_app/api/vending_machine.dart";
import "package:namer_app/api/endpoints/endpoint_vending_machine.dart";

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart';
import 'vending_machine_test.mocks.dart';


@GenerateMocks([EndPointVendingMachine])
void main(){
  Auth auth = Auth();
  VendingMachine vendingMachine = VendingMachine();

  group("Test getVendingMachines", (){
    test("Get vending machines with correct token", () async {
      EndPointVendingMachine endPointVendingMachine = MockEndPointVendingMachine();
      when(endPointVendingMachine.getVendingMachines("123")).thenAnswer((_) async => Response('[]', 200));
      auth.initialize(EndPointAuth(), force: true);
      auth.setToken("123");
      vendingMachine.initialize(endPointVendingMachine, force: true);

      dynamic vendingMachines = await vendingMachine.getVendingMachines();
      expect(vendingMachines, []);
    });

    test("Get vending machines with no token", () async {
      EndPointVendingMachine endPointVendingMachine = MockEndPointVendingMachine();

      auth.initialize(EndPointAuth(), force: true, resetToken: true);
      vendingMachine.initialize(endPointVendingMachine, force: true);

      expect(() async => await vendingMachine.getVendingMachines(), throwsException);
    });
  });
}