import 'package:dio/dio.dart';

class ApiResponse {
  final Response? response;
  final dynamic error;

  ApiResponse(this.response, this.error);

  ApiResponse.withError(dynamic errorValue)
      : response = null,
        error = errorValue;

  ApiResponse.withSuccess(Response responseValue)
      : response = responseValue,
        error = null;
}

class ResponseModel {
  bool _isSuccess;
  String _message;
  ResponseModel(this._isSuccess, this._message);

  String get message => _message;
  bool get isSuccess => _isSuccess;
}
