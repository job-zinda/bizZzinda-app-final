//
// class ServiceModel {
//   final int id;
//   final String title;
//   final String image;
//   final String price;
//   final String duration;
//
//   ServiceModel({
//     required this.id,
//     required this.title,
//     required this.image,
//     required this.price,
//     required this.duration,
//   });
//
//   factory ServiceModel.fromJson(Map<String, dynamic> json) {
//     return ServiceModel(
//       id: json['id'],
//       title: json['title'],
//       image: json['image'],
//       price: json['price'],
//       duration: json['duration'] ?? "",
//     );
//   }
// }
class ServiceModel {
  final String id;
  final String title;
  final String image;
  final int price;
  final String duration;

  ServiceModel({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.duration,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? "",
      title: json['title'] ?? "",
      image: json['image'] ?? "",
      price: json['price'] ?? 0, // ✅ FIX HERE
      duration: json['duration'] ?? "",
    );
  }
}