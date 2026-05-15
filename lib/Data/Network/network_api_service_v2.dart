import 'dart:typed_data';
import 'package:dio/dio.dart' as dio;

import '../../model/logged_in_user.dart';
import '../../utils/api_url.dart';
import '../app_exceptions.dart';
import 'base_api_service.dart';


class NetworkApiServiceV2 implements BaseApiService {
  late dio.Dio adapter;
  // Constractor is used to assign needed headers and refresh token.
  NetworkApiServiceV2() {
    adapter = dio.Dio(dio.BaseOptions(
        baseUrl: AppUrl.baseurl,
        connectTimeout: const Duration(minutes: 6),
        receiveTimeout: const Duration(minutes: 60)));
    adapter.interceptors.add(dio.InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.contentType = 'application/json';
        // Lazily load tokens from storage if not already loaded
        if (LoggedInUser.accessToken == null) {
          await LoggedInUser.getUserDetails();
        }
        if (LoggedInUser.accessToken != null && LoggedInUser.accessToken!.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer ${LoggedInUser.accessToken}';
        }
        return handler.next(options);
      },
      onResponse: (respons, handler) async {
        if (respons.data["statusCode"] == 401) {
          var options = respons.requestOptions;
          await _refreshToken();
          // Retry the failed request with the new token
          options.headers['Authorization'] =
              'Bearer ${LoggedInUser.accessToken}';
          final response = await adapter.request(
            options.path,
            options: dio.Options(
              method: options.method,
              headers: options.headers,
            ),
            data: options.data,
            queryParameters: options.queryParameters,
          );
          return handler.resolve(response);
        } else {
          return handler.next(respons);
        }
      },
      onError: (dio.DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          var options = e.response!.requestOptions;
          await _refreshToken();
          // Retry the failed request with the new token
          options.headers['Authorization'] =
              'Bearer ${LoggedInUser.accessToken}';
          final response = await adapter.request(
            options.path,
            options: dio.Options(
              method: options.method,
              headers: options.headers,
            ),
            data: options.data,
            queryParameters: options.queryParameters,
          );
          return handler.resolve(response);
        } else {
          return handler.next(e);
        }
      },
    ));
  }
  Future<bool> _refreshToken() async {
    final refreshToken = LoggedInUser.refreshToken;
    final response = await adapter
        .post(AppUrl.refreshToken, data: {'refreshToken': refreshToken});
    if (response.statusCode == 200 && response.data['statusCode'] == 200) {
      LoggedInUser.accessToken =
          response.data['data']['tokens']['access']['token'];
      LoggedInUser.refreshToken =
          response.data['data']['tokens']['refresh']['token'];
      LoggedInUser.storeUserLocally();
      return true;
    } else {
      // refresh token is wrong
      LoggedInUser.clearUserData();
      return false;
    }
  }

  @override
  Future<Uint8List> fetchImage(String imageLink) {
    // TODO: implement fetchImage
    throw UnimplementedError();
  }

  @override
  Future formData(String endpoints,
      {String? domain,
      List<String> fileFields = const [],
      List<String?> filePaths = const [],
      Map<String, dynamic> body = const {},
      Map<String, String>? headers,
      String? token,
      bool isHttps = false}) {
    // TODO: implement formData
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> formDataMultiFile(String endpoints,
      {String? domain,
      List<String?> filePaths = const [],
      List<String> fileFields = const [],
      Map<String, dynamic> body = const {},
      Map<String, String>? headers,
      String? token,
      bool isHttps = false}) {
    // TODO: implement formDataMultiFile
    throw UnimplementedError();
  }

  @override
  Future formDataV1(String endpoints,
      {String? domain,
      List<String> fileFields = const [],
      List<Uint8List?> filePaths = const [],
      Map<String, dynamic> body = const {},
      Map<String, String>? headers,
      String? token,
      bool isHttps = false}) {
    // TODO: implement formDataV1
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> formDataV2(String endpoints,
      {String? domain,
      List<String> fileFields = const [],
      List<String?> filePaths = const [],
      Map<String, dynamic> body = const {},
      Map<String, String>? headers,
      String? token,
      bool isHttps = false}) {
    // TODO: implement formDataV2
    throw UnimplementedError();
  }

  @override
  Future getGetApiResponse(
    String endPoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? token,
    String? appned,
  }) async {
    try {
      var newEndPoint = appned == null ? endPoint : "$endPoint/$appned";
      if (headers != null) {
        adapter.options.headers.addAll(headers);
      }
      dio.Response res = await adapter.get(
        newEndPoint,
        data: {},
        queryParameters: queryParameters,
      );
      return dioReturnResponse(res);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getGetApiResponsewithBody(String endpoints,
      {String? domain,
      required Map<String, dynamic> body,
      Map<String, String>? headers,
      String? token,
      bool isHttps = false}) {
    // TODO: implement getGetApiResponsewithBody
    throw UnimplementedError();
  }

  @override
  Future getPostApiResponse(String endPoint,
      {String? domain,
      Object? body,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParameters,
      String? token,
      String? appned}) async {
    try {
      var newEndPoint = appned == null ? endPoint : "$endPoint/$appned";
      if (headers != null) {
        adapter.options.headers.addAll(headers);
      }
      dio.Response res = await adapter.post(
        newEndPoint,
        data: body,
        queryParameters: queryParameters,
      );
      return dioReturnResponse(res);
    } catch (e) {
      print('------------- API issuess ---------------');
      print(e);
      rethrow;
    }
  }

  @override
  Future getPutApiResponse(String endpoint,
      {Object? body,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParameters,
      String? token,
      String? appned}) async {
    try {
      var newEndPoint = appned == null ? endpoint : "$endpoint/$appned";
      if (headers != null) {
        adapter.options.headers.addAll(headers);
      }
      dio.Response res = await adapter.put(
        newEndPoint,
        queryParameters: queryParameters,
        data: body,
      );
      return dioReturnResponse(res);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getDeleteApiResponse(String endpoint,
      {Object? body,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParameters,
      String? token,
      String? appned}) async {
    try {
      var newEndPoint = appned == null ? endpoint : "$endpoint/$appned";
      if (headers != null) {
        adapter.options.headers.addAll(headers);
      }
      dio.Response res = await adapter.delete(
        newEndPoint,
        queryParameters: queryParameters,
        data: body,
      );
      return dioReturnResponse(res);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future putMethod(String url,
      {Object? body,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParameters,
      String? token}) {
    // TODO: implement putMethod
    throw UnimplementedError();
  }

  dynamic dioReturnResponse(dio.Response? response) {
    if (response != null) {
      dynamic message;
      switch (response.statusCode) {
        case 200:
          return response.data;
        case 400:
          throw BadRequestException(message, response.statusCode);
        case 401:
          throw UnauthorisedException(message, response.statusCode);
        case 403:
          throw UnauthorisedException(message, response.statusCode);
        case 500:
          throw FetchDataException('Something went wrong', response.statusCode);
        default:
          throw FetchDataException(message, response.statusCode);
      }
    } else {
      throw FetchDataException(
        'No internet connection',
      );
    }
  }
}
