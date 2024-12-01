import 'package:flutter/material.dart';

class ActivityLogWidget extends StatelessWidget {
  const ActivityLogWidget({super.key});

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
              'Activity Log',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildActivityItem(Icons.directions_walk, 'Steps', '4564'),
            _buildActivityItem(Icons.bedtime, 'Sleep', '6Hrs'),
            _buildActivityItem(Icons.water_drop, 'Hydration', '89%'),
            _buildActivityItem(Icons.fastfood, 'Nutrition', '40%'),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Text(label),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
