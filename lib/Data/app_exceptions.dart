class AppExceptions implements Exception {

  final dynamic _message;
  final dynamic statuscode;

  AppExceptions([this._message, this.statuscode]);
  @override
  String toString() {
    return '$statuscode $_message';
  }
}

class FetchDataException extends AppExceptions {  
  FetchDataException([String? super.messages,int? super.statusCode]);
}

class BadRequestException extends AppExceptions {
  BadRequestException([String? super.messages,int? super.statusCode]);
}

class UnauthorisedException extends AppExceptions {
  UnauthorisedException([String? super.messages,int? super.statusCode]);
}

class InavalidInputException extends AppExceptions {
  InavalidInputException([String? super.messages,int? super.statusCode]);
}