import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WellnessScoreWidget extends StatelessWidget {
  const WellnessScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Wellness Score',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            CircularPercentIndicator(
              radius: 50.0,
              lineWidth: 10.0,
              percent: 0.8,
              center: const Text(
                "80%",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              progressColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
