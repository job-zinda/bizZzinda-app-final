import 'package:dio/dio.dart';
import '../model/logged_in_user.dart';
import '../utils/api_url.dart';
import '../view/plansforyou/plansforyou_model.dart';

/// 🔹 FETCH MESSAGES
Future<List<FreelancerMessageModel>> fetchFreelancerMessages({
  int pageNumber = 1,
  int pageSize = 10,
}) async {
  try {
    final headers = await Api.getAuthorizationHeader();

    print("Logged User ID: ${LoggedInUser.id}");

    final response = await Dio().get(
      '${Api.baseurl}/api/v1/freelancer-message/my-freelancer-messages',
      queryParameters: {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
      },
      options: Options(headers: headers),
    );

    print("Status Code: ${response.statusCode}");
    print("Response Data: ${response.data}");

    if (response.statusCode == 200 &&
        response.data != null &&
        response.data['data'] != null &&
        response.data['data']['messages'] != null) {

      final List messages =
      response.data['data']['messages'] as List;

      return messages
          .map((json) => FreelancerMessageModel.fromJson(json))
          .toList();
    } else {
      return [];
    }

  } catch (e) {
    print("Error fetching messages: $e");
    return [];
  }
}



