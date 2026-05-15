// class OfferingModel {
//   final String? id; // <-- Add this
//   final String? bio;
//   final String? mediaUrl;
//   final String? mediaType;
//   final String? city;
//   final String? state;
//   final int? likesCount;
//   final int? shareCount;
//   final bool? isLiked;
//  final String? userProfile;
//  final String? userName;
//   // final String? createdAt;
//
//   OfferingModel({
//     this.id,
//     this.bio,
//     this.mediaUrl,
//     this.mediaType,
//     this.city,
//     this.state,
//     this.likesCount,
//     this.shareCount,
//     this.isLiked,
//     this.userProfile,
//     this.userName,
//     this.createdAt
//   });
//
//   factory OfferingModel.fromJson(Map<String, dynamic> json) {
//     return OfferingModel(
//       id: json['_id'], // <-- Map _id to id
//       bio: json['bio'],
//       mediaUrl: json['mediaUrl'],
//       mediaType: json['mediaType'],
//       city: json['city'],
//       state: json['state'],
//       likesCount: json['likesCount'],
//       shareCount: json['shareCount'],
//       isLiked: json['isLiked'],
//       userProfile: json['profileImage'],
//       userName: json['name'],
//       createdAt: json["createdAt"],
//     );
//   }
// }
class OfferingModel {
  final String id;
  final String? bio;
  final String? mediaUrl;
  final String? mediaType;
  final String? city;
  final String? state;
  int? likesCount;
   int? shareCount;
  bool? isLiked;

  final String? userProfile;
  final String? userName;
  final String? createdAt;
  final String? userId;
  final String? shopId;

  OfferingModel({
    required this.id,
    this.bio,
    this.mediaUrl,
    this.mediaType,
    this.city,
    this.state,
    this.likesCount,
    this.shareCount,
    this.isLiked,
    this.userProfile,
    this.userName,
    this.createdAt,
    this.userId,
    this.shopId,
  });

  factory OfferingModel.fromJson(Map<String, dynamic> json) {
    return OfferingModel(
      id: json['_id']?.toString() ?? '',
      bio: json['bio']?.toString(),
      mediaUrl: json['mediaUrl']?.toString(),
      mediaType: json['mediaType']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),

      likesCount: (json['likesCount'] is int)
          ? json['likesCount']
          : int.tryParse(json['likesCount']?.toString() ?? '0') ?? 0,

      shareCount: (json['shareCount'] is int)
          ? json['shareCount']
          : int.tryParse(json['shareCount']?.toString() ?? '0') ?? 0,

      isLiked: json['isLiked'] == true,

      userProfile: json['profileImage']?.toString(),
      userName: json['name']?.toString(),
      createdAt: json['createdAt']?.toString(),
      userId: json['user']?.toString(),
      shopId: json['shopId']?.toString(),
    );
  }
}