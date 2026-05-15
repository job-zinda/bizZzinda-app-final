class Followers {
  String? sId;
  String? followerId;
  String? followingId;
  String? followedOn;
  FollowingDetails? followingDetails;

  Followers(
      {this.sId,
      this.followerId,
      this.followingId,
      this.followedOn,
      this.followingDetails});

  Followers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    followerId = json['followerId'];
    followingId = json['followingId'];
    followedOn = json['followedOn'];
    followingDetails = json['followingDetails'] != null
        ? new FollowingDetails.fromJson(json['followingDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['followerId'] = this.followerId;
    data['followingId'] = this.followingId;
    data['followedOn'] = this.followedOn;
    if (this.followingDetails != null) {
      data['followingDetails'] = this.followingDetails!.toJson();
    }
    return data;
  }
}

class FollowingDetails {
  String? sId;
  String? name;
  String? profileImageUrl;

  FollowingDetails({this.sId, this.name, this.profileImageUrl});

  FollowingDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImageUrl = json['profileImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['profileImageUrl'] = this.profileImageUrl;
    return data;
  }
}