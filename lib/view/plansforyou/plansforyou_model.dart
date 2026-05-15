class FreelancerMessageModel {
  final String id;
  final bool documentStatus;
  final String title;
  final String description;
  final String whatsappLink;
  final String? imageUrl;
  final List<String> recipients;
  final String createdUser;
  final DateTime createdAt;
  final String? updatedUser;
  final DateTime updatedAt;
  final int v;
  String? taskId;

  FreelancerMessageModel({
    required this.id,
    required this.documentStatus,
    required this.title,
    required this.description,
    required this.whatsappLink,
    required this.imageUrl,
    required this.recipients,
    required this.createdUser,
    required this.createdAt,
    required this.updatedUser,
    required this.updatedAt,
    required this.v,
    this.taskId,
  });

  factory FreelancerMessageModel.fromJson(Map<String, dynamic> json) {
    return FreelancerMessageModel(
      id: json['_id'] ?? '',
      documentStatus: json['documentStatus'] ?? false,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      whatsappLink: json['whatsappLink'] ?? '',
      imageUrl: json['imageUrl'],
      recipients: json['recipients'] is List
          ? List<String>.from(json['recipients'])
          : [],
      createdUser: json['createdUser'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedUser: json['updatedUser'],
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      v: json['__v'] ?? 0,
      taskId: json['taskId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'documentStatus': documentStatus,
      'title': title,
      'description': description,
      'whatsappLink': whatsappLink,
      'imageUrl': imageUrl,
      'recipients': recipients,
      'createdUser': createdUser,
      'createdAt': createdAt.toIso8601String(),
      'updatedUser': updatedUser,
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
