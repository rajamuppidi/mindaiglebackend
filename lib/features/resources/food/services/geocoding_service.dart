import 'package:geocoding/geocoding.dart';

class GeocodingService {
  static Future<Location> getCoordinatesFromZipCode(String zipCode) async {
    List<Location> locations = await locationFromAddress(zipCode);
    return locations.first;
  }
}
