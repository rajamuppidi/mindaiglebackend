import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mindaigle/features/resources/food/models/food_resource.dart';
import 'package:mindaigle/features/resources/food/models/location_data.dart';
import 'package:mindaigle/features/resources/food/services/food_resource_service.dart';
import 'package:mindaigle/features/resources/food/services/geocoding_service.dart';
import 'package:mindaigle/features/resources/food/services/location_service.dart';
import 'package:mindaigle/features/resources/food/widgets/food_resource_category_button.dart';
import 'package:mindaigle/features/resources/food/widgets/food_resource_info_bottom_sheet.dart';
import 'package:geolocator/geolocator.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  final Set<Marker> _markers = {};
  List<FoodResource> _foodResources = [];
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = [
    'Grocery Stores',
    'Farmers\' Markets',
    'Health Food Stores',
    'Food Pantries',
    'Meal Delivery Services',
  ];
  String _selectedCategory = 'Grocery Stores';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      LocationData? location = await LocationService.getUserLocation();
      if (location != null) {
        setState(() {
          _currentLocation = LatLng(location.latitude, location.longitude);
        });
        _updateMap(_currentLocation!);
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _updateMap(LatLng location) {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(location));
      _fetchFoodResources(location);
    }
  }

  void _fetchFoodResources(LatLng location) async {
    try {
      List<FoodResource> resources =
          await FoodResourceService.fetchFoodResources(
        LocationData(
            latitude: location.latitude, longitude: location.longitude),
        [_selectedCategory],
        5000, // 5km radius
      );
      setState(() {
        _foodResources = resources;
        _updateMarkers();
      });
    } catch (e) {
      print('Error fetching food resources: $e');
    }
  }

  void _updateMarkers() {
    _markers.clear();
    for (var resource in _foodResources) {
      _markers.add(
        Marker(
          markerId: MarkerId(resource.id),
          position: LatLng(resource.latitude, resource.longitude),
          infoWindow: InfoWindow(title: resource.name),
          onTap: () => _showBottomSheet(resource),
        ),
      );
    }
    setState(() {});
  }

  void _showBottomSheet(FoodResource resource) {
    double distance = _calculateDistance(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      resource.latitude,
      resource.longitude,
    );

    showModalBottomSheet(
      context: context,
      builder: (context) => FoodResourceInfoBottomSheet(
        resource: resource,
        distance: distance,
      ),
    );
  }

  double _calculateDistance(
      double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng) /
        1000; // Convert meters to kilometers
  }

  void _onSearch(String value) async {
    if (value.isNotEmpty) {
      try {
        final location =
            await GeocodingService.getCoordinatesFromZipCode(value);
        final newLocation = LatLng(location.latitude, location.longitude);
        _updateMap(newLocation);
      } catch (e) {
        print('Error searching location: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Resources'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by ZIP code',
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: _onSearch,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2.0),
            height: 50,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _categories
                  .map((category) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FoodResourceCategoryButton(
                          category: category,
                          onPressed: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                            if (_currentLocation != null) {
                              _fetchFoodResources(_currentLocation!);
                            }
                          },
                          isSelected: _selectedCategory == category,
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: _currentLocation == null
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      GoogleMap(
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                        },
                        initialCameraPosition: CameraPosition(
                          target: _currentLocation!,
                          zoom: 15.0,
                        ),
                        markers: _markers,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                      ),
                      Positioned(
                        left: 16,
                        bottom: 16,
                        child: FloatingActionButton(
                          child: const Icon(Icons.my_location),
                          onPressed: () {
                            _getCurrentLocation();
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
