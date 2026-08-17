class PostModel {
  String? sId;
  String? bio;
  String? mediaType;
  String? mediaUrl;
  String? thumbnail;

  int? duration;
  int? likesCount;
  int? commentsCount;
  int? shareCount;
  User? user;
  String? sharedWith;
  String? createdAt;
  bool? isLiked;

  PostModel(
      {this.sId,
      this.bio,
      this.mediaType,
      this.mediaUrl,
      this.duration,
      this.likesCount,
      this.commentsCount,
      this.shareCount,
      this.user,
      this.sharedWith,
      this.thumbnail,
      this.createdAt,
      this.isLiked});
  factory PostModel.defaultPost() {
    return PostModel(
      sId: '0',
      bio: 'No post available',
      mediaType: 'video',
      mediaUrl: null,
      thumbnail: null,
      duration: 0,
      likesCount: 0,
      commentsCount: 0,
      shareCount: 0,
      user: User(
        sId: '0',
        userName: 'Unknown',
        userProfilePicture: null,
      ),
      sharedWith: null,
      createdAt: DateTime.now().toString(),
      isLiked: false,
    );
  }

  PostModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    bio = json['bio'];
    mediaType = json['mediaType'];
    mediaUrl = json['mediaUrl'];
    thumbnail = json['thumbnail'];

    // Coerce via num so a double (e.g. a video `duration` like 12.5 from the
    // guest/public feed) doesn't throw "double is not a subtype of int?".
    duration = (json['duration'] as num?)?.toInt();
    likesCount = (json['likesCount'] as num?)?.toInt();
    commentsCount = (json['commentsCount'] as num?)?.toInt();
    shareCount = (json['shareCount'] as num?)?.toInt();
    user = json['user'] != null && json['user'] is Map
        ? User.fromJson(json['user'])
        : User();
    sharedWith = json['sharedWith'];
    createdAt = json['createdAt'];
    isLiked = json.containsKey('isLiked') ? json['isLiked'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['bio'] = bio;
    data['mediaType'] = mediaType;
    data['mediaUrl'] = mediaUrl;
    data['thumbnail'] = thumbnail;
    data['duration'] = duration;
    data['likesCount'] = likesCount;
    data['commentsCount'] = commentsCount;
    data['shareCount'] = shareCount;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['sharedWith'] = sharedWith;
    data['createdAt'] = createdAt;
    data['isLiked'] = isLiked;
    return data;
  }
}

class User {
  String? sId;
  String? userName;
  String? userProfilePicture;
  String? professionId;
  String? professionName;
  bool? isVerified;

  User(
      {this.sId,
      this.userName,
      this.userProfilePicture,
      this.professionId,
      this.professionName,
      this.isVerified});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['userName'];
    userProfilePicture = json['userProfilePicture'];
    professionId = json['professionId'];
    professionName = json['professionName'];
    isVerified = json['isVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userName'] = userName;
    data['userProfilePicture'] = userProfilePicture;
    data['professionId'] = professionId;
    data['professionName'] = professionName;
    data['isVerified'] = isVerified;
    return data;
  }
}
