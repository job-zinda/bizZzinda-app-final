class BusinessModel {
  final int id;
  final String name;
  final String logo;

  BusinessModel({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
    );
  }
}