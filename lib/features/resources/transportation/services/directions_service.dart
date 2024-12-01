import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/transportation_route.dart';

class DirectionsService {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';
  static const String _apiKey = 'AIzaSyD-XItATbBs4VxvO9goOukjDGS4zBNllV0';

  static Future<TransportationRoute> getDirections(
      LatLng origin, LatLng destination) async {
    final response = await http.get(Uri.parse(
        '${_baseUrl}origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return TransportationRoute.fromMap(data);
      }
      throw Exception(
          'Directions request failed: ${data['status']} - ${data['error_message']}');
    }
    throw Exception('Failed to fetch directions: ${response.statusCode}');
  }
}
