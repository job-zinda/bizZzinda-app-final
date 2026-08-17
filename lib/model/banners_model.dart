class Banners {
  String? sId;
  bool? documentStatus;
  String? title;
  String? bannerImageUrl;
  String? bannerOnTapAction;
  String? subscriptionType;
  String? subscriptionPlanId;
  String? createdUser;
  String? createdAt;
  bool? archived;
  int? indexNumber;
  int? iV;
  String? position;
  String? mediaUrl;

  Banners(
      {this.sId,
      this.documentStatus,
      this.title,
      this.bannerImageUrl,
      this.bannerOnTapAction,
      this.subscriptionType,
      this.subscriptionPlanId,
      this.createdUser,
      this.createdAt,
      this.archived,
      this.indexNumber,
      this.iV,
        this.position,
        this.mediaUrl
        });

  Banners.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    documentStatus = json['documentStatus'];
    title = json['title'];
    bannerImageUrl = json['bannerImageUrl'] ?? json['mediaUrl'] ?? json['imageUrl'];
    mediaUrl = json['mediaUrl'] ?? json['bannerImageUrl'] ?? json['imageUrl'];
    bannerOnTapAction = json['bannerOnTapAction'];
    subscriptionType = json['subscriptionType'];
    subscriptionPlanId = json['subscriptionPlanId'];
    createdUser = json['createdUser'];
    createdAt = json['createdAt'];
    archived = json['archived'];
    indexNumber = json['indexNumber'];
    iV = json['__v'];
    position = json['position'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['documentStatus'] = this.documentStatus;
    data['title'] = this.title;
    data['bannerImageUrl'] = this.bannerImageUrl;
    data['bannerOnTapAction'] = this.bannerOnTapAction;
    data['subscriptionType'] = this.subscriptionType;
    data['subscriptionPlanId'] = this.subscriptionPlanId;
    data['createdUser'] = this.createdUser;
    data['createdAt'] = this.createdAt;
    data['archived'] = this.archived;
    data['indexNumber'] = this.indexNumber;
    data['__v'] = this.iV;
    data['position'] = position;

    return data;
  }
}