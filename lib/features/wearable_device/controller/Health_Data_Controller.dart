// import 'package:flutter/material.dart';
// import 'package:health/health.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../models/health_metrics.dart';
// import '../../../data/api_config.dart';
// import 'package:mindaigle/data/services/auth_service.dart';

// class HealthDataController extends ChangeNotifier {
//   late final Health health;
//   final AuthService _authService = AuthService();
//   final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

//   HealthMetrics? _healthMetrics;
//   bool _isLoading = true;
//   String _deviceStatus = 'Disconnected';
//   int _batteryLevel = 0;
//   Set<HealthDataType> _availableTypes = {};
//   String? _errorMessage;

//   HealthDataController() {
//     health = Health();
//   }

//   HealthMetrics? get healthMetrics => _healthMetrics;
//   bool get isLoading => _isLoading;
//   String get deviceStatus => _deviceStatus;
//   int get batteryLevel => _batteryLevel;
//   String? get errorMessage => _errorMessage;
//   bool get hasTemperature =>
//       _availableTypes.contains(HealthDataType.BODY_TEMPERATURE);
//   bool get hasHeartRate => _availableTypes.contains(HealthDataType.HEART_RATE);
//   bool get hasSleep => _availableTypes.contains(HealthDataType.SLEEP_ASLEEP);

//   Future<void> initializeHealth() async {
//     try {
//       _isLoading = true;
//       _errorMessage = null;
//       notifyListeners();

//       // Request Android Permissions First
//       final permissions = [
//         Permission.activityRecognition,
//         Permission.sensors,
//       ];

//       // Request Android permissions

//       Map<Permission, PermissionStatus> statuses = await permissions.request();
//       bool androidPermissionsGranted =
//           statuses.values.every((status) => status.isGranted);

//       if (!androidPermissionsGranted) {
//         _errorMessage = 'Please grant required permissions in device settings';
//         _deviceStatus = 'Permission denied';
//         _isLoading = false;
//         notifyListeners();
//         return;
//       }

//       // Request Health Permissions

//       final types = [
//         HealthDataType.STEPS,
//         HealthDataType.HEART_RATE,
//         HealthDataType.SLEEP_ASLEEP,
//         HealthDataType.BODY_TEMPERATURE,
//       ];

//       bool? healthPermissionsGranted = await health.requestAuthorization(types);

//       if (healthPermissionsGranted != true) {
//         _errorMessage = 'Please grant health permissions in device settings';
//         _deviceStatus = 'Health permissions denied';
//         _isLoading = false;
//         notifyListeners();
//         return;
//       }

//       // Initialize available types
//       _availableTypes = Set.from(types);
//       await verifyAvailableTypes();

//       if (_availableTypes.isNotEmpty) {
//         await fetchHealthData();
//         _deviceStatus = 'Connected';
//         _batteryLevel = 75;
//         _errorMessage = null;
//       } else {
//         _deviceStatus = 'No data available';
//         _errorMessage = 'No health data sources found';
//       }
//     } catch (e) {
//       print("Error initializing health data: $e");
//       _deviceStatus = 'Error connecting';
//       _errorMessage = 'Failed to initialize health tracking';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> verifyAvailableTypes() async {
//     final now = DateTime.now();
//     final yesterday = now.subtract(const Duration(days: 1));

//     Set<HealthDataType> verifiedTypes = {};

//     for (var type in _availableTypes) {
//       try {
//         final data = await health.getHealthDataFromTypes(
//           startTime: yesterday,
//           endTime: now,
//           types: [type],
//         );
//         if (data.isNotEmpty) {
//           verifiedTypes.add(type);
//           print("Health data type $type is supported and has data");
//         }
//       } catch (e) {
//         print("Health data type $type is not supported or has no data: $e");
//       }
//     }

//     _availableTypes = verifiedTypes;
//   }

//   Future<void> fetchHealthData() async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final now = DateTime.now();
//       final midnight = DateTime(now.year, now.month, now.day);

//       double steps = 0;
//       double? heartRate;
//       double? temperature;
//       double? sleepHours;

//       try {
//         final stepsData = await health.getHealthDataFromTypes(
//           startTime: midnight,
//           endTime: now,
//           types: [HealthDataType.STEPS],
//         );

//         if (stepsData.isNotEmpty) {
//           steps = stepsData.fold(
//               0.0, (sum, dp) => sum + double.parse(dp.value.toString()));
//         }
//       } catch (e) {
//         print("Error fetching steps: $e");
//       }

//       if (_availableTypes.contains(HealthDataType.HEART_RATE)) {
//         try {
//           final heartRateData = await health.getHealthDataFromTypes(
//             startTime: midnight,
//             endTime: now,
//             types: [HealthDataType.HEART_RATE],
//           );
//           if (heartRateData.isNotEmpty) {
//             heartRate = double.parse(heartRateData.last.value.toString());
//           }
//         } catch (e) {
//           print("Error fetching heart rate: $e");
//           _availableTypes.remove(HealthDataType.HEART_RATE);
//         }
//       }

//       if (_availableTypes.contains(HealthDataType.BODY_TEMPERATURE)) {
//         try {
//           final tempData = await health.getHealthDataFromTypes(
//             startTime: midnight,
//             endTime: now,
//             types: [HealthDataType.BODY_TEMPERATURE],
//           );
//           if (tempData.isNotEmpty) {
//             temperature = double.parse(tempData.last.value.toString());
//           }
//         } catch (e) {
//           print("Error fetching temperature: $e");
//           _availableTypes.remove(HealthDataType.BODY_TEMPERATURE);
//         }
//       }

//       if (_availableTypes.contains(HealthDataType.SLEEP_ASLEEP)) {
//         try {
//           final sleepData = await health.getHealthDataFromTypes(
//             startTime: midnight,
//             endTime: now,
//             types: [HealthDataType.SLEEP_ASLEEP],
//           );
//           if (sleepData.isNotEmpty) {
//             sleepHours = sleepData.fold(0.0,
//                     (sum, item) => sum + double.parse(item.value.toString())) /
//                 3600;
//           }
//         } catch (e) {
//           print("Error fetching sleep data: $e");
//           _availableTypes.remove(HealthDataType.SLEEP_ASLEEP);
//         }
//       }

//       _healthMetrics = HealthMetrics(
//         steps: steps,
//         heartRate: heartRate,
//         temperature: temperature,
//         sleepHours: sleepHours,
//       );

//       await syncWithBackend();
//     } catch (e) {
//       print("Error fetching health data: $e");
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> syncWithBackend() async {
//     if (_healthMetrics == null) return;

//     try {
//       final token = await _authService.getToken();
//       final uid = await _authService.getUid();

//       if (token == null || uid == null) {
//         throw Exception('Not authenticated');
//       }

//       final response = await http.post(
//         Uri.parse('${ApiConfig.getBaseUrl()}/health/daily-data'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           'uid': uid,
//           'date': DateTime.now().toIso8601String().split('T')[0],
//           'source': 'wearable',
//           ..._healthMetrics!.toJson(),
//         }),
//       );

//       if (response.statusCode != 200) {
//         final error = jsonDecode(response.body);
//         throw Exception(error['details'] ?? 'Failed to sync data with backend');
//       }
//     } catch (e) {
//       print("Error syncing with backend: $e");
//       rethrow;
//     }
//   }

//   Future<List<Map<String, dynamic>>> getWellnessHistory([int days = 7]) async {
//     try {
//       final token = await _authService.getToken();
//       final uid = await _authService.getUid();

//       if (token == null || uid == null) {
//         throw Exception('Not authenticated');
//       }

//       final response = await http.get(
//         Uri.parse(
//             '${ApiConfig.getBaseUrl()}/health/wellness-history/$uid?days=$days'),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         return List<Map<String, dynamic>>.from(data);
//       } else {
//         final error = jsonDecode(response.body);
//         throw Exception(error['details'] ?? 'Failed to fetch wellness history');
//       }
//     } catch (e) {
//       print("Error fetching wellness history: $e");
//       rethrow;
//     }
//   }

//   Future<Map<String, dynamic>> getDailyData(String date) async {
//     try {
//       final token = await _authService.getToken();
//       final uid = await _authService.getUid();

//       if (token == null || uid == null) {
//         throw Exception('Not authenticated');
//       }

//       final response = await http.get(
//         Uri.parse('${ApiConfig.getBaseUrl()}/health/daily-data/$uid/$date'),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         final error = jsonDecode(response.body);
//         throw Exception(error['details'] ?? 'Failed to fetch daily data');
//       }
//     } catch (e) {
//       print("Error fetching daily data: $e");
//       rethrow;
//     }
//   }

//   Future<void> manualSync() => fetchHealthData();
// }

// //// Mocking for emulator
// ///
// ///
// ///

// // // lib/features/wearable/controllers/health_data_controller.dart

// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:health/health.dart';
// // import 'package:mindaigle/features/wearable_device/services/health_service.dart';
// // import '../models/health_metrics.dart';

// // class HealthDataController extends ChangeNotifier {
// //   final HealthService _healthService;

// //   HealthMetrics? _healthMetrics;
// //   bool _isLoading = true;
// //   String _deviceStatus = 'Disconnected';
// //   int _batteryLevel = 0;
// //   Set<HealthDataType> _availableTypes = {};
// //   String? _errorMessage;

// //   HealthDataController()
// //       : _healthService = kDebugMode ? MockHealthService() : RealHealthService();

// //   HealthMetrics? get healthMetrics => _healthMetrics;
// //   bool get isLoading => _isLoading;
// //   String get deviceStatus => _deviceStatus;
// //   int get batteryLevel => _batteryLevel;
// //   String? get errorMessage => _errorMessage;
// //   bool get hasTemperature =>
// //       _availableTypes.contains(HealthDataType.BODY_TEMPERATURE);
// //   bool get hasHeartRate => _availableTypes.contains(HealthDataType.HEART_RATE);
// //   bool get hasSleep => _availableTypes.contains(HealthDataType.SLEEP_ASLEEP);

// //   Future<void> initializeHealth() async {
// //     try {
// //       _isLoading = true;
// //       _errorMessage = null;
// //       notifyListeners();

// //       final hasPermissions = await _healthService.requestPermissions();
// //       if (!hasPermissions) {
// //         _errorMessage = 'Please grant health permissions in device settings';
// //         _deviceStatus = 'Permission denied';
// //         _isLoading = false;
// //         notifyListeners();
// //         return;
// //       }

// //       _availableTypes = await _healthService.getAvailableTypes();

// //       if (_availableTypes.isNotEmpty) {
// //         final metrics = await _healthService.fetchHealthData();
// //         if (metrics != null) {
// //           _healthMetrics = metrics;
// //           _deviceStatus = kDebugMode ? 'Connected (Emulator)' : 'Connected';
// //           _batteryLevel = 75;
// //           _errorMessage = null;
// //         } else {
// //           _deviceStatus = 'No data available';
// //           _errorMessage = 'Failed to fetch health data';
// //         }
// //       } else {
// //         _deviceStatus = 'No data available';
// //         _errorMessage = 'No health data sources found';
// //       }
// //     } catch (e) {
// //       print("Error initializing health data: $e");
// //       _deviceStatus = 'Error connecting';
// //       _errorMessage = 'Failed to initialize health tracking';
// //     } finally {
// //       _isLoading = false;
// //       notifyListeners();
// //     }
// //   }

// //   Future<void> manualSync() async {
// //     try {
// //       _isLoading = true;
// //       notifyListeners();

// //       final metrics = await _healthService.fetchHealthData();
// //       if (metrics != null) {
// //         _healthMetrics = metrics;
// //         _errorMessage = null;
// //       } else {
// //         _errorMessage = 'Failed to sync health data';
// //       }
// //     } catch (e) {
// //       _errorMessage = 'Error syncing data';
// //     } finally {
// //       _isLoading = false;
// //       notifyListeners();
// //     }
// //   }
// // }

// lib/features/wearable/controllers/health_data_controller.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/health_service.dart';
import '../models/health_metrics.dart';
import '../../../core/config/api_config.dart';
import 'package:mindaigle/data/services/auth_service.dart';

class HealthDataController extends ChangeNotifier {
  final HealthService _healthService;
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  HealthMetrics? _healthMetrics;
  bool _isLoading = true;
  String _deviceStatus = 'Disconnected';
  int _batteryLevel = 0;
  String? _errorMessage;
  bool _isHealthConnectAvailable = false;

  HealthDataController() : _healthService = HealthService();

  HealthMetrics? get healthMetrics => _healthMetrics;
  bool get isLoading => _isLoading;
  String get deviceStatus => _deviceStatus;
  int get batteryLevel => _batteryLevel;
  String? get errorMessage => _errorMessage;
  bool get hasTemperature => _healthService.hasTemperature;
  bool get hasHeartRate => _healthService.hasHeartRate;
  bool get hasSleep => _healthService.hasSleep;
  bool get isHealthConnectAvailable => _isHealthConnectAvailable;

  Future<void> initializeHealth() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      // Check Health Connect availability
      _isHealthConnectAvailable =
          await _healthService.checkHealthConnectAvailability();

      if (!_isHealthConnectAvailable) {
        bool hasAlternativePermissions =
            await _healthService.requestPermissions();
        if (!hasAlternativePermissions) {
          _errorMessage = 'Limited functionality: Health Connect not available';
          _deviceStatus = 'Limited access';
        } else {
          _deviceStatus = 'Basic tracking';
          await fetchHealthData();
        }
        return;
      }

      final hasPermissions = await _healthService.requestPermissions();

      if (!hasPermissions) {
        _errorMessage = 'Please grant health permissions in device settings';
        _deviceStatus = 'Permission denied';
        return;
      }

      if (_healthService.availableTypes.isNotEmpty) {
        await fetchHealthData();
        _deviceStatus = 'Connected';
        _batteryLevel = 75;
        _errorMessage = null;
      } else {
        _deviceStatus = 'No data available';
        _errorMessage = 'No health data sources found';
      }
    } catch (e) {
      print("Error initializing health data: $e");
      _deviceStatus = 'Error connecting';
      _errorMessage = 'Failed to initialize health tracking';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHealthData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final metrics = await _healthService.fetchHealthData();

      if (metrics != null) {
        _healthMetrics = metrics;
        await syncWithBackend();
      } else {
        _errorMessage = 'Failed to fetch health data';
      }
    } catch (e) {
      print("Error fetching health data: $e");
      _errorMessage = 'Error fetching health data';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> syncWithBackend() async {
    if (_healthMetrics == null) return;

    try {
      final token = await _authService.getToken();
      final uid = await _authService.getUid();

      if (token == null || uid == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.getBaseUrl()}/health/daily-data'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'uid': uid,
          'date': DateTime.now().toIso8601String().split('T')[0],
          'source': 'wearable',
          ..._healthMetrics!.toJson(),
        }),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['details'] ?? 'Failed to sync data with backend');
      }
    } catch (e) {
      print("Error syncing with backend: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getWellnessHistory([int days = 7]) async {
    try {
      final token = await _authService.getToken();
      final uid = await _authService.getUid();

      if (token == null || uid == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse(
            '${ApiConfig.getBaseUrl()}/health/wellness-history/$uid?days=$days'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to fetch wellness history');
      }
    } catch (e) {
      print("Error fetching wellness history: $e");
      return [];
    }
  }

  Future<void> manualSync() => fetchHealthData();
}
