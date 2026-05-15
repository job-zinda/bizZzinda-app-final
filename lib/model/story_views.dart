class StoryViews {
  String? sId;
  User? user;
  String? story;

  StoryViews({this.sId, this.user, this.story});

  StoryViews.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    story = json['story'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['story'] = story;
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
