// import 'dart:io';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:http/http.dart' as http;

// class ApiConfig {
//   static bool isEmulator = false;
//   static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

//   static String getBaseUrl() {
//     if (kIsWeb) {
//       return 'http://localhost:5001';
//     } else if (Platform.isAndroid) {
//       return 'http://127.0.0.1:5001';
//     } else {
//       return 'http://localhost:5001';
//     }
//   }

//   static Future<void> initializeEmulatorCheck() async {
//     if (Platform.isAndroid) {
//       try {
//         final AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
//         isEmulator = !androidInfo.isPhysicalDevice ||
//             androidInfo.product.contains('sdk') ||
//             androidInfo.hardware.contains('goldfish') ||
//             androidInfo.hardware.contains('ranchu');
//         print(
//             'Running on ${isEmulator ? 'Android emulator' : 'physical Android device'}');
//       } catch (e) {
//         print('Error detecting Android emulator status: $e');
//         isEmulator = false;
//       }
//     } else if (Platform.isIOS) {
//       try {
//         final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
//         isEmulator = !iosInfo.isPhysicalDevice;
//         print(
//             'Running on ${isEmulator ? 'iOS simulator' : 'physical iOS device'}');
//       } catch (e) {
//         print('Error detecting iOS simulator status: $e');
//         isEmulator = false;
//       }
//     }
//   }

//   static Future<bool> testConnection() async {
//     try {
//       print('Testing connection to: ${getBaseUrl()}/test');
//       final response = await http
//           .get(
//             Uri.parse('${getBaseUrl()}/test'),
//           )
//           .timeout(const Duration(seconds: 5));
//       print(
//           'Connection test response: ${response.statusCode} - ${response.body}');
//       return response.statusCode == 200;
//     } catch (e) {
//       print('Connection test failed with error: $e');
//       return false;
//     }
//   }
// }

import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ApiConfig {
  static bool isEmulator = false;
  static bool isUsbDebugging = false;
  static String? _cachedWorkingUrl;
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static const int SERVER_PORT = 5001;

  static String getBaseUrl() {
    // When using USB debugging with adb reverse, always use localhost
    return 'http://localhost:$SERVER_PORT';
  }

  static Future<void> initializeEmulatorCheck() async {
    if (Platform.isAndroid) {
      try {
        final androidInfo = await _deviceInfo.androidInfo;
        isEmulator = !androidInfo.isPhysicalDevice ||
            androidInfo.product.contains('sdk') ||
            androidInfo.hardware.contains('goldfish') ||
            androidInfo.hardware.contains('ranchu');

        print('\n=== Device Information ===');
        print('Model: ${androidInfo.model}');
        print('Manufacturer: ${androidInfo.manufacturer}');
        print('Android Version: ${androidInfo.version.release}');
        print('Device Type: ${isEmulator ? 'Emulator' : 'Physical Device'}');

        print("Connected Model: ${AndroidOverscrollIndicator}");

        // Verify the connection
        await _verifyServerConnection();
      } catch (e) {
        print('Error during initialization: $e');
      }
    }
  }

  static Future<void> _verifyServerConnection() async {
    print('\n=== Server Connection Test ===');

    final baseUrl = getBaseUrl();
    print('Testing connection to $baseUrl');

    try {
      print('Attempting HTTP connection...');
      final response = await http.get(Uri.parse('$baseUrl/test'),
          headers: {'Connection': 'close'}).timeout(Duration(seconds: 5));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('Connection successful!');
        _cachedWorkingUrl = baseUrl;
      }
    } catch (e) {
      print('Connection failed: $e');
      print('\nTroubleshooting steps:');
      print('1. Make sure your device is connected via USB');
      print('2. Verify USB debugging is enabled on your device');
      print('3. Run "adb devices" to check device connection');
      print('4. Run "adb reverse tcp:5001 tcp:5001" to set up port forwarding');
      print('5. Check if server is running on port 5001');
    }
  }

  static Future<bool> testConnection() async {
    try {
      final response = await http.get(Uri.parse('${getBaseUrl()}/test'),
          headers: {'Connection': 'close'}).timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }
}
