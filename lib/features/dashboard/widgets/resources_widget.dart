import 'package:flutter/material.dart';

class ResourcesWidget extends StatelessWidget {
  const ResourcesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resources to Try',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Food Resources'),
            Text('Transportation Services'),
            Text('Mental Health Support'),
          ],
        ),
      ),
    );
  }
}
