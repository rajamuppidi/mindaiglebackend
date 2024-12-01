import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_service.dart';
import '../services/directions_service.dart';
import '../widgets/location_input_field.dart';
import '../widgets/route_info_bottom_sheet.dart';
import '../models/transportation_route.dart';

class TransportationPage extends StatefulWidget {
  const TransportationPage({super.key});

  @override
  _TransportationPageState createState() => _TransportationPageState();
}

class _TransportationPageState extends State<TransportationPage> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  LatLng? _originLocation;
  LatLng? _destinationLocation;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  TransportationRoute? _currentRoute;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      final location = await LocationService.getUserLocation();
      if (location != null) {
        setState(() {
          _currentLocation = LatLng(location.latitude, location.longitude);
          _originLocation =
              _currentLocation; // Set current location as default origin
        });
        _updateMap(_currentLocation!);
      }
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Failed to get current location. Please enter manually.')),
      );
    }
  }

  void _updateMap(LatLng location) {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(location));
    }
  }

  void _searchRoute() async {
    if (_originLocation == null || _destinationLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter both origin and destination')),
      );
      return;
    }

    try {
      final route = await DirectionsService.getDirections(
          _originLocation!, _destinationLocation!);
      setState(() {
        _currentRoute = route;
        _markers.clear();
        _polylines.clear();

        _markers.add(Marker(
          markerId: const MarkerId('origin'),
          position: route.origin,
          infoWindow: const InfoWindow(title: 'Origin'),
        ));
        _markers.add(Marker(
          markerId: const MarkerId('destination'),
          position: route.destination,
          infoWindow: const InfoWindow(title: 'Destination'),
        ));

        _polylines.add(Polyline(
          polylineId: const PolylineId('route'),
          points: route.polylinePoints,
          color: Colors.blue,
          width: 5,
        ));

        _mapController
            ?.animateCamera(CameraUpdate.newLatLngBounds(route.bounds, 100));
      });

      _showRouteInfo(route);
    } catch (e) {
      print('Error searching route: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching for route: ${e.toString()}')),
      );
    }
  }

  void _showRouteInfo(TransportationRoute route) {
    showModalBottomSheet(
      context: context,
      builder: (context) => RouteInfoBottomSheet(route: route),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transportation'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                LocationInputField(
                  hintText: 'Enter origin',
                  initialValue: _originLocation != null
                      ? '${_originLocation!.latitude}, ${_originLocation!.longitude}'
                      : '',
                  onLocationSelected: (LatLng location) {
                    setState(() {
                      _originLocation = location;
                    });
                  },
                ),
                const SizedBox(height: 8),
                LocationInputField(
                  hintText: 'Enter destination',
                  onLocationSelected: (LatLng location) {
                    setState(() {
                      _destinationLocation = location;
                    });
                  },
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _searchRoute,
                  child: const Text('Search Route'),
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _currentLocation ?? const LatLng(0, 0),
                zoom: 15.0,
              ),
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
