

import 'package:biz_zinda/Data/Response/AppResponse/status.dart';

class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;

  ApiResponse(this.data, this.message, this.status);

  ApiResponse.error(this.message) : status = Status.error;

  ApiResponse.completed(this.data) : status = Status.completed;

  ApiResponse.loading() : status = Status.loading;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data: $data";
  }
}
