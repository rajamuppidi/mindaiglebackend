// lib/features/wearable/models/health_metrics.dart

class HealthMetrics {
  final double steps;
  final double? heartRate;
  final double? temperature;
  final double? sleepHours;
  final DateTime timestamp;
  final double? wellnessScore;

  HealthMetrics({
    required this.steps,
    this.heartRate,
    this.temperature,
    this.sleepHours,
    this.wellnessScore,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'steps': steps,
        if (heartRate != null) 'heartRate': heartRate,
        if (temperature != null) 'temperature': temperature,
        if (sleepHours != null) 'sleepDuration': sleepHours,
        if (wellnessScore != null) 'wellness_score': wellnessScore,
        'timestamp': timestamp.toIso8601String(),
      };

  factory HealthMetrics.fromJson(Map<String, dynamic> json) => HealthMetrics(
        steps: (json['steps'] as num).toDouble(),
        heartRate: json['heartRate'] != null
            ? (json['heartRate'] as num).toDouble()
            : null,
        temperature: json['temperature'] != null
            ? (json['temperature'] as num).toDouble()
            : null,
        sleepHours: json['sleepDuration'] != null
            ? (json['sleepDuration'] as num).toDouble()
            : null,
        wellnessScore: json['wellness_score'] != null
            ? (json['wellness_score'] as num).toDouble()
            : null,
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'])
            : null,
      );

  // Copy with method for creating new instances with modified values
  HealthMetrics copyWith({
    double? steps,
    double? heartRate,
    double? temperature,
    double? sleepHours,
    double? wellnessScore,
    DateTime? timestamp,
  }) {
    return HealthMetrics(
      steps: steps ?? this.steps,
      heartRate: heartRate ?? this.heartRate,
      temperature: temperature ?? this.temperature,
      sleepHours: sleepHours ?? this.sleepHours,
      wellnessScore: wellnessScore ?? this.wellnessScore,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Helper method to check if metric is available
  bool hasMetric(String metric) {
    switch (metric) {
      case 'heartRate':
        return heartRate != null;
      case 'temperature':
        return temperature != null;
      case 'sleepHours':
        return sleepHours != null;
      case 'steps':
        return true; // Steps is always required
      default:
        return false;
    }
  }

  // Get formatted value for display
  String getFormattedValue(String metric) {
    switch (metric) {
      case 'steps':
        return '${steps.toStringAsFixed(0)} steps';
      case 'heartRate':
        return heartRate != null
            ? '${heartRate!.toStringAsFixed(0)} bpm'
            : 'N/A';
      case 'temperature':
        return temperature != null
            ? '${temperature!.toStringAsFixed(1)}°C'
            : 'N/A';
      case 'sleepHours':
        return sleepHours != null
            ? '${sleepHours!.toStringAsFixed(1)} hrs'
            : 'N/A';
      case 'wellnessScore':
        return wellnessScore != null
            ? '${wellnessScore!.toStringAsFixed(0)}%'
            : 'N/A';
      default:
        return 'N/A';
    }
  }

  // Get color status for metrics (for UI purposes)
  String getMetricStatus(String metric) {
    if (!hasMetric(metric)) return 'unavailable';

    switch (metric) {
      case 'steps':
        if (steps >= 10000) return 'excellent';
        if (steps >= 7500) return 'good';
        if (steps >= 5000) return 'fair';
        return 'poor';

      case 'heartRate':
        if (heartRate == null) return 'unavailable';
        if (heartRate! >= 60 && heartRate! <= 100) return 'good';
        return 'warning';

      case 'temperature':
        if (temperature == null) return 'unavailable';
        if (temperature! >= 36.5 && temperature! <= 37.5) return 'good';
        return 'warning';

      case 'sleepHours':
        if (sleepHours == null) return 'unavailable';
        if (sleepHours! >= 7) return 'good';
        if (sleepHours! >= 6) return 'fair';
        return 'poor';

      default:
        return 'unavailable';
    }
  }

  // Get reference ranges for metrics
  Map<String, String> getReferenceRange(String metric) {
    switch (metric) {
      case 'steps':
        return {'min': '7500', 'max': '10000', 'unit': 'steps'};
      case 'heartRate':
        return {'min': '60', 'max': '100', 'unit': 'bpm'};
      case 'temperature':
        return {'min': '36.5', 'max': '37.5', 'unit': '°C'};
      case 'sleepHours':
        return {'min': '7', 'max': '9', 'unit': 'hours'};
      default:
        return {'min': 'N/A', 'max': 'N/A', 'unit': ''};
    }
  }

  @override
  String toString() {
    return 'HealthMetrics(steps: $steps, heartRate: $heartRate, temperature: $temperature, sleepHours: $sleepHours, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthMetrics &&
        other.steps == steps &&
        other.heartRate == heartRate &&
        other.temperature == temperature &&
        other.sleepHours == sleepHours &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return steps.hashCode ^
        heartRate.hashCode ^
        temperature.hashCode ^
        sleepHours.hashCode ^
        timestamp.hashCode;
  }
}

// // lib/features/wearable/models/health_metrics.dart

// class HealthMetrics {
//   final double steps;
//   final double? heartRate;
//   final double? temperature;
//   final double? sleepHours;
//   final DateTime timestamp;

//   HealthMetrics({
//     required this.steps,
//     this.heartRate,
//     this.temperature,
//     this.sleepHours,
//     DateTime? timestamp,
//   }) : timestamp = timestamp ?? DateTime.now();

//   Map<String, dynamic> toJson() {
//     return {
//       'steps': steps,
//       'heartRate': heartRate,
//       'temperature': temperature,
//       'sleepHours': sleepHours,
//       'timestamp': timestamp.toIso8601String(),
//     };
//   }

//   factory HealthMetrics.fromJson(Map<String, dynamic> json) {
//     return HealthMetrics(
//       steps: json['steps'].toDouble(),
//       heartRate: json['heartRate']?.toDouble(),
//       temperature: json['temperature']?.toDouble(),
//       sleepHours: json['sleepHours']?.toDouble(),
//       timestamp: DateTime.parse(json['timestamp']),
//     );
//   }

//   String getFormattedValue(String metric) {
//     switch (metric) {
//       case 'steps':
//         return '${steps.toStringAsFixed(0)} steps';
//       case 'heartRate':
//         return heartRate != null
//             ? '${heartRate!.toStringAsFixed(0)} bpm'
//             : 'N/A';
//       case 'temperature':
//         return temperature != null
//             ? '${temperature!.toStringAsFixed(1)}°F'
//             : 'N/A';
//       case 'sleepHours':
//         return sleepHours != null
//             ? '${sleepHours!.toStringAsFixed(1)} hrs'
//             : 'N/A';
//       default:
//         return 'N/A';
//     }
//   }
// }
