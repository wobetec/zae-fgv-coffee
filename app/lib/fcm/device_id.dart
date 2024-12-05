import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceId {
  static Future<String?> getId() async {
    if (Platform.isAndroid) {
      const androidIdPlugin = AndroidId();
      final String? androidId = await androidIdPlugin.getId();
      return androidId;
    } else if (Platform.isIOS) {
      final deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // Unique ID on iOS
    } else if (Platform.isLinux) {
      final deviceInfo = DeviceInfoPlugin();
      final linuxInfo = await deviceInfo.linuxInfo;
      return linuxInfo.machineId; // Machine ID on Linux
    } else if (Platform.isMacOS) {
      final deviceInfo = DeviceInfoPlugin();
      final macInfo = await deviceInfo.macOsInfo;
      return macInfo.systemGUID; // System GUID on macOS
    } else if (Platform.isWindows) {
      final deviceInfo = DeviceInfoPlugin();
      final windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.deviceId; // Unique ID on Windows
    } else if (kIsWeb) {
      // For web, we can use a combination of browser information or generate a UUID
      final deviceInfo = DeviceInfoPlugin();
      final webInfo = await deviceInfo.webBrowserInfo;
      return "${webInfo.vendor}-${webInfo.userAgent}-${webInfo.hardwareConcurrency}";
    } else {
      throw Exception('Platform not implemented');
    }
  }
}
