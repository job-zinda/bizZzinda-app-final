class MyStoryModel {
  String? sId;
  User? user;
  String? notificationType;
  List<Media>? media;
  String? description;
  String? caption;
  bool? archived;
  bool? isActive;
  String? createdAt;
  String? lastUploadedMedia;
  int? iV;

  MyStoryModel(
      {this.sId,
      this.user,
      this.notificationType,
      this.media,
      this.description,
      this.caption,
      this.archived,
      this.isActive,
      this.createdAt,
      this.lastUploadedMedia,
      this.iV});

  MyStoryModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    notificationType = json['notificationType'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    description = json['description'];
    caption = json['caption'];
    archived = json['archived'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    lastUploadedMedia = json['lastUploadedMedia'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['notificationType'] = notificationType;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    data['description'] = description;
    data['caption'] = caption;
    data['archived'] = archived;
    data['isActive'] = isActive;
    data['createdAt'] = createdAt;
    data['lastUploadedMedia'] = lastUploadedMedia;
    data['__v'] = iV;
    return data;
  }
}

class User {
  String? sId;
  String? name;
  String? profileImageUrl;

  User({this.sId, this.name, this.profileImageUrl});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImageUrl = json['profileImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['profileImageUrl'] = profileImageUrl;
    return data;
  }
}

class Media {
  String? mediaType;
  String? content;
  int? duration;
  String? postedAt;
  String? sId;

  Media({this.mediaType, this.content, this.duration, this.postedAt, this.sId});

  Media.fromJson(Map<String, dynamic> json) {
    mediaType = json['mediaType'];
    content = json['content'];
    duration = json['duration'];
    postedAt = json['postedAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mediaType'] = mediaType;
    data['content'] = content;
    data['duration'] = duration;
    data['postedAt'] = postedAt;
    data['_id'] = sId;
    return data;
  }
}