import 'dart:developer';
import 'dart:io';
import 'package:biz_zinda/view_model/file_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/main.dart' as main_app;
import 'package:biz_zinda/model/feedback_model.dart';
import 'package:biz_zinda/model/followers_model.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/model/notification_model.dart';
import 'package:biz_zinda/model/profession_model.dart';
import 'package:biz_zinda/model/profile_model.dart';
import 'package:biz_zinda/utils/api_service.dart';
import 'package:biz_zinda/utils/api_url.dart';
import 'package:biz_zinda/view/wrapper/view_model/view_model.dart';
import 'package:biz_zinda/view_model/location_view_model.dart';
import 'package:biz_zinda/view_model/post_view_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../view/login_section/login_welcome_screen/view/ui.dart';
import 'package:biz_zinda/model/product_model.dart';
import 'package:biz_zinda/model/service_model.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';

class ProfileViewModel with ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController skillController = TextEditingController();



  List<String> skills = [];


  String? selectedProfession;
  String? selectedProfessionId;
  String selectedGender = "Male";
  List<ProfessionModel> professionList = [];
  ProfileModel? profileModel;
  List<String> stateList = [];
  // String? selectedState;
  bool isLoadingMore = false;
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMoreData = true;
  Future<void> fetchProfile() async {
    EasyLoading.show(status: 'Loading Profile...');
    try {
      Response response = await ApiService().get(Api.profileDetailsUrl);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['status']) {
          profileModel = ProfileModel.fromJson(data['data']['profileDetails']);
          LoggedInUser.profile(data['data']['profileDetails']);
          skills = profileModel!.skills ?? [];
          print(profileModel!.skills);



          // Update controllers after successfully fetching data
          nameController.text = profileModel!.name ?? '';
          selectedProfession = profileModel!.profession ?? "";
          selectedProfessionId = profileModel!.professionId ?? "";
          phoneController.text = profileModel!.mobileNumber ?? '';
          bioController.text = profileModel!.bio ?? '';
          emailController.text = profileModel!.email ?? '';
          selectedGender = profileModel!.gender ?? "";
          addressController.text = profileModel!.address ?? '';
          cityController.text = profileModel!.district ?? '';

          // Immediately dismiss loading after profile data is parsed so UI is responsive.
          EasyLoading.dismiss();
          stateController.text = profileModel!.state ?? "";

          if (profileModel!.lat == 0 && profileModel!.lng == 0) {
            Position? position;
            try {
              LocationPermission permission = await Geolocator.checkPermission();
              if (permission == LocationPermission.denied) {
                permission = await Geolocator.requestPermission();
              }

              if (permission == LocationPermission.denied ||
                  permission == LocationPermission.deniedForever) {
                debugPrint('[fetchProfile] Location permission denied. Using fallback coordinates.');
              } else {
                position = await Geolocator.getCurrentPosition(
                  forceAndroidLocationManager: true,
                  desiredAccuracy: LocationAccuracy.medium,
                );
              }
            } catch (e) {
              debugPrint('[fetchProfile] Error getting location: $e');
            }

            if (position != null) {
              profileModel!.lat = position.latitude;
              profileModel!.lng = position.longitude;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
      // Optionally show an error message
      // EasyLoading.showError('Failed to load profile.');
    } finally {
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  updateState(String val) {
    stateController.text = val;
    notifyListeners();
  }

  Future<void> fetchProfession() async {
    EasyLoading.show(status: 'Loading Professions...');
    try {
      Response response = await ApiService()
          .get('${Api.getProfession}?pageNumber=1&pageSize=100&searchTag=');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['status']) {
          professionList = (data['data']['categories'] as List)
              .map(
                (e) => ProfessionModel.fromJson(e),
              )
              .toList();
        }
      }
    } catch (e) {
      print('Error fetching professions: $e');
      EasyLoading.showError('Failed to load professions.');
    } finally {
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  Future<void> updateProfileImage({required String url}) async {
    EasyLoading.show(status: 'Updating...');
    try {
      Response response =
          await ApiService().put(Api.updateProfileImage, {'profileImageUrl': url});

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['status']) {
          if (data.containsKey('message')) {
            EasyLoading.showSuccess(data['message']);
            LoggedInUser.profile(data['data']['profileDetails']);
            await fetchProfile(); // This already calls notifyListeners
          }
        } else {
          EasyLoading.showError(data['message'] ?? 'Failed to update image.');
        }
      } else {
        EasyLoading.showError('Failed to update image.');
      }
    } catch (e) {
      print('Error updating profile image: $e');
      EasyLoading.showError('An error occurred.');
    } finally {
      EasyLoading.dismiss();
    }
  }
  Future<void> updateNormalProfile({
    required String name,
    required String email,
    required List<String> skills,
    required BuildContext context,
  }) async {
    EasyLoading.show(status: 'Updating Profile...');

    try {
      Map body = {
        'name': name,
        'email': email,
        'skills': skills,
      };

      Response response = await ApiService().put(Api.updateProfile, body);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;

        if (data['status']) {

          LoggedInUser.profile(data['data']['profileDetails']);
          LoggedInUser.skills = skills;
          LoggedInUser.storeUserLocally();

          EasyLoading.dismiss();

          if (!context.mounted) return;

          context.goNamed(PPages.profileScreen);

          // Future.microtask(() {
          //   EasyLoading.showSuccess(data['message']);
          // });

        } else {
          EasyLoading.showError(data['message']);
        }
      }
    } catch (e) {
      print(e);
      EasyLoading.showError('An error occurred');
    }
  }

  // Future<void> updateNormalProfile(
  //     {required String name,
  //     required String email,
  //       required List<String> skills,
  //
  //     required BuildContext context}) async {
  //   EasyLoading.show(status: 'Updating Profile...');
  //   try {
  //     Map body = {
  //       'name': name,
  //       'email': email,
  //       'skills': skills,
  //     };
  //     Response response = await ApiService().put(Api.updateProfile, body);
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> data = response.data;
  //       if (data['status']) {
  //         if (data.containsKey('message')) {
  //           EasyLoading.showSuccess(data['message']);
  //           LoggedInUser.profile(data['data']['profileDetails']);
  //           LoggedInUser.skills = skills;
  //           LoggedInUser.storeUserLocally();
  //           await fetchProfile(); // This calls notifyListeners
  //           // if (context.mounted) Navigator.pop(context);
  //           // notifyListeners();
  //
  //
  //
  //         }
  //       } else {
  //         EasyLoading.showError(data['message'] ?? 'Failed to update profile.');
  //       }
  //     } else {
  //       EasyLoading.showError('Failed to update profile.');
  //     }
  //   } catch (e) {
  //     print('Error updating normal profile: $e');
  //     EasyLoading.showError('An error occurred.');
  //   } finally {
  //     EasyLoading.dismiss();
  //   }
  // }

  updateSelectedProfession(String professionId) {
    selectedProfessionId = professionId;
    if (professionList.any((p) => p.sId == professionId)) {
      selectedProfession = professionList.firstWhere((p) => p.sId == professionId).name;
    }
    notifyListeners();
  }

  Future<void> updateFreelancerProfile({required BuildContext context}) async {
    EasyLoading.show(status: 'Updating Profile...');
    try {
      Map body = {
        'name': nameController.text,
        'email': emailController.text,
        "gender": selectedGender,
        "lat": context.read<LocationViewModel>().latitude,
        "profession": selectedProfession,
        "lng": context.read<LocationViewModel>().longitude,
        "bio": bioController.text,
        "address": addressController.text,
        "zipcode": zipCodeController.text,
        "professionId": selectedProfessionId,
        'state': stateController.text,
        'district': cityController.text,
        'skills': skills,
      };
      Response response = await ApiService().put(Api.updateProfile, body);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['status']) {
          if (data.containsKey('message')) {
            LoggedInUser.profile(data['data']['profileDetails']);
            LoggedInUser.skills = skills;
            LoggedInUser.storeUserLocally();
            // EasyLoading.showSuccess(data['message']);

            // if (context.mounted) {
            //   Navigator.pop(context);
            //   Navigator.pop(context);
            //   context
            //       .read<WrapperViewModel>()
            //       .updatePageView(WrapperViewStatus.profile);
            // }
            await Future.delayed(const Duration(milliseconds: 300));

            if (!context.mounted) return;

            context.go('/');

            // Future.microtask(() {
            //   notifyListeners();
            // });
            // Manual notify since we are not calling fetchProfile
          }
        } else {
          EasyLoading.showError(data['message'] ?? 'Failed to update profile.');
        }
      } else {
        EasyLoading.showError('Failed to update profile.');
      }
    } catch (e) {
      print('Error updating freelancer profile: $e');
      EasyLoading.showError('An error occurred.');
    } finally {
      EasyLoading.dismiss();
    }
  }
  void addSkillFromText(String? text) {
    if (text == null) return;

    final skill = text.replaceAll(',', '').trim();
    if (skill.isEmpty) return;

    skills.add(skill);
    skillController.clear();
    notifyListeners();
  }

  void removeSkill(String skill) {
    skills.remove(skill);
    notifyListeners();
  }


  Future<void> updateCoverImage({required String url}) async {
    EasyLoading.show(status: 'Updating Cover Image...');
    try {
      Response response =
          await ApiService().put(Api.updateCoverImage, {'coverImage': url});

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['status']) {
          if (data.containsKey('message')) {
            EasyLoading.showSuccess(data['message']);
            await fetchProfile(); // This calls notifyListeners
          }
        } else {
          EasyLoading.showError(
              data['message'] ?? 'Failed to update cover image.');
        }
      } else {
        EasyLoading.showError('Failed to update cover image.');
      }
    } catch (e) {
      print('Error updating cover image: $e');
      EasyLoading.showError('An error occurred.');
    } finally {
      EasyLoading.dismiss();
    }
  }
  userLogout(BuildContext context) async {

    /// 🔥 DEBUG TOKEN
    print("REFRESH TOKEN: ${LoggedInUser.refreshToken}");

    try {
      Map body = {"refreshToken": LoggedInUser.refreshToken};

      final response = await ApiService().post(Api.userLogout, body);
      print("logout----${response.data}");
    } catch (e) {
      print("Logout API error: $e");
    }

    /// ✅ ALWAYS CLEAR
    LoggedInUser.clearUserData();

    /// ✅ FORCE NAVIGATION
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => LoginWelcomeScreenUi(),
      ),
          (route) => false,
    );
  }

  // userLogout(BuildContext context) async {
  //   Map body = {"refreshToken": LoggedInUser.refreshToken};
  //
  //   Response response = await ApiService().post(Api.userLogout, body);
  //   print("logout----${response.data}");
  //
  //   if (response.data['status']) {
  //     LoggedInUser.clearUserData();
  //     context.goNamed(PPages.loginWelcomeScreenUi);
  //   }
  // }

  deleteProfile(BuildContext context) async {
    EasyLoading.show(status: 'Deleting Profile...');
    try {
      Response response = await ApiService().patch(
        Api.deleteProfile,
      );
      if (response.data['status']) {
        EasyLoading.showSuccess(response.data['message']);
        LoggedInUser.clearUserData();
        if (context.mounted) {
          context.goNamed(PPages.loginWelcomeScreenUi);
        }
      } else {
        EasyLoading.showError(response.data['message'] ?? 'Failed to delete profile.');
      }
    } catch (e) {
      print('Error deleting profile: $e');
      EasyLoading.showError('An error occurred.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> addProfileRating(
      {required String rating,
      required String review,
      required String profileId,
      required BuildContext context}) async {
    EasyLoading.show(status: 'Submitting Rating...');
    try {
      Map body = {'rating': rating, 'review': review, 'profileId': profileId};
      Response response = await ApiService().post(Api.profileRating, body);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['status']) {
          if (data.containsKey('message')) {
            EasyLoading.showSuccess(data['message']);
            context
                .read<PostViewModel>()
                .fetchOtherUserProfileDetails(userID: profileId);
            notifyListeners();
          }
        } else {
          EasyLoading.showError(data['message'] ?? 'Failed to submit rating.');
        }
      } else {
        EasyLoading.showError('Failed to submit rating.');
      }
    } catch (e) {
      print('Error adding profile rating: $e');
      EasyLoading.showError('An error occurred.');
    } finally {
      EasyLoading.dismiss();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  String _searchKeyword = "";
  String get searchKeyword => _searchKeyword;
  set searchKeyword(String value) {
    _searchKeyword = value;
    notifyListeners();
  }

  late PagingController<int, Followers> followersController;
  // int currentPage = 0;
  initFollowersPagination({required String id}) {
    currentPage = 0;
    followersController = PagingController(firstPageKey: 1);
    followersController.addPageRequestListener((pageKey) {
      fetchFollowerWithPagination(pageKey, userID: id);
    });
  }

  Future<void> fetchFollowerWithPagination(int page, {String? userID}) async {
    if (currentPage != page) {
      currentPage = page;
      // if (searchKeyword == "") {
      //   searchKeyword = "";
      // }
      String url =
          "${Api.listAllFollowers}?profileId=$userID&pageNumber=$currentPage&pageSize=$pageSize&searchTag=$searchKeyword";

      Response response = await ApiService().get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['status']) {
          List<Followers> temp = (data['data']['followers'] as List)
              .map((e) => Followers.fromJson(e))
              .toList();
          if (data['data']['hasNext']) {
            followersController.appendPage(temp, page + 1);
          } else {
            followersController.appendLastPage(temp);
          }
        } else {
          followersController.appendLastPage([]);
        }
      } else {
        followersController.appendLastPage([]);
      }
    }
  }

  late PagingController<int, FeedBacks> feedbackController;
  // int currentPage = 0;
  initFeedbackPagination({required String id}) {
    currentPage = 0;
    feedbackController = PagingController(firstPageKey: 1);
    feedbackController.addPageRequestListener((pageKey) {
      fetchFeedbackPagination(pageKey, userID: id);
    });
  }

  Future<void> fetchFeedbackPagination(int page, {String? userID}) async {
    if (currentPage != page) {
      currentPage = page;

      String url =
          "${Api.listAllFeedbacks}?profileId=$userID&pageNumber=$currentPage&pageSize=$pageSize";

      Response response = await ApiService().get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['status']) {
          List<FeedBacks> temp = (data['data']['feedBacks'] as List)
              .map((e) => FeedBacks.fromJson(e))
              .toList();
          if (data['data']['hasNext']) {
            feedbackController.appendPage(temp, page + 1);
          } else {
            feedbackController.appendLastPage(temp);
          }
        } else {
          feedbackController.appendLastPage([]);
        }
      } else {
        feedbackController.appendLastPage([]);
      }
    }
  }
}
