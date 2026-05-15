import 'package:shared_preferences/shared_preferences.dart';

class LoggedInUser {
  static const _prefix = 'bizzzinda_'; // BizZinda-only keys

  static String? id;
  static String? name;
  static String? email;
  static String? countryCode;
  static String? phoneNumber;
  static String? profilePic;
  static String? coverImage;
  static String? accessToken;
  static String? refreshToken;
  static double? lat;
  static double? long;
  static List<String>? skills;
  static String? referralCode;
  static bool lastLoginWasEmailOtp = false;

  // ------------------ Constructors ------------------

  /// Login constructor
  LoggedInUser.login(Map<String, dynamic> json) {
    id = json['user']['_id'];
    name = json['user']['name'];
    email = json['user']['email'];
    countryCode = json['user']['countryCode'];
    phoneNumber = json['user']['phoneNumber'];
    profilePic = json['user']['profileImageUrl'];
    coverImage = json['user']['coverImage'];
    skills = List<String>.from(json['user']['skills'] ?? []);
    referralCode = json['user']['referralCode'] ?? '';
    accessToken = json['tokens']['access']['token'];
    refreshToken = json['tokens']['refresh']['token'];
    lat = double.tryParse(json['user']['location']["coordinates"][0].toString() ?? '0');
    long = double.tryParse(json['user']['location']["coordinates"][1].toString() ?? '0');

    storeUserLocally();
  }

  /// Profile constructor
  LoggedInUser.profile(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    countryCode = json['countryCode'];
    phoneNumber = json['mobileNumber'];
    profilePic = json['profileImageUrl'];
    coverImage = json['coverImage'];
    skills = List<String>.from(json['skills'] ?? []);
    referralCode = json['referralCode'] ?? '';
    lat = double.tryParse(json['location']?["coordinates"]?[0].toString() ?? '0');
    long = double.tryParse(json['location']?["coordinates"]?[1].toString() ?? '0');

    storeUserLocally();
  }

  /// Token update constructor
  LoggedInUser.tokenUpdate(Map<String, dynamic> json) {
    accessToken = json['access']['token'];
    refreshToken = json['refresh']['token'];
    storeUserLocally();
  }

  // ------------------ Shared Preferences ------------------

  /// Store all data locally biz_zinda-safe
  static void storeUserLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_prefix}id', id ?? '');
    await prefs.setString('${_prefix}name', name ?? '');
    await prefs.setString('${_prefix}email', email ?? '');
    await prefs.setString('${_prefix}countryCode', countryCode ?? '');
    await prefs.setString('${_prefix}phoneNumber', phoneNumber ?? '');
    await prefs.setString('${_prefix}profilePic', profilePic ?? '');
    await prefs.setString('${_prefix}coverImage', coverImage ?? '');
    await prefs.setStringList('${_prefix}skills', skills ?? []);
    await prefs.setString('${_prefix}referralCode', referralCode ?? '');
    await prefs.setString('${_prefix}accessToken', accessToken ?? '');
    await prefs.setString('${_prefix}refreshToken', refreshToken ?? '');
    await prefs.setBool('${_prefix}lastLoginWasEmailOtp', lastLoginWasEmailOtp);
    if (lat != null && long != null) {
      await prefs.setDouble('${_prefix}lat', lat!);
      await prefs.setDouble('${_prefix}long', long!);
    }
  }

  /// Get user details from SharedPreferences
  static Future<void> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString('${_prefix}id');
    name = prefs.getString('${_prefix}name');
    email = prefs.getString('${_prefix}email');
    countryCode = prefs.getString('${_prefix}countryCode');
    phoneNumber = prefs.getString('${_prefix}phoneNumber');
    profilePic = prefs.getString('${_prefix}profilePic');
    coverImage = prefs.getString('${_prefix}coverImage');
    skills = prefs.getStringList('${_prefix}skills');
    referralCode = prefs.getString('${_prefix}referralCode');
    accessToken = prefs.getString('${_prefix}accessToken');
    refreshToken = prefs.getString('${_prefix}refreshToken');
    lastLoginWasEmailOtp = prefs.getBool('${_prefix}lastLoginWasEmailOtp') ?? false;
    lat = prefs.getDouble('${_prefix}lat');
    long = prefs.getDouble('${_prefix}long');
  }

  /// Clear all biz_zinda data
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = null;
    refreshToken = null;
    lastLoginWasEmailOtp = false;
    id = null;
    name = null;
    email = null;
    countryCode = null;
    phoneNumber = null;
    profilePic = null;
    coverImage = null;
    skills = null;
    referralCode = null;
    lat = null;
    long = null;

    final keys = [
      'id','name','email','countryCode','phoneNumber','profilePic','coverImage',
      'skills','referralCode','accessToken','refreshToken','lastLoginWasEmailOtp','lat','long'
    ];
    for (var key in keys) {
      await prefs.remove('${_prefix}$key');
    }
  }

  // ------------------ Helper Methods ------------------

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('${_prefix}accessToken');
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('${_prefix}refreshToken');
  }

  static Future<Map<String, String>> getAuthorizationHeader() async {
    final token = await getAccessToken();
    return {'Authorization': token != null ? 'Bearer $token' : ''};
  }

  static Future<bool> isTokenEmpty() async {
    final token = await getAccessToken();
    final refresh = await getRefreshToken();
    return token == null || refresh == null;
  }
}

// import 'package:shared_preferences/shared_preferences.dart';
//
// class LoggedInUser {
//   static String? id;
//   static String? name;
//   static String? email;
//   static String? countryCode;
//   static String? phoneNumber;
//   static String? profilePic;
//   static String? coverImage;
//   static String? accessToken;
//   static String? refreshToken;
//   static double? lat;
//   static double? long;
//   static List<String>? skills;
//   static String? referralCode;
//   static Map<String, dynamic>? userData;
//   static bool lastLoginWasEmailOtp = false;
//
//
//
//   LoggedInUser.login(Map<String, dynamic> json) {
//     id = json['user']['_id'];
//     name = json['user']['name'];
//     email = json['user']['email'];
//     print("ha111");
//     countryCode = json['user']['countryCode'];
//     phoneNumber = json['user']['phoneNumber'];
//     profilePic = json['user']['profileImageUrl'];
//     coverImage = json['user']['coverImage'];
//     skills = List<String>.from(json['user']['skills'] ?? []);
//     print("ha122");
//     referralCode = json['user']['referralCode'] ?? '';
//     accessToken = json['tokens']['access']['token'];
//     refreshToken = json['tokens']['refresh']['token'];
//     print("ha14441");
//
//     lat = double.parse(json['user']['location']["coordinates"][0].toString());
//     long = double.parse(json['user']['location']["coordinates"][1].toString());
//     print("ha55");
//
//     storeUserLocally();
//   }
//   static void fromJson(Map<String, dynamic> json) {
//     if (json['user'] != null) {
//       id = json['user']['_id'];
//       name = json['user']['name'];
//       email = json['user']['email'];
//       countryCode = json['user']['countryCode'];
//       phoneNumber = json['user']['mobileNumber'];
//       profilePic = json['user']['profileImageUrl'];
//       coverImage = json['user']['coverImage'];
//       skills = List<String>.from(json['user']['skills'] ?? []);
//       referralCode = json['user']['referralCode'];
//       accessToken = json['tokens']['access']?['token'];
//       refreshToken = json['tokens']['refresh']?['token'];
//
//       if (json['user']['location']?['coordinates'] != null) {
//         lat = double.tryParse(
//             json['user']['location']['coordinates'][0].toString());
//         long = double.tryParse(
//             json['user']['location']['coordinates'][1].toString());
//       }
//
//       storeUserLocally();
//     }
//   }
//   LoggedInUser.profile(Map<String, dynamic> json) {
//     id = json['_id'];
//     name = json['name'];
//     email = json['email'];
//     countryCode = json['countryCode'];
//     phoneNumber = json['mobileNumber'];
//     profilePic = json['profileImageUrl'];
//     skills = List<String>.from(json['skills'] ?? []);
//     print("pro pic------$profilePic");
//     lat = double.parse(json['location']["coordinates"][0].toString());
//     long = double.parse(json['location']["coordinates"][1].toString());
//     storeUserLocally();
//   }
//   LoggedInUser.tokenUpdate(Map<String, dynamic> json) {
//     accessToken = json['access']['token'];
//     refreshToken = json['refresh']['token'];
//     storeUserLocally();
//   }
//
//   static void storeUserLocally() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('id', id ?? '');
//     prefs.setString('email', email ?? '');
//     prefs.setString('name', name ?? '');
//     prefs.setString('countryCode', countryCode ?? '');
//     prefs.setString('phoneNumber', phoneNumber ?? '');
//     prefs.setString('profilePic', profilePic ?? '');
//
//     prefs.setString('accessToken', accessToken ?? '');
//     prefs.setString('refreshToken', refreshToken ?? '');
//     prefs.setBool('lastLoginWasEmailOtp', lastLoginWasEmailOtp);
//   }
//
//   static Future<void> getUserDetails() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     id = prefs.getString('id');
//     email = prefs.getString('email');
//     name = prefs.getString('name');
//     countryCode = prefs.getString('countryCode');
//     phoneNumber = prefs.getString('phoneNumber');
//     profilePic = prefs.getString('profilePic');
//
//     accessToken = prefs.getString('accessToken');
//     refreshToken = prefs.getString('refreshToken');
//     lastLoginWasEmailOtp = prefs.getBool('lastLoginWasEmailOtp') ?? false;
//   }
//
//   static Future<void> clearUserData() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       refreshToken = null;
//       accessToken = null;
//       lastLoginWasEmailOtp = false;
//       var result = prefs.clear();
//       if (result == false) throw 'Unable to logout';
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
//
