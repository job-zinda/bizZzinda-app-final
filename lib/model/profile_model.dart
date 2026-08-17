class ProfileModel {
  Location? location;
  String? sId;
  bool? getNotifications;
  String? name;
  String? email;
  String? countryCode;
  String? mobileNumber;
  String? profileImageUrl;
  String? gender;
  String? professionId;
  String? profession;
  String? bio;
  num? followersCount;
  num? projectsCount;
  num? rating;
  double? lat;
  double? lng;
  String? address;
  String? zipcode;
  bool? isVerified;
  String? accountType;
  List<String>? fcmTokens;
  String? createdAt;
  String? coverImage;
  String? district;
  String? state;
  String? referralCode;
  String? referredBy;
  int? coinBalance;

  bool? isFollowing;
  bool? isBlocked;
  List<String>? skills;
  bool? isShopOwner;
  String? contactNumber;
  String? whatsappNumber;


  ProfileModel(
      {this.location,
      this.sId,
      this.getNotifications,
      this.name,
      this.email,
      this.countryCode,
      this.mobileNumber,
      this.profileImageUrl,
      this.gender,
      this.professionId,
      this.profession,
      this.bio,
      this.followersCount,
      this.projectsCount,
      this.rating,
      this.lat,
      this.lng,
      this.address,
      this.zipcode,
      this.isVerified,
      this.accountType,
      this.fcmTokens,
      this.createdAt,
      this.coverImage,
      this.isFollowing,
      this.district,
      this.state,
      this.isBlocked,
      this.referralCode,
      this.coinBalance,
      this.referredBy,
      this.isShopOwner,
      this.contactNumber,
      this.whatsappNumber});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    sId = json['_id'];
    getNotifications = json['getNotifications'];
    name = json['name'];
    email = json['email'];
    countryCode = json['countryCode'];
    mobileNumber = json['mobileNumber'];
    profileImageUrl = json['profileImageUrl'];
    gender = json['gender'];
    professionId = json['professionId'];
    profession = json['profession'];
    bio = json['bio'];
    followersCount = json['followersCount'];
    projectsCount = json['projectsCount'];
    rating = json['rating'];
    lat = double.parse(json['lat'].toString());
    lng = double.parse(json['lng'].toString());
    address = json['address'];
    zipcode = json['zipcode'];
    isVerified = json['isVerified'];
    accountType = json['accountType'];
    createdAt = json['createdAt'];
    coverImage = json['coverImage'];
    isFollowing = json['isFollowing'];
    district = json['district'];
    state = json['state'];
    isBlocked = json['isBlocked'];
    isShopOwner = json['isShopOwner'];
    contactNumber = json['contactNumber'];
    whatsappNumber = json['whatsappNumber'];

    referralCode = json['referralCode'];
    referredBy = json['referredBy'];
    coinBalance = json['coinBalance'];
    skills = json['skills'] != null ? List<String>.from(json['skills']) : [];

  }
}

class Location {
  String? type;
  List<num>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<num>();
  }
}
