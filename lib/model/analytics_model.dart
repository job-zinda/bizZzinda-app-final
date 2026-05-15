class AnalyticsModel {
  num? totalFollowers;
  num? filteredFollowers;
  String? followersGrowth;
  num? unFollowCount;
  num? totalProfileViews;
  num? totalProjects;
  TotalFeedback? totalFeedback;

  AnalyticsModel(
      {this.totalFollowers,
      this.filteredFollowers,
      this.followersGrowth,
      this.unFollowCount,
      this.totalProfileViews,
      this.totalProjects,
      this.totalFeedback});

  AnalyticsModel.fromJson(Map<String, dynamic> json) {
    totalFollowers = json['totalFollowers'];
    filteredFollowers = json['filteredFollowers'];
    followersGrowth = json['followersGrowth'];
    unFollowCount = json['unFollowCount'];
    totalProfileViews = json['totalProfileViews'];
    totalProjects = json['totalProjects'];
    totalFeedback = json['totalFeedback'] != null
        ?  TotalFeedback.fromJson(json['totalFeedback'])
        : null;
  }

}

class TotalFeedback {
  num? averageRating;
  num? totalRatings;

  TotalFeedback({this.averageRating, this.totalRatings});

  TotalFeedback.fromJson(Map<String, dynamic> json) {
    averageRating = json['averageRating'];
    totalRatings = json['totalRatings'];
  }


}
