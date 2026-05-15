class ProductModel {
  final String? id;
  final String name;
  final String image;
  final int price;
final String? category;
  ProductModel({
    this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.category,
  });

  // FROM JSON (API → App)
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] is int)
          ? json['price']
          : int.tryParse(json['price'].toString()) ?? 0,
      category: json['category'],
    );
  }

  // TO JSON (App → API)
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "image": image,
      "price": price,
      "category": category,
    };
  }
}