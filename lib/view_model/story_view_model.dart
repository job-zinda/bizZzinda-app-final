import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/main.dart' as main_app;
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/model/myStory_model.dart';
import 'package:biz_zinda/model/story_model.dart';
import 'package:biz_zinda/model/story_views.dart';
import 'package:biz_zinda/utils/api_service.dart';
import 'package:biz_zinda/utils/api_url.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/view/home_section/home_pages/view/widgets/storyView_page.dart'; // For StoryViewerArgs
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StoryViewModel with ChangeNotifier {
  static const _storyCacheKey = 'story_cache';
  final Dio dio = Dio();
  int? storyCount;
  List<StoryViews> storeyViews = [];
  PagingController<int, StoryModel>? storyController;
  StoryModel storyModel = StoryModel();
  MyStoryModel myStoryModel = MyStoryModel();
  int currentPage = 0;
  String api = Api.storiesListUrl;

  initStoryPagination() async {
    if (storyController != null) return;

    storyController = PagingController(firstPageKey: 1);
    notifyListeners();

    // Load and display cache immediately
    final cachedStories = await _loadStoriesFromCache();
    if (cachedStories != null && cachedStories.isNotEmpty) {
      storyController!.appendLastPage(cachedStories);
    }

    // Add listener for future pagination (e.g., after a refresh)
    storyController!.addPageRequestListener((pageKey) {
      fetchStoryWithPagination(pageKey);
    });

    // Trigger a network refresh in the background after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      storyController?.refresh();
    });
  }

  bool isMyProfile = false;

  updateStoryModel(StoryModel story, BuildContext context) {
    isMyProfile = false;
    storyModel = story;
    final args = StoryViewerArgs(story: storyModel, isMyProfile: false);
    context.pushNamed(PPages.storyViewer, extra: args);
    updateStoryView(
        storyId: storyModel.sId.toString(),
        lastViewedMediaId: storyModel.media![0].sId.toString(),
        context: context);
    notifyListeners();
  }

  Uint8List? _selectedThumbanilFile;
  Uint8List? get selectedThumbanilFile => _selectedThumbanilFile;
  set selectedThumbanilFile(Uint8List? value) {
    _selectedThumbanilFile = value;
    notifyListeners();
  }

  Future<void> fetchStoryWithPagination(int page) async {
    if (currentPage != page) {
      currentPage = page;
      String api = Api.storiesListUrl;
      Response response = await ApiService().get('$api&pageNumber=$page');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['status']) {
          List<StoryModel> temp = (data['data']['stories'] as List)
              .map((e) => StoryModel.fromJson(e))
              .toList();

          if (page == 1) {
            _saveStoriesToCache(temp);
          }

          if (data['data']['hasNext']) {
            storyController!.appendPage(temp, page + 1);
          } else {
            storyController!.appendLastPage(temp);
          }
        } else {
          storyController!.appendLastPage([]);
        }
      } else {
        storyController!.appendLastPage([]);
      }
    }
  }

  Future<void> fetchMyStory(BuildContext context) async {
    String api = Api.getMyStory;
    Response response = await ApiService().get(api);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      print(response.data.toString());
      isMyProfile = true;
          print("dnsdnd-----$data");

      if (data['status']) {
        if (data['data']['story'] != null) {
          myStoryModel = MyStoryModel.fromJson(data['data']['story']);
          if (myStoryModel.media!.isNotEmpty) {
            fetchStoryViews(
                mediaId: myStoryModel.media![0].sId.toString(),
                storyId: myStoryModel.sId.toString());
          }
        }
      }
      final args = StoryViewerArgs(myStory: myStoryModel, isMyProfile: true);
      // Ensure main_app.navigatorKey.currentContext is not null and is mounted if coming from a background operation
      // However, fetchMyStory takes a BuildContext, so we should prefer using that if available and appropriate.
      // If this method can be called where 'context' is not the primary navigation context,
      // main_app.navigatorKey.currentContext might still be necessary. For now, assume 'context' is fine.
      if (main_app.navigatorKey.currentContext != null && main_app.navigatorKey.currentContext!.mounted) {
         main_app.navigatorKey.currentContext!.pushNamed(PPages.storyViewer, extra: args);
      } else {
        // Fallback or error handling if context is not available/mounted
        print("StoryViewModel: fetchMyStory - main_app.navigatorKey.currentContext is null or not mounted. Cannot navigate.");
      }
    }

    notifyListeners();
  }

  Future<void> fetchStoryViews(
      {required String mediaId, required String storyId}) async {
    String api = Api.getStoryViews;
    Map<String, dynamic> body = {'storyId': storyId, 'mediaId': mediaId};
    print("bodyyy----$mediaId----$storyId");
    Map<String, dynamic> headers = {
      'Authorization': "Bearer ${LoggedInUser.accessToken}",
    };

    Response response = await dio.request(
      api,
      data: body,
      options: Options(
          method: 'GET', headers: headers), // Explicitly set method to GET
    );
    // Response response = await dio.get(
    //   api,
    //   queryParameters: body,

    //   options: Options(headers: headers),
    // );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      print("story views ----${response.data.toString()}");

      if (data['status']) {
        storyCount = data["data"]["totalCount"];
        storeyViews = (data['data']['storyViews'] as List)
            .map(
              (e) => StoryViews.fromJson(e),
            )
            .toList();
      }
      notifyListeners();
    }
  }

  String? _selectedUrl;
  String? get selectedUrl => _selectedUrl;
  set selectedUrl(String? value) {
    _selectedUrl = value;
    notifyListeners();
  }

  String? _selectedThumbnailUrl;
  String? get selectedThumbnailUrl => _selectedThumbnailUrl;
  set selectedThumbnailUrl(String? value) {
    _selectedThumbnailUrl = value;
    notifyListeners();
  }

  String selectedMediaType = '';
  Future<void> createStory(
      {required String url,
      required String description,
      required bool archived,
      required BuildContext context}) async {
    Response response = await ApiService().post(Api.createStoryUrl, {
      'notificationType': 'other',
      'media': {'mediaType': selectedMediaType, 'content': url, 'duration': 0},
      'description': description,
      'caption': '',
      'archived': archived
    });
    print("story out pit ---$archived");
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      if (data['status']) {
        if (data.containsKey('message')) {
          Navigator.pop(context);
          EasyLoading.showSuccess(data['message']);
        }
      }
    }
  }

  Future<void> updateStoryView(
      {required String storyId,
      required String lastViewedMediaId,
      required BuildContext context}) async {
    Response response = await ApiService().post(Api.updateStoryView, {
      'storyId': storyId,
      'lastViewedMediaId': lastViewedMediaId,
    });
    print("update story----${response.data}");
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      // if (data['status']) {
      //   if (data.containsKey('message')) {
      //     Navigator.pop(context);
      //     // EasyLoading.showSuccess(data['message']);
      //   }
      // }
    } else {
      EasyLoading.showSuccess("something went wrong");
    }
  }

   removeStory(
      {required String storyId,
      required String mediaId,
      required BuildContext context}) async {
    String url = Api.removeStory;
    Response response = await ApiService().delete(
      "$url/$storyId/$mediaId",
    );
    print("delte story----${response.data}");
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      return true;
    } else {
      EasyLoading.showSuccess("something went wrong");
    }
  }

  Future<void> _saveStoriesToCache(List<StoryModel> stories) async {
    final prefs = await SharedPreferences.getInstance();
    final storyListJson = stories.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList(_storyCacheKey, storyListJson);
  }

  Future<List<StoryModel>?> _loadStoriesFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final storyListJson = prefs.getStringList(_storyCacheKey);
    if (storyListJson != null) {
      return storyListJson
          .map((s) => StoryModel.fromJson(jsonDecode(s)))
          .toList();
    }
    return null;
  }
}
