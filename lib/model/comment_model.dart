class Comments {
  String? sId;
  String? post;
  CommentedBy? commentedBy;
  String? createdAt;
  String? comment;
  int? iV;

  Comments(
      {this.sId,
      this.post,
      this.commentedBy,
      this.createdAt,
      this.comment,
      this.iV});

  Comments.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    post = json['post'];
    commentedBy = json['commentedBy'] != null
        ? CommentedBy.fromJson(json['commentedBy'])
        : null;
    createdAt = json['createdAt'];
    comment = json['comment'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['post'] = post;
    if (commentedBy != null) {
      data['commentedBy'] = commentedBy!.toJson();
    }
    data['createdAt'] = createdAt;
    data['comment'] = comment;
    data['__v'] = iV;
    return data;
  }
}

class CommentedBy {
  String? sId;
  String? name;
  String? profileImageUrl;

  CommentedBy({this.sId, this.name, this.profileImageUrl});

  CommentedBy.fromJson(Map<String, dynamic> json) {
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