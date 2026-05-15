import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

import '../../utils/api_url.dart';
import '../app_exceptions.dart';
import 'base_api_service.dart';


class NetworkApiService implements BaseApiService {
  @override
  Future<dynamic> getGetApiResponse(
    String endPoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? appned,
    String? token,
  }) async {
    bool isHttps = AppUrl.isProduction;
    try {
      var newEndPoint = appned == null ? endPoint : "$endPoint/$appned";
      var uri = isHttps == false
          ? Uri.http(AppUrl.httpBaseUrl, newEndPoint, queryParameters)
          : Uri.https(AppUrl.httpBaseUrl, newEndPoint, queryParameters);
      Response response = await http.get(
        uri,
        headers: _mergedheaders(headers, token),
      );
      return returnResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getPostApiResponse(
    String endPoint, {
    String? domain,
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? token,
    String? appned,
  }) async {
    try {
      bool isHttps = AppUrl.isProduction;
      var newEndPoint = appned == null ? endPoint : "$endPoint/$appned";
      var uri = isHttps
          ? Uri.https(AppUrl.httpBaseUrl, newEndPoint, queryParameters)
          : Uri.http(
              domain ?? AppUrl.httpBaseUrl, newEndPoint, queryParameters);
    
      Response? response = await http.post(
        uri,
        body: body != null ? jsonEncode(body) : null,
        headers: _mergedheaders(headers, token),
      );
      return returnResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> putMethod(
    String url, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? token,
    String? appned,
  }) async {
    try {
      var uri = Uri.parse(url);

      Response? response = await http.put(
        uri,
        body: body,
        headers: headers,
      );
      return returnResponse(response, mapcheck: false);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getPutApiResponse(
    String endPoint, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? token,
    String? appned,
  }) async {
    try {
      var newEndPoint = appned == null ? endPoint : "$endPoint/$appned";
      var uri = Uri.parse("${AppUrl.scurity}://${AppUrl.baseurl}/$newEndPoint");

      Response? response = await http.put(
        uri,
        body: body,
        headers: _mergedheaders(headers, token),
      );
      return returnResponse(response, mapcheck: false);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Uint8List> fetchImage(String imageLink) async {
    try {
      var response = await http.get(Uri.parse(imageLink));
      returnResponse(response, mapcheck: false);
      return Uint8List.fromList(response.bodyBytes);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getDeleteApiResponse(
    String endPoint, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? token,
    String? appned,
  }) async {
    try {
      var newEndPoint = appned == null ? endPoint : "$endPoint/$appned";
      var uri = Uri.parse("${AppUrl.scurity}://${AppUrl.baseurl}/$newEndPoint");

      Response? response = await http.delete(
        uri,
        body: body,
        headers: _mergedheaders(headers, token),
      );
      return returnResponse(response, mapcheck: false);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> formData(
    String endpoints, {
    String? domain,
    List<String> fileFields = const [],
    List<String?> filePaths = const [],
    Map<String, dynamic> body = const {},
    Map<String, String>? headers,
    String? token,
    bool isHttps = false,
  }) async {
    isHttps = AppUrl.isProduction;
    try {
      dio.Dio doo = dio.Dio();
      for (var i = 0; i < fileFields.length; i++) {
        body.addAll({
          fileFields[i]: filePaths[i] == null
              ? null
              : await dio.MultipartFile.fromFile(filePaths[i]!),
        });
      }
      dio.FormData form = dio.FormData.fromMap(body);
      final url = isHttps
          ? Uri.https(domain ?? AppUrl.baseurl, endpoints)
          : Uri.http(
              domain ?? AppUrl.baseurl,
              endpoints,
            );
      doo.options.headers = _mergedheaders(headers, token);
      dio.Response resp = await doo.post(
        url.toString(),
        data: form,
      );
      return dioReturnResponse(resp);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> formDataV1(
    String endpoints, {
    String? domain,
    List<String> fileFields = const [],
    List<Uint8List?> filePaths = const [],
    Map<String, dynamic> body = const {},
    Map<String, String>? headers,
    String? token,
    bool isHttps = false,
  }) async {
    isHttps = AppUrl.isProduction;
    try {
      dio.Dio doo = dio.Dio();
      for (var i = 0; i < fileFields.length; i++) {
        body.addAll({
          fileFields[i]: filePaths[i] == null
              ? null
              : dio.MultipartFile.fromBytes(
                  filePaths[i]!,
                  filename: 'test.png',
                ),
        });
      }
      dio.FormData form = dio.FormData.fromMap(body);
      final url = isHttps
          ? Uri.https(domain ?? AppUrl.baseurl, endpoints)
          : Uri.http(
              domain ?? AppUrl.baseurl,
              endpoints,
            );
      doo.options.headers = _mergedheaders(headers, token);
      dio.Response resp = await doo.post(
        url.toString(),
        data: form,
      );
      return dioReturnResponse(resp);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getGetApiResponsewithBody(
    String endpoints, {
    String? domain,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    String? token,
    bool isHttps = false,
  }) async {
    isHttps = AppUrl.isProduction;
    try {
      dio.Dio doo = dio.Dio();
      dio.FormData form = dio.FormData.fromMap(body);
      final url = isHttps
          ? Uri.https(domain ?? AppUrl.baseurl, endpoints)
          : Uri.http(
              domain ?? AppUrl.baseurl,
              endpoints,
            );
      doo.options.headers = _mergedheaders(headers, token);
      dio.Response resp = await doo.get(
        url.toString(),
        data: body,
      );
      return dioReturnResponse(resp);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Uint8List> formDataV2(
    String endpoints, {
    String? domain,
    List<String> fileFields = const [],
    List<String?> filePaths = const [],
    Map<String, dynamic> body = const {},
    Map<String, String>? headers,
    String? token,
    bool isHttps = false,
  }) async {
    isHttps = AppUrl.isProduction;
    try {
      final url = isHttps
          ? Uri.https(domain ?? AppUrl.baseurl, endpoints)
          : Uri.http(
              domain ?? AppUrl.baseurl,
              endpoints,
            );
      // Create a multipart request
      var request = http.MultipartRequest('POST', url);
      for (var i = 0; i < fileFields.length; i++) {
        if (filePaths[i] == null) continue;
        var file = File(filePaths[i]!);

        // Add the image to the request
        var fileStream = http.ByteStream(file.openRead());
        var length = await file.length();
        var multipartFile = http.MultipartFile(
          fileFields[i],
          fileStream,
          length,
          filename: filePaths[i]!.split('/').last,
        );
        request.files.add(multipartFile);
      }
      for (var i = 0; i < fileFields.length; i++) {
        if (filePaths[i] == null) {
          request.fields[fileFields[i]] == null;
        }
      }
      request.headers.addAll(_mergedheaders(headers, token));
      // Send the request
      var response = await request.send();
      if (response.statusCode != 200) {
        throw "Some thing went wrong";
      }
      return await response.stream.toBytes();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> formDataMultiFile(
    String endpoints, {
    String? domain,
    List<String?> filePaths = const [],
    List<String> fileFields = const [],
    Map<String, dynamic> body = const {},
    Map<String, String>? headers,
    String? token,
    bool isHttps = false,
  }) async {
    try {
      dio.Dio d = dio.Dio();
      Map<String, dynamic> reData = body;
      for (var i = 0; i < fileFields.length; i++) {
        if (filePaths[i] != null) {
          reData.addAll(
            {
              fileFields[i]: await dio.MultipartFile.fromFile(filePaths[i]!),
            },
          );
        }
      }
      dio.FormData formData = dio.FormData.fromMap(reData);
      dio.Response resp = await d.post(
        domain ?? "${AppUrl.baseurl}$endpoints", //Uri.parse(uri),
        data: formData,
      );
      if (resp.data == null) {
        throw "Some thing went wrong";
      }
      return resp.data;
    } catch (e) {
      rethrow;
    }

    // handler.data = resp.data;
    // handler.operation = true;
    // return handler;
  }

  dynamic dioReturnResponse(dio.Response? response) {
    if (response != null) {
      dynamic message;

      // var body = response.data;

      // if (body.containsKey("message")) {
      //   message = body["message"];
      // }

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

  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
  };

  Map<String, String>? _token(String? token) =>
      token != null ? {'Authorization': 'bearer $token'} : null;

  Map<String, String> _mergedheaders(
          Map<String, String>? headers, String? token) =>
      {..._defaultHeaders, ...?headers, ...?_token(token),
        'X-Platform': 'bizzzinda',
      };

  dynamic returnResponse(Response? response, {bool mapcheck = true}) {
    if (response != null) {
      String? message;

      if (mapcheck == true) {
        final responsebody = jsonDecode(response.body);

        var body = responsebody as Map<String, dynamic>;
        if (body.containsKey("message")) {
          message = body["message"];
        }
      }

      switch (response.statusCode) {
        case 200:
          return response.body;
        case 400:
          throw BadRequestException(message);
        case 401:
          throw UnauthorisedException(message);
        case 404:
          throw InavalidInputException(message);
        case 403:
          throw UnauthorisedException(message);
        case 500:
          throw FetchDataException(
            'Something went wrong',
          );
        default:
          throw FetchDataException(message);
      }
    } else {
      throw FetchDataException(
        'No internet connection',
      );
    }
  }
}
