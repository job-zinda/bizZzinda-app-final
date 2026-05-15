class ShopModel {
  final String? id;
  final String shopName;
  final String ownerName;
  final String mobileNumber;
  final String email;
  final String address;
  final double latitude;
  final double longitude;
  final String category;
  final String description;
  final bool isActive;

  ShopModel({
    this.id,
    required this.shopName,
    required this.ownerName,
    required this.mobileNumber,
    required this.email,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.description,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      "shopName": shopName,
      "ownerName": ownerName,
      "mobileNumber": mobileNumber,
      "email": email,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "category": category,
      "description": description,
      "isActive": isActive,
    };
  }

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    final data = json["shopData"] ?? json;

    return ShopModel(
      id: data["_id"],
      shopName: data["shopName"],
      ownerName: data["ownerName"],
      mobileNumber: data["mobileNumber"],
      email: data["email"],
      address: data["address"],
      latitude: data["latitude"]?.toDouble() ?? 0.0,
      longitude: data["longitude"]?.toDouble() ?? 0.0,
      category: data["category"] ?? "",
      description: data["description"] ?? "",
      isActive: data["isActive"] ?? true,
    );
  }
}