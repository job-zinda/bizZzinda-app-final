class StoreModel {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final String? profileImageUrl;
  final String profession;
  String? coverImage;

  StoreModel({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    this.profileImageUrl,
    required this.profession,
    this.coverImage,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      profileImageUrl: json['profileImageUrl'],
      profession: json['profession'] ?? '',
      coverImage: json['coverImage'],
    );
  }
}