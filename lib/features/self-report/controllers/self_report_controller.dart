// lib/features/self_report/controllers/self_report_controller.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/self_report_metrics.dart';

class SelfReportController extends ChangeNotifier {
  SelfReportMetrics _metrics = SelfReportMetrics(
    mood: 3,
    stress: 3,
    hydration: 3,
    nutrition: 3,
  );
  bool _isSaving = false;

  // Getters
  SelfReportMetrics get metrics => _metrics;
  bool get isSaving => _isSaving;
  double get wellnessScore => calculateWellnessScore();

  // Update methods
  void updateMood(int value) {
    _metrics = SelfReportMetrics(
      mood: value,
      stress: _metrics.stress,
      hydration: _metrics.hydration,
      nutrition: _metrics.nutrition,
    );
    notifyListeners();
  }

  void updateStress(int value) {
    _metrics = SelfReportMetrics(
      mood: _metrics.mood,
      stress: value,
      hydration: _metrics.hydration,
      nutrition: _metrics.nutrition,
    );
    notifyListeners();
  }

  void updateHydration(int value) {
    _metrics = SelfReportMetrics(
      mood: _metrics.mood,
      stress: _metrics.stress,
      hydration: value,
      nutrition: _metrics.nutrition,
    );
    notifyListeners();
  }

  void updateNutrition(int value) {
    _metrics = SelfReportMetrics(
      mood: _metrics.mood,
      stress: _metrics.stress,
      hydration: _metrics.hydration,
      nutrition: value,
    );
    notifyListeners();
  }

  double calculateWellnessScore() {
    // Simple calculation - can be made more sophisticated
    final moodScore = (_metrics.mood / 5) * 25;
    final stressScore = ((6 - _metrics.stress) / 5) * 25; // Inverse for stress
    final hydrationScore = (_metrics.hydration / 5) * 25;
    final nutritionScore = (_metrics.nutrition / 5) * 25;

    return moodScore + stressScore + hydrationScore + nutritionScore;
  }

  Future<void> saveMetrics() async {
    _isSaving = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');
      if (uid == null) throw Exception('User not found');

      final response = await http.post(
        Uri.parse('YOUR_API_URL/daily-health-data'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uid': uid,
          'date': DateTime.now().toIso8601String().split('T')[0],
          'source': 'self-report',
          ..._metrics.toJson(),
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save metrics');
      }
    } catch (e) {
      print("Error saving metrics: $e");
      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
