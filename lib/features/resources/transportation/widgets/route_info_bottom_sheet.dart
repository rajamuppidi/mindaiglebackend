import 'package:flutter/material.dart';
import '../models/transportation_route.dart';

class RouteInfoBottomSheet extends StatelessWidget {
  final TransportationRoute route;

  const RouteInfoBottomSheet({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Distance: ${route.distance}',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Duration: ${route.duration}',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // navigation start logic here
            },
            child: const Text('Start Navigation'),
          ),
        ],
      ),
    );
  }
}
