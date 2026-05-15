class Replies {
  String? sId;
  String? post;
  String? comment;
  String? reply;
  RepliedBy? repliedBy;
  int? iV;

  Replies(
      {this.sId, this.post, this.comment, this.reply, this.repliedBy, this.iV});

  Replies.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    post = json['post'];
    comment = json['comment'];
    reply = json['reply'];
    repliedBy = json['repliedBy'] != null
        ? new RepliedBy.fromJson(json['repliedBy'])
        : null;
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['post'] = this.post;
    data['comment'] = this.comment;
    data['reply'] = this.reply;
    if (this.repliedBy != null) {
      data['repliedBy'] = this.repliedBy!.toJson();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class RepliedBy {
  String? sId;
  String? name;
  String? profileImageUrl;

  RepliedBy({this.sId, this.name, this.profileImageUrl});

  RepliedBy.fromJson(Map<String, dynamic> json) {
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