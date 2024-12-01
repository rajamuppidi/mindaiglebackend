class FoodResource {
  final String id;
  final String name;
  final String type;
  final String address;
  final String contactInfo;
  final String operatingHours;
  final double latitude;
  final double longitude;
  final double rating;
  final bool isOpen;

  FoodResource({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.contactInfo,
    required this.operatingHours,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.isOpen,
  });
}
