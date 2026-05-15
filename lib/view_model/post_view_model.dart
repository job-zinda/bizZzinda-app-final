import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:biz_zinda/model/banners_model.dart';
import 'package:biz_zinda/model/profile_model.dart';
import 'package:biz_zinda/utils/api_url.dart';
import '../model/post_model.dart';
import '../utils/api_service.dart';

class PostViewModel with ChangeNotifier {
  // late PagingController<int, PostModel> postController;

  late PagingController<int, dynamic> postController =
  PagingController(firstPageKey: 0);
  Future<void> refreshPosts() async {
    currentPage = 0;
    postController.refresh();
    // initPostPagination();
  }

  int currentPage = 0;
  final List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;
  PostViewModel() {
    initPostPagination();
    initSelfPostPagination(); // Ensure initialization
  }
  initPostPagination() async {
    currentPage = 0;
    postController = PagingController(firstPageKey: 1);
    notifyListeners();

    // Add listener for pagination
    postController.addPageRequestListener((pageKey) {
      fetchPostWithPagination(pageKey);
    });
  }

  late PagingController<int, PostModel> selfPostController;
  int currentPageForSelfPost = 0;

  initSelfPostPagination() {
    currentPageForSelfPost = 0;
    selfPostController = PagingController(firstPageKey: 1);
    selfPostController.addPageRequestListener((pageKey) {
      fetchSelfPostWithPagination(pageKey);
    });
  }

  bool _isForYou = true;
  bool get isForYou => _isForYou;
  set isForYou(bool value) {
    _isForYou = value;
    notifyListeners();
  }

  Future<void> fetchPostWithPagination(int page) async {
    if (currentPage != page) {
      currentPage = page;
      String api =
      isForYou ? Api.suggestedPostsListUrl : Api.followingsPostsListUrl;

      Response response = await ApiService().get('$api&pageNumber=$page');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['status']) {
          print("temp----$data");

          // Parse posts
          List<PostModel> posts = (data['data']['posts'] as List)
              .map((e) => PostModel.fromJson(e))
              .toList();



          // Fetch banners only on the first page to avoid unnecessary
          // network calls on subsequent paginated requests. This
          // significantly reduces payload size and improves initial
          // rendering time on low-end devices or slow networks.
          List<Banners> banners = [];
          if (page == 1) {
            final bannerRes = await ApiService().get(Api.listBanners);
            banners = (bannerRes.data['data']['banners'] as List?)
                ?.map((e) => Banners.fromJson(e))
                .toList() ??
                [];
          }

          // Merge posts and banners (if any) based on indices
          List<dynamic> combinedList = _mergePostsAndBanners(posts, banners);

          if (data['data']['hasNext']) {
            postController.appendPage(combinedList, page + 1);
          } else {
            postController.appendLastPage(combinedList);
          }
        } else {
          postController.appendLastPage([]);
        }
      } else {
        postController.appendLastPage([]);
      }
    }
  }

  // List<dynamic> _mergePostsAndBanners(
  //     List<PostModel> posts, List<Banners> banners) {
  //   List<dynamic> combinedList = [];
  //   int postIndex = 0;

  //   // Sort banners by their index to ensure correct order
  //   banners.sort((a, b) => (a.indexNumber ?? 0).compareTo(b.indexNumber ?? 0));

  //   for (var banner in banners) {
  //     int bannerPosition = banner.indexNumber ?? 0;

  //     // Add posts up to the banner position
  //     while (postIndex < posts.length && combinedList.length < bannerPosition) {
  //       combinedList.add(posts[postIndex]);
  //       postIndex++;
  //     }

  //     // Add the banner at the specified position
  //     combinedList.add(banner);
  //   }

  //   // Add any remaining posts
  //   while (postIndex < posts.length) {
  //     combinedList.add(posts[postIndex]);
  //     postIndex++;
  //   }

  //   return combinedList;
  // }

  List<dynamic> _mergePostsAndBanners(
      List<PostModel> posts, List<Banners> banners) {

    List<dynamic> combined = [];

    Banners? middleBanner;
    Banners? bottomBanner;

    for (var b in banners) {
      if (b.position == "middle") {
        middleBanner = b;
      }

      if (b.position == "bottom") {
        bottomBanner = b;
      }
    }

    for (int i = 0; i < posts.length; i++) {

      combined.add(posts[i]);

      /// 🔹 2 posts kazhinju middle banner
      if (i == 1 && middleBanner != null) {
        combined.add(middleBanner);
      }
    }

    /// 🔻 bottom banner last
    if (bottomBanner != null) {
      combined.add(bottomBanner);
    }

    return combined;
  }

  // Future<void> fetchPostWithPagination(int page) async {
  //   if (currentPage != page) {
  //     currentPage = page;
  //     String api =
  //         isForYou ? Api.suggestedPostsListUrl : Api.followingsPostsListUrl;

  //     Response response = await ApiService().get('$api&pageNumber=$page');

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> data = response.data;
  //       if (data['status']) {
  //         print("temp----$data");

  //         List<PostModel> temp = (data['data']['posts'] as List)
  //             .map((e) => PostModel.fromJson(e))
  //             .toList();
  //         if (data['data']['hasNext']) {
  //           postController.appendPage(temp, page + 1);
  //         } else {
  //           postController.appendLastPage(temp);
  //         }
  //       } else {
  //         postController.appendLastPage([]);
  //       }
  //     } else {
  //       postController.appendLastPage([]);
  //     }
  //   }
  // }

  bool isBottomshetopen = false;
  updateBottomsheetoen(bool value) {
    isBottomshetopen = value;
    print("bottm----$isBottomshetopen");
    notifyListeners();
  }

  String? _selectedUrl;
  String? get selectedUrl => _selectedUrl;
  set selectedUrl(String? value) {
    _selectedUrl = value;
    notifyListeners();
  }

  Uint8List? _selectedThumbanilFile;
  Uint8List? get selectedThumbanilFile => _selectedThumbanilFile;
  set selectedThumbanilFile(Uint8List? value) {
    _selectedThumbanilFile = value;
    notifyListeners();
  }

  String? _selectedThumbnailUrl;
  String? get selectedThumbnailUrl => _selectedThumbnailUrl;
  set selectedThumbnailUrl(String? value) {
    _selectedThumbnailUrl = value;
    notifyListeners();
  }

  String selectedMediaType = '';
//   Future<void> createPost({
//     required String description,
//     required String sharedWith,
//     required BuildContext context,
//   }) async {
//     EasyLoading.show();

//     Map body = {
//       'bio': description,
//       'mediaType': selectedMediaType,
//       'thumbnail': selectedThumbnailUrl,
//       'mediaUrl': selectedUrl,
//       'sharedWith': sharedWith == 'Anyone' ? 'all' : 'followers'
//     };

//     print("create post body-----$body");

//     try {
//       Response response = await ApiService().post(Api.createPostUrl, body);
//       EasyLoading.dismiss();

//       if (response.statusCode == 200) {
//         Map<String, dynamic> data = response.data;
//         print("create post response---$data");
// // _posts.clear();
//         if (data['status']) {
//           if (data.containsKey('message')) {
//             EasyLoading.showSuccess(data['message']);

//             PostModel newPost = PostModel.fromJson(data['data']['post']);

//             // _posts.add(newPost);
//             if (!_posts.any((post) => post.sId == newPost.sId)) {
//               _posts.add(newPost);
//               notifyListeners();
//             }
//             notifyListeners();
//             selfPostController.appendPage([newPost], currentPage + 1);

//             isForYou = true;
//             currentPage = 0;
//             postController.refresh();
//             notifyListeners();
//           }
//         }
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       EasyLoading.dismiss();
//       print('Error creating post: $e');
//       EasyLoading.showError('Failed to create post');
//     }
//   }
  Future<void> createPost({
    required String description,
    required String sharedWith,
    required BuildContext context,
  }) async {
    EasyLoading.show();

    Map body = {
      'bio': description,
      'mediaType': selectedMediaType,
      'thumbnail': selectedThumbnailUrl,
      'mediaUrl': selectedUrl,
      'sharedWith': sharedWith == 'Anyone' ? 'all' : 'followers'
    };

    print("create post body-----$body");

    try {
      Response response = await ApiService().post(Api.createPostUrl, body);
      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        print("create post response---$data");

        if (data['status']) {
          if (data.containsKey('message')) {
            EasyLoading.showSuccess(data['message']);

            PostModel newPost = PostModel.fromJson(data['data']['post']);

            // Avoid adding duplicate posts
            if (!_posts.any((post) => post.sId == newPost.sId)) {
              _posts.add(newPost); // Add new post to the list
              notifyListeners(); // Notify listeners for UI update
            }

            // Append the new post to pagination
            selfPostController
                .appendPage([newPost], currentPageForSelfPost + 1);

            // Reset pagination to the first page
            currentPageForSelfPost = 0;
            selfPostController.refresh();

            isForYou = true;
            currentPage = 0;
            postController.refresh(); // Refresh the main feed
            notifyListeners();
          }
        }
      }
      Navigator.pop(context);
    } catch (e) {
      EasyLoading.dismiss();
      print('Error creating post: $e');
      EasyLoading.showError('Failed to create post');
    }
  }

  Future<void> fetchSelfPostWithPagination(int page) async {
    // The PagingController handles its own loading indicators, so a global EasyLoading
    // call is not needed here and can cause conflicting spinners.
    try {
      if (currentPageForSelfPost != page) {
        currentPageForSelfPost = page;
        String api = Api.loginUserPostsListUrl;
        Response response = await ApiService().get('$api&pageNumber=$page');
        if (response.statusCode == 200) {
          Map<String, dynamic> data = response.data;

          if (data['status']) {
            List<PostModel> temp = (data['data']['posts'] as List)
                .map((e) => PostModel.fromJson(e))
                .toList();

            if (data['data']['hasNext']) {
              selfPostController.appendPage(temp, page + 1);
            } else {
              selfPostController.appendLastPage(temp);
            }
          } else {
            selfPostController.error = data['message'] ?? 'Failed to load posts';
          }
        } else {
          selfPostController.error = 'Failed to load posts';
        }
      }
    } catch (e) {
      print('Error fetching self posts: $e');
      selfPostController.error = e;
    }
  }

  bool _isFollowed = false;
  bool get isFollowed => _isFollowed;
  set isFollowed(bool value) {
    _isFollowed = value;
    notifyListeners();
  }

  ProfileModel? otherUser;

  PostModel? postDetails;

  String? otherUserProfileError;

  Future<bool> fetchOtherUserProfileDetails({required String userID}) async {
    print('[fetchOtherUserProfileDetails] called for userID: $userID');
    EasyLoading.show(status: 'Loading profile...');
    otherUserProfileError = null;
    try {
      final String url = '${Api.otherUserProfileDetailsUrl}/$userID';
      print('[fetchOtherUserProfileDetails] Request URL: $url');
      Response response = await ApiService().get(url);
      print('[fetchOtherUserProfileDetails] HTTP ${response.statusCode}, response.data: ' + response.data.toString());

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['status']) {
          otherUser = ProfileModel.fromJson(data['data']['profileDetails']);
          isFollowed = otherUser?.isFollowing ?? false;
          visitProfile(userID: userID);
          notifyListeners();
          return true;
        } else {
          otherUserProfileError = data['message'] ?? 'Failed to load profile.';
          EasyLoading.showError(otherUserProfileError!);
          return false;
        }
      } else {
        otherUserProfileError = 'Failed to load profile.';
        EasyLoading.showError(otherUserProfileError!);
        return false;
      }
    } catch (e) {
      otherUserProfileError = 'Error: $e';
      print('[fetchOtherUserProfileDetails] Exception: $e');
      EasyLoading.showError('An error occurred.');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> visitProfile({required String userID}) async {
    try {
      await ApiService().post(Api.profileVisitUrl, {'profileId': userID});
    } catch (e) {
      print('Error tracking profile visit for $userID: $e');
    }
  }

  late PagingController<int, PostModel> otherUserPostController;
  int currentPageOtherUserPost = 0;

  initOtherUserPostPagination() {
    currentPageOtherUserPost = 0;
    otherUserPostController = PagingController(firstPageKey: 1);
    otherUserPostController.addPageRequestListener((pageKey) {
      fetchOtherUserPostWithPagination(pageKey);
    });
  }

  Future<void> fetchOtherUserPostWithPagination(int page) async {
    try {
      if (currentPageOtherUserPost != page) {
        currentPageOtherUserPost = page;
        String api = Api.otherUserPostsListUrl;
        Response response = await ApiService()
            .get('$api&pageNumber=$page&&profileId=${otherUser?.sId}');
        if (response.statusCode == 200) {
          Map<String, dynamic> data = response.data;
          if (data['status']) {
            List<PostModel> temp = (data['data']['posts'] as List)
                .map((e) => PostModel.fromJson(e))
                .toList();

            if (data['data']['hasNext']) {
              otherUserPostController.appendPage(temp, page + 1);
            } else {
              otherUserPostController.appendLastPage(temp);
            }
          } else {
            otherUserPostController.error = data['message'] ?? 'Failed to load posts.';
          }
        } else {
          otherUserPostController.error = 'Failed to load posts.';
        }
      }
    } catch(e) {
      otherUserPostController.error = e;
    }
  }

  Future<void> followUser({String? userID}) async {
    EasyLoading.show(status: 'Following...');
    try {
      Response response =
      await ApiService().post(Api.followUrl, {'profileId': otherUser?.sId});
      if (response.data['status']) {
        EasyLoading.showSuccess("Followed");
        if (userID != null) {
          currentPage = 0;
          postController.refresh();
        }
        await fetchOtherUserProfileDetails(userID: otherUser?.sId ?? "");
      } else {
        EasyLoading.showError(response.data['message'] ?? 'Failed to follow.');
      }
    } catch (e) {
      print('Error following user: $e');
      EasyLoading.showError('An error occurred.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> unFollowUser({String? userID}) async {
    EasyLoading.show(status: 'Unfollowing...');
    try {
      String? id = userID ?? otherUser?.sId;
      Response response =
      await ApiService().post(Api.unfollowUrl, {'profileId': id});
      if(response.data['status']) {
        EasyLoading.showSuccess("Unfollowed");
        if (userID != null) {
          currentPage = 0;
          postController.refresh();
        }
        await fetchOtherUserProfileDetails(userID: otherUser?.sId ?? "");
      } else {
        EasyLoading.showError(response.data['message'] ?? 'Failed to unfollow.');
      }
    } catch(e) {
      print('Error unfollowing user: $e');
      EasyLoading.showError('An error occurred.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> postLike({required String postID}) async {
    try {
      await ApiService().post(Api.postLikeUrl, {'postId': postID});
      await fetchPostDetails();
    } catch (e) {
      print('Error liking post: $e');
    }
  }

  Future<void> fetchPostDetails() async {
    EasyLoading.show();
    try {
      Response response =
      await ApiService().get('${Api.fetchPostDetails}?postId=${postDetails?.sId}');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['status']) {
          postDetails = PostModel.fromJson(data['data']['post']);
          notifyListeners();
          EasyLoading.dismiss();
        } else {
          EasyLoading.showError(data['message'] ?? 'Failed to load post.');
        }
      } else {
        // EasyLoading.showError('Failed to load post.');
      }
    } catch (e) {
      print('Error fetching post details: $e');
      EasyLoading.showError('An error occurred.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<List<ProfileModel>> getUsersForMap() async {
    EasyLoading.show(status: 'Loading users...');
    try {
      String api = Api.getNearestProfiles;
      Response response = await ApiService().get(api);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['status']) {
          List<ProfileModel> temp = (data['data']['users'] as List)
              .map((e) => ProfileModel.fromJson(e))
              .toList();
          return temp;
        }
      }
      return [];
    } catch (e) {
      print('Error getting users for map: $e');
      EasyLoading.showError('Failed to load users.');
      return [];
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> removePost(BuildContext context, String postId) async {
    EasyLoading.show(status: 'Deleting Post...');
    try {
      final response = await ApiService().delete('${Api.removePost}/$postId');
      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Post deleted successfully');
        postController.refresh();
        selfPostController.refresh();
      } else {
        EasyLoading.showError('Failed to delete post');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred while deleting the post.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> blockUser(BuildContext context, {required String id}) async {
    EasyLoading.show(status: 'Blocking User...');
    try {
      final response = await ApiService().post(Api.blockUser, {'userId': id});
      if (response.statusCode == 200 && response.data['status']) {
        EasyLoading.showSuccess('User blocked successfully');
        await fetchOtherUserProfileDetails(userID: id);
      } else {
        EasyLoading.showError(response.data['message'] ?? 'Failed to block user');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred while blocking the user.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> unblockUser(BuildContext context, {required String id}) async {
    EasyLoading.show(status: 'Unblocking User...');
    try {
      final response = await ApiService().post(Api.unblockUser, {'userId': id});
      if (response.statusCode == 200 && response.data['status']) {
        EasyLoading.showSuccess('User unblocked successfully');
        await fetchOtherUserProfileDetails(userID: id);
      } else {
        EasyLoading.showError(response.data['message'] ?? 'Failed to unblock user');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred while unblocking the user.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> reportProfile(
      {required String profileId, required BuildContext context}) async {
    EasyLoading.show();
    Map body = {'profileId': profileId, 'reason': ''};

    Response response = await ApiService().post(Api.reportProfile, body);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      print("report profil---$data");

      if (data['status']) {
        if (data.containsKey('message')) {
          Navigator.pop(context);
          EasyLoading.showSuccess(data['message']);
          isForYou = true;
          currentPage = 0;
          fetchPostWithPagination(1);
          postController.refresh();
        }
      }
    }
    EasyLoading.dismiss();
  }
}
