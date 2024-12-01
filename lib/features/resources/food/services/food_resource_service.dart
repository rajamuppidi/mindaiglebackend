import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mindaigle/features/resources/food/models/food_resource.dart';
import 'package:mindaigle/features/resources/food/models/location_data.dart';

class FoodResourceService {
  static const String apiKey = 'AIzaSyD-XItATbBs4VxvO9goOukjDGS4zBNllV0';

  static Future<List<FoodResource>> fetchFoodResources(
    LocationData location,
    List<String> categories,
    double radius,
  ) async {
    final List<FoodResource> foodResources = [];

    final Map<String, String> categoryMap = {
      'Grocery Stores': 'grocery_or_supermarket',
      'Farmers\' Markets': 'farmers_market',
      'Health Food Stores': 'health_food_store',
      'Food Pantries': 'food_pantry',
      'Meal Delivery Services': 'meal_delivery',
    };

    for (String category in categories) {
      String url;
      if (category == 'Farmers\' Markets') {
        url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
            '?location=${location.latitude},${location.longitude}'
            '&radius=$radius'
            '&keyword=farmers%20market'
            '&key=$apiKey';
      } else if (category == 'Food Pantries') {
        url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
            '?location=${location.latitude},${location.longitude}'
            '&radius=$radius'
            '&keyword=food%20pantry'
            '&key=$apiKey';
      } else {
        url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
            '?location=${location.latitude},${location.longitude}'
            '&radius=$radius'
            '&type=${categoryMap[category]}'
            '&key=$apiKey';
      }

      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        for (var result in data['results']) {
          foodResources.add(FoodResource(
            id: result['place_id'],
            name: result['name'],
            type: category,
            address: result['vicinity'],
            contactInfo: result['formatted_phone_number'] ?? 'N/A',
            operatingHours: _parseOperatingHours(result['opening_hours']),
            latitude: result['geometry']['location']['lat'],
            longitude: result['geometry']['location']['lng'],
            rating: result['rating']?.toDouble() ?? 0.0,
            isOpen: result['opening_hours']?['open_now'] ?? false,
          ));
        }
      } else {
        throw Exception('Failed to fetch food resources');
      }
    }

    return foodResources;
  }

  static String _parseOperatingHours(Map<String, dynamic>? openingHours) {
    if (openingHours == null || openingHours['weekday_text'] == null) {
      return 'N/A';
    }
    return (openingHours['weekday_text'] as List).join(', ');
  }
}
