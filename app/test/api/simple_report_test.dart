import "package:namer_app/api/auth.dart";
import "package:namer_app/api/endpoints/endpoint_auth.dart";

import "package:namer_app/api/simple_report.dart";
import "package:namer_app/api/endpoints/endpoint_simple_report.dart";

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart';
import 'simple_report_test.mocks.dart';


@GenerateMocks([EndPointSimpleReport])
void main(){
  Auth auth = Auth();
  SimpleReport simpleReport = SimpleReport();

  group("Test getSimpleReport", (){
    test("Get report with correct token", () async {
      EndPointSimpleReport endPointSimpleReport = MockEndPointSimpleReport();
      when(endPointSimpleReport.getSimpleReport("123", "2024-10-12")).thenAnswer((_) async => Response('{"date": "2024-10-12", "content": "html"}', 200));

      auth.initialize(EndPointAuth(), force: true);
      auth.setToken("123");
      auth.setUserType(UserType.support);

      simpleReport.initialize(endPointSimpleReport, force: true);

      dynamic report = await simpleReport.getSimpleReport("2024-10-12");

      expect(report, {"date": "2024-10-12", "content": "html"});
    });
  });
}