import 'package:flutter/material.dart';

class PersonalGrowthWidget extends StatelessWidget {
  const PersonalGrowthWidget({super.key});

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
              'Personal Growth',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Self Care: {Value}'),
            Text('Symp Ma: {Value}'),
            Text('Social Co: {Value}'),
          ],
        ),
      ),
    );
  }
}
