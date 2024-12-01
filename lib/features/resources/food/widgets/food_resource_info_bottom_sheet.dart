import 'package:flutter/material.dart';
import 'package:mindaigle/features/resources/food/models/food_resource.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodResourceInfoBottomSheet extends StatelessWidget {
  final FoodResource resource;
  final double distance;

  const FoodResourceInfoBottomSheet({
    super.key,
    required this.resource,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            resource.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text('Address: ${resource.address}'),
          const SizedBox(height: 4.0),
          Text('Contact: ${resource.contactInfo}'),
          const SizedBox(height: 4.0),
          Text('Operating Hours: ${resource.operatingHours}'),
          const SizedBox(height: 4.0),
          Text('Distance: ${distance.toStringAsFixed(2)} km'),
          const SizedBox(height: 4.0),
          Text(
            'Status: ${resource.isOpen ? 'Open' : 'Closed'}',
            style: TextStyle(
              color: resource.isOpen ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () =>
                _launchMapsUrl(resource.latitude, resource.longitude),
            child: const Text('Get Directions'),
          ),
        ],
      ),
    );
  }

  void _launchMapsUrl(double lat, double lon) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
