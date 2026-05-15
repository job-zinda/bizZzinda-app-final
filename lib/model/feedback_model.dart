class FeedBacks {
  String? sId;
  String? ratee;
  Rater? rater;
  num? rating;
  String? review;
  String? createdAt;
  int? iV;

  FeedBacks(
      {this.sId,
      this.ratee,
      this.rater,
      this.rating,
      this.review,
      this.createdAt,
      this.iV});

  FeedBacks.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    ratee = json['ratee'];
    rater = json['rater'] != null ? new Rater.fromJson(json['rater']) : null;
    rating = json['rating'];
    review = json['review'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['ratee'] = this.ratee;
    if (this.rater != null) {
      data['rater'] = this.rater!.toJson();
    }
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Rater {
  String? sId;
  String? name;
  String? profileImageUrl;

  Rater({this.sId, this.name, this.profileImageUrl});

  Rater.fromJson(Map<String, dynamic> json) {
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