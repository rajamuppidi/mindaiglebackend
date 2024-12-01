import 'package:flutter/material.dart';

class PersonalizedTipsWidget extends StatelessWidget {
  final List<String> tips = [
    'Set Medication Reminders',
    '30 More Minutes of Sleep a Night Will Really Improve Your Physical / Cognitive Energy',
    'Try These Breathing Exercises when Stressed',
  ];

  PersonalizedTipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personalized Tips',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...tips.map((tip) => _buildTipItem(tip)),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb, color: Colors.yellow),
          const SizedBox(width: 16),
          Expanded(child: Text(tip)),
        ],
      ),
    );
  }
}
