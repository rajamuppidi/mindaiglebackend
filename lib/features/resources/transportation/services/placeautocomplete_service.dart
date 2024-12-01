import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaceAutocompleteService {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?';
  static const String _apiKey = 'AIzaSyD-XItATbBs4VxvO9goOukjDGS4zBNllV0';

  static Future<List<Map<String, String>>> getPlaceSuggestions(
      String input) async {
    final response =
        await http.get(Uri.parse('${_baseUrl}input=$input&key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return List<Map<String, String>>.from(
            data['predictions'].map((prediction) => {
                  'placeId': prediction['place_id'].toString(),
                  'description': prediction['description'].toString(),
                }));
      }
      throw Exception(
          'Place suggestions request failed: ${data['status']} - ${data['error_message']}');
    }
    throw Exception(
        'Failed to fetch place suggestions: ${response.statusCode}');
  }

  static Future<Map<String, double>> getPlaceDetails(String placeId) async {
    final detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$_apiKey';
    final response = await http.get(Uri.parse(detailsUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final location = data['result']['geometry']['location'];
        return {
          'latitude': location['lat'],
          'longitude': location['lng'],
        };
      }
      throw Exception(
          'Place details request failed: ${data['status']} - ${data['error_message']}');
    }
    throw Exception('Failed to fetch place details: ${response.statusCode}');
  }
}
