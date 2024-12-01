import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class TransportationRoute {
  final String id;
  final LatLng origin;
  final LatLng destination;
  final List<LatLng> polylinePoints;
  final String distance;
  final String duration;
  final LatLngBounds bounds;

  TransportationRoute({
    required this.id,
    required this.origin,
    required this.destination,
    required this.polylinePoints,
    required this.distance,
    required this.duration,
    required this.bounds,
  });

  factory TransportationRoute.fromMap(Map<String, dynamic> map) {
    final data = map['routes'][0];
    final leg = data['legs'][0];
    final polylinePoints =
        PolylinePoints().decodePolyline(data['overview_polyline']['points']);

    return TransportationRoute(
      id: map['request_id'] ?? '',
      origin:
          LatLng(leg['start_location']['lat'], leg['start_location']['lng']),
      destination:
          LatLng(leg['end_location']['lat'], leg['end_location']['lng']),
      polylinePoints: polylinePoints
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList(),
      distance: leg['distance']['text'],
      duration: leg['duration']['text'],
      bounds: LatLngBounds(
        southwest: LatLng(data['bounds']['southwest']['lat'],
            data['bounds']['southwest']['lng']),
        northeast: LatLng(data['bounds']['northeast']['lat'],
            data['bounds']['northeast']['lng']),
      ),
    );
  }
}
