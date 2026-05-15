import 'package:dio/dio.dart';
import 'package:biz_zinda/utils/api_url.dart';

import '../../../model/logged_in_user.dart';

class Api {
  final Dio api = Dio();
  String? accessToken;

  Api() {
    api.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['Authorization'] =
              'Bearer ${LoggedInUser.accessToken}';
          return handler.next(options);
        },
        onError: (error, handler) async {
          if ((error.response?.statusCode == 401)) {
            if (LoggedInUser.refreshToken != null) {
              if (await refreshToken()) {
                return handler.resolve(await _retry(error.requestOptions));
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return api.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> refreshToken() async {
    final refreshToken = LoggedInUser.refreshToken;
    final response = await api
        .post(AppUrl.refreshToken, data: {'refreshToken': refreshToken});

    if (response.statusCode == 200) {
      LoggedInUser.accessToken = response.data['token']['access']['token'];
      LoggedInUser.refreshToken = response.data['token']['refresh']['token'];
      LoggedInUser.storeUserLocally();
      return true;
    } else {
      // refresh token is wrong
      LoggedInUser.clearUserData();
      return false;
    }
  }
}
