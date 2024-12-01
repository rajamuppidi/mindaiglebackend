// lib/features/self_report/models/self_report_metrics.dart

class SelfReportMetrics {
  final int mood;
  final int stress;
  final int hydration;
  final int nutrition;
  final DateTime timestamp;

  SelfReportMetrics({
    required this.mood,
    required this.stress,
    required this.hydration,
    required this.nutrition,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'mood': mood,
        'stress': stress,
        'hydration': hydration,
        'nutrition': nutrition,
        'timestamp': timestamp.toIso8601String(),
      };

  factory SelfReportMetrics.fromJson(Map<String, dynamic> json) =>
      SelfReportMetrics(
        mood: json['mood'] ?? 3,
        stress: json['stress'] ?? 3,
        hydration: json['hydration'] ?? 3,
        nutrition: json['nutrition'] ?? 3,
        timestamp: DateTime.parse(json['timestamp']),
      );
}
