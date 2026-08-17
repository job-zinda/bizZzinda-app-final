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

  final String userId;        // ✅ FIX
  final String userName;      // ✅ FIX
  final String userProfile;

  final String? createdAt;
  final String? contactNumber;
  final String? whatsappNumber;

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
    required this.userId,
    required this.userName,
    required this.userProfile,
    this.createdAt,
    this.contactNumber,
    this.whatsappNumber,
  });
  factory OfferingModel.fromJson(Map<String, dynamic> json) {
    final dynamic userData = json["user"];

    String userId = "";
    String userName = json["name"]?.toString() ?? "";
    String userProfile = json["profileImage"]?.toString() ?? "";
    String? contactNumber;
    String? whatsappNumber;

    if (userData is Map<String, dynamic>) {
      userId = userData["_id"]?.toString() ?? "";
      userName = userData["userName"]?.toString() ?? userName;
      userProfile =
          userData["userProfilePicture"]?.toString() ?? userProfile;
      contactNumber = userData["contactNumber"]?.toString() ?? json["contactNumber"]?.toString();
      whatsappNumber = userData["whatsappNumber"]?.toString() ?? json["whatsappNumber"]?.toString();
    } else {
      userId = userData?.toString() ?? "";
      contactNumber = json["contactNumber"]?.toString();
      whatsappNumber = json["whatsappNumber"]?.toString();
    }

    return OfferingModel(
      id: json['_id']?.toString() ?? '',
      bio: json['bio']?.toString(),
      mediaUrl: json['mediaUrl']?.toString(),
      mediaType: json['mediaType']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      likesCount: int.tryParse(json['likesCount']?.toString() ?? '0') ?? 0,
      shareCount: int.tryParse(json['shareCount']?.toString() ?? '0') ?? 0,
      isLiked: json['isLiked'] == true,
      userId: userId,
      userName: userName,
      userProfile: userProfile,
      createdAt: json['createdAt']?.toString(),
      contactNumber: contactNumber,
      whatsappNumber: whatsappNumber,
    );
  }
  // factory OfferingModel.fromJson(Map<String, dynamic> json) {
  //   return OfferingModel(
  //     id: json['_id']?.toString() ?? '',
  //     bio: json['bio']?.toString(),
  //     mediaUrl: json['mediaUrl']?.toString(),
  //     mediaType: json['mediaType']?.toString(),
  //     city: json['city']?.toString(),
  //     state: json['state']?.toString(),
  //
  //     likesCount: int.tryParse(json['likesCount']?.toString() ?? '0') ?? 0,
  //     shareCount: int.tryParse(json['shareCount']?.toString() ?? '0') ?? 0,
  //     isLiked: json['isLiked'] == true,
  //
  //     userId: json["user"] ?? "",
  //     userName: json["name"] ?? "",
  //     userProfile: json["profileImage"] ?? "",
  //
  //     createdAt: json['createdAt']?.toString(),
  //   );
  // }
}
class OfferUser {
  final String id;
  final String userName;
  final String userProfilePicture;

  OfferUser({
    required this.id,
    required this.userName,
    required this.userProfilePicture,
  });

  factory OfferUser.fromJson(Map<String, dynamic> json) {
    return OfferUser(
      id: json['_id']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      userProfilePicture: json['userProfilePicture']?.toString() ?? '',
    );
  }
}