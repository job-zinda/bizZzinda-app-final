class Referrals {
  String? sId;
  bool? documentStatus;
  String? referralCode;
  String? referrer;
  ReferredUser? referredUser;
  int? referralCoins;
  String? claimStatus;
  String? createdAt;
  int? iV;

  Referrals(
      {this.sId,
      this.documentStatus,
      this.referralCode,
      this.referrer,
      this.referredUser,
      this.referralCoins,
      this.claimStatus,
      this.createdAt,
      this.iV});

  Referrals.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    documentStatus = json['documentStatus'];
    referralCode = json['referralCode'];
    referrer = json['referrer'];
    referredUser = json['referredUser'] != null
        ? ReferredUser.fromJson(json['referredUser'])
        : null;
    referralCoins = json['referralCoins'];
    claimStatus = json['claimStatus'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['documentStatus'] = documentStatus;
    data['referralCode'] = referralCode;
    data['referrer'] = referrer;
    if (referredUser != null) {
      data['referredUser'] = referredUser!.toJson();
    }
    data['referralCoins'] = referralCoins;
    data['claimStatus'] = claimStatus;
    data['createdAt'] = createdAt;
    data['__v'] = iV;
    return data;
  }
}

class ReferredUser {
  String? sId;
  String? name;
  String? email;
  String? profileImageUrl;
  String? referralCode;

  ReferredUser(
      {this.sId,
      this.name,
      this.email,
      this.profileImageUrl,
      this.referralCode});

  ReferredUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    profileImageUrl = json['profileImageUrl'];
    referralCode = json['referralCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['profileImageUrl'] = profileImageUrl;
    data['referralCode'] = referralCode;
    return data;
  }
}