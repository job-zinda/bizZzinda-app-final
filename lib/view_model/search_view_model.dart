import 'package:flutter/material.dart';
import 'package:biz_zinda/model/profile_model.dart';
import '../utils/api_service.dart';
import '../utils/api_url.dart';

class SearchViewModel with ChangeNotifier {

  String _searchTag = "";
  String get searchTag => _searchTag;

  set searchTag(String value) {
    _searchTag = value;
    notifyListeners();
  }

  int _pageNumber = 1;
  bool _isFetching = false;
  bool get isLoading => _isFetching;

  int get pageNumber => _pageNumber;

  List<ProfileModel> searchList = [];

  Future<void> fetchSearchList({bool isNewSearch = false}) async {
    if (_isFetching) return;

    _isFetching = true;

    if (isNewSearch) {
      _pageNumber = 1;
      searchList.clear();
    }

    try {
      final url =
          '${Api.baseurl}/api/v1/store/get-stores?searchTag=${_searchTag.trim()}&pageNumber=$_pageNumber&pageSize=10';

      print("STORE URL => $url");

      final response = await ApiService().get(url);
      final data = response.data;

      print("STORE DATA => $data");

      if (data != null && data['status'] == true) {

        // 👉 profiles = stores
        final stores = data['data']?['profiles'];

        if (stores != null && stores is List) {

          List<ProfileModel> fetchedList =
          stores.map((e) => ProfileModel.fromJson(e)).toList();

          if (_pageNumber == 1) {
            searchList = fetchedList;
          } else {
            searchList.addAll(fetchedList);
          }

          _pageNumber++;
        } else {
          if (_pageNumber == 1) {
            searchList = [];
          }
        }
      }

      notifyListeners();

    } catch (e) {
      print("STORE ERROR => $e");
    } finally {
      _isFetching = false;
    }
  }
}
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:biz_zinda/model/profile_model.dart';
// import '../utils/api_service.dart';
// import '../utils/api_url.dart';
//
// class SearchViewModel with ChangeNotifier {
//   late PagingController<int, ProfileModel> searchController;
//   // int currentPage = 0;
//
//   // initSearchPagination() {
//   //   currentPage = 0;
//   //   searchController = PagingController(firstPageKey: 1);
//   //   searchController.addPageRequestListener((pageKey) {
//   //     fetchSearchList(pageKey);
//   //   });
//   // }
//
//   String _searchTag = "";
//   String get searchTag => _searchTag;
//   set searchTag(String value) {
//     _searchTag = value;
//     notifyListeners();
//   }
//
//   // Future<void> fetchSearchList(int page) async {
//   //   if (currentPage != page) {
//   //     currentPage = page;
//   //     String api = Api.searchUserListUrl;
//   //     Response response =
//   //         await ApiService().get('$api&pageNumber=$page&searchTag=$searchTag');
//   //     print("serach url--------$searchTag");
//   //     if (response.statusCode == 200) {
//   //       Map<String, dynamic> data = response.data;
//   //       print(response.data.toString());
//   //       if (data['status']) {
//   //         List<ProfileModel> temp = (data['data']['profiles'] as List)
//   //             .map((e) => ProfileModel.fromJson(e))
//   //             .toList();
//   //         if (data['data']['hasNext']) {
//   //           searchController.appendPage(temp, page + 1);
//   //         } else {
//   //           searchController.appendLastPage(temp);
//   //         }
//   //       } else {
//   //         searchController.appendLastPage([]);
//   //       }
//   //     } else {
//   //       searchController.appendLastPage([]);
//   //     }
//   //   }
//   // }
//
//   int _pageNumber = 1;
//   bool _isFetching = false; // Prevent multiple parallel fetches
//
//   int get pageNumber => _pageNumber;
//
//   set pageNumber(int value) {
//     _pageNumber = value;
//     notifyListeners();
//   }
//
//   List<ProfileModel> searchList = [];
//
//
//   Future<void> fetchSearchList({bool isNewSearch = false}) async {
//     if (_isFetching) return;
//
//     _isFetching = true;
//
//     if (isNewSearch) {
//       _pageNumber = 1;
//       searchList.clear();
//     }
//
//     try {
//       final response = await ApiService().get(
//         '${Api.baseurl}/api/v1/store/get-stores?pageNumber=$_pageNumber&pageSize=10',
//       );
//
//       final data = response.data;
//
//       print("STORE URL => ${Api.baseurl}/api/v1/store/get-stores?pageNumber=$_pageNumber&pageSize=10");
//       print("STORE DATA: $data");
//
//       if (data != null && data['status'] == true) {
//
//         final profiles = data['data']?['profiles'];
//
//         if (profiles != null && profiles is List) {
//
//           List<ProfileModel> fetchedList =
//           profiles.map((e) => ProfileModel.fromJson(e)).toList();
//
//           if (_pageNumber == 1) {
//             searchList = fetchedList;
//           } else {
//             searchList.addAll(fetchedList);
//           }
//
//           _pageNumber++;
//         } else {
//           if (_pageNumber == 1) {
//             searchList = [];
//           }
//         }
//       }
//
//       notifyListeners();
//
//     } catch (e) {
//       print("STORE ERROR: $e");
//     } finally {
//       _isFetching = false;
//     }
//   }
//
//   // Future<void> fetchSearchList({bool isNewSearch = false}) async {
//   //   if (_isFetching) return;
//   //
//   //   _isFetching = true;
//   //
//   //   if (isNewSearch) {
//   //     _pageNumber = 1;
//   //     searchList.clear();
//   //   }
//   //
//   //   try {
//   //     final response = await ApiService().get(
//   //       '${Api.searchUserListUrl}&pageNumber=$_pageNumber&searchTag=${_searchTag.trim()}',
//   //     );
//   //
//   //     final data = response.data;
//   //
//   //     print("URL => ${Api.searchUserListUrl}&pageNumber=$_pageNumber&searchTag=$_searchTag");
//   //     print("Fetched Data: $data");
//   //
//   //     if (data != null && data['status'] == true) {
//   //
//   //       final profiles = data['data']?['profiles'];
//   //
//   //       if (profiles != null && profiles is List) {
//   //
//   //         List<ProfileModel> fetchedList =
//   //         profiles.map((e) => ProfileModel.fromJson(e)).toList();
//   //
//   //         if (_pageNumber == 1) {
//   //           searchList = fetchedList;
//   //         } else {
//   //           searchList.addAll(fetchedList);
//   //         }
//   //
//   //         _pageNumber++;
//   //       } else {
//   //         // If profiles null
//   //         if (_pageNumber == 1) {
//   //           searchList = [];
//   //         }
//   //       }
//   //     }
//   //
//   //     notifyListeners();
//   //
//   //   } catch (e) {
//   //     print("Error fetching search list: $e");
//   //   } finally {
//   //     _isFetching = false;
//   //   }
//   // }
//
//
// }