// lib/features/wearable/services/health_service.dart
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/health_metrics.dart';

class HealthService {
  final Health _health;
  Set<HealthDataType> _availableTypes = {};
  bool _isHealthConnectAvailable = false;

  HealthService() : _health = Health();

  Set<HealthDataType> get availableTypes => _availableTypes;
  bool get isHealthConnectAvailable => _isHealthConnectAvailable;

  bool get hasTemperature =>
      _availableTypes.contains(HealthDataType.BODY_TEMPERATURE);
  bool get hasHeartRate => _availableTypes.contains(HealthDataType.HEART_RATE);
  bool get hasSleep => _availableTypes.contains(HealthDataType.SLEEP_ASLEEP);

  Future<bool> checkHealthConnectAvailability() async {
    try {
      _isHealthConnectAvailable = await _health.hasPermissions([
            HealthDataType.STEPS,
            HealthDataType.HEART_RATE,
          ]) ??
          false;
      return _isHealthConnectAvailable;
    } catch (e) {
      print("Error checking Health Connect availability: $e");
      return false;
    }
  }

  Future<bool> installHealthConnect() async {
    try {
      // Open Google Play Store link for Health Connect
      final Uri url = Uri.parse(
          'https://play.google.com/store/apps/details?id=com.google.android.apps.healthdata');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
        return true;
      }
      return false;
    } catch (e) {
      print("Error launching Health Connect installation: $e");
      return false;
    }
  }

  Future<bool> requestPermissions() async {
    try {
      // Check Health Connect availability first
      bool hasHealthConnect = await checkHealthConnectAvailability();

      if (!hasHealthConnect) {
        // Try alternative data sources if Health Connect is not available
        return await _requestAlternativePermissions();
      }

      // If Health Connect is available, proceed with normal flow
      final types = [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.BODY_TEMPERATURE,
      ];

      bool? healthPermissionsGranted =
          await _health.requestAuthorization(types);

      if (healthPermissionsGranted == true) {
        _availableTypes = Set.from(types);
        await _checkAvailableDataTypes();
        return true;
      }

      return false;
    } catch (e) {
      print("Error requesting permissions: $e");
      return await _requestAlternativePermissions();
    }
  }

  Future<void> _checkAvailableDataTypes() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    Set<HealthDataType> verifiedTypes = {};

    for (var type in _availableTypes) {
      try {
        final data = await _health.getHealthDataFromTypes(
          startTime: yesterday,
          endTime: now,
          types: [type],
        );
        if (data.isNotEmpty) {
          verifiedTypes.add(type);
          print("Health data type $type is supported and has data");
        }
      } catch (e) {
        print("Health data type $type is not supported or has no data: $e");
      }
    }

    _availableTypes = verifiedTypes;
  }

  Future<bool> _requestAlternativePermissions() async {
    try {
      // Request basic Android permissions for activity recognition and sensors
      final permissions = [
        Permission.activityRecognition,
        Permission.sensors,
      ];

      Map<Permission, PermissionStatus> statuses = await permissions.request();
      bool androidPermissionsGranted =
          statuses.values.every((status) => status.isGranted);

      if (androidPermissionsGranted) {
        // Add basic metrics that don't require Health Connect
        _availableTypes = {HealthDataType.STEPS};
        return true;
      }

      return false;
    } catch (e) {
      print("Error requesting alternative permissions: $e");
      return false;
    }
  }

  Future<HealthMetrics?> fetchHealthData() async {
    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      double steps = 0;
      double? heartRate;
      double? temperature;
      double? sleepHours;

      // Always try to fetch steps as it's the most commonly available metric
      try {
        if (_isHealthConnectAvailable) {
          final stepsData = await _health.getHealthDataFromTypes(
            startTime: midnight,
            endTime: now,
            types: [HealthDataType.STEPS],
          );

          if (stepsData.isNotEmpty) {
            steps = stepsData.fold(
                0.0, (sum, dp) => sum + double.parse(dp.value.toString()));
          }
        } else {
          // Implement alternative steps counting logic here if needed
          // For example, using activity recognition API directly
          steps = await _getStepsFromAlternativeSource();
        }
      } catch (e) {
        print("Error fetching steps: $e");
      }

      // Only fetch other metrics if Health Connect is available
      if (_isHealthConnectAvailable) {
        // Fetch other metrics as before...
        if (_availableTypes.contains(HealthDataType.HEART_RATE)) {
          heartRate = await _fetchHeartRate(midnight, now);
        }

        if (_availableTypes.contains(HealthDataType.BODY_TEMPERATURE)) {
          temperature = await _fetchTemperature(midnight, now);
        }

        if (_availableTypes.contains(HealthDataType.SLEEP_ASLEEP)) {
          sleepHours = await _fetchSleep(midnight, now);
        }
      }

      return HealthMetrics(
        steps: steps,
        heartRate: heartRate,
        temperature: temperature,
        sleepHours: sleepHours,
      );
    } catch (e) {
      print("Error fetching health data: $e");
      return null;
    }
  }

  Future<double> _getStepsFromAlternativeSource() async {
    // Implement alternative steps tracking logic here
    // This could use the Android Activity Recognition API directly
    // For now, return 0 as placeholder
    return 0;
  }

  Future<double?> _fetchHeartRate(DateTime start, DateTime end) async {
    try {
      final heartRateData = await _health.getHealthDataFromTypes(
        startTime: start,
        endTime: end,
        types: [HealthDataType.HEART_RATE],
      );
      if (heartRateData.isNotEmpty) {
        return double.parse(heartRateData.last.value.toString());
      }
    } catch (e) {
      print("Error fetching heart rate: $e");
      _availableTypes.remove(HealthDataType.HEART_RATE);
    }
    return null;
  }

  Future<double?> _fetchTemperature(DateTime start, DateTime end) async {
    try {
      final tempData = await _health.getHealthDataFromTypes(
        startTime: start,
        endTime: end,
        types: [HealthDataType.BODY_TEMPERATURE],
      );
      if (tempData.isNotEmpty) {
        return double.parse(tempData.last.value.toString());
      }
    } catch (e) {
      print("Error fetching temperature: $e");
      _availableTypes.remove(HealthDataType.BODY_TEMPERATURE);
    }
    return null;
  }

  Future<double?> _fetchSleep(DateTime start, DateTime end) async {
    try {
      final sleepData = await _health.getHealthDataFromTypes(
        startTime: start,
        endTime: end,
        types: [HealthDataType.SLEEP_ASLEEP],
      );
      if (sleepData.isNotEmpty) {
        return sleepData.fold(
                0.0, (sum, item) => sum + double.parse(item.value.toString())) /
            3600;
      }
    } catch (e) {
      print("Error fetching sleep data: $e");
      _availableTypes.remove(HealthDataType.SLEEP_ASLEEP);
    }
    return null;
  }
}
