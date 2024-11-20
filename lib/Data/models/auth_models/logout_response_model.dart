import 'dart:convert';

class LogoutResponseModel {
  final String? status;
  final String? message;
  final int? statusCode;
  final Data? data;

  LogoutResponseModel({
    this.status,
    this.message,
    this.statusCode,
    this.data,
  });

  factory LogoutResponseModel.fromRawJson(String str) => LogoutResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) => LogoutResponseModel(
    status: json["status"],
    message: json["message"],
    statusCode: json["status_code"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "status_code": statusCode,
    "data": data?.toJson(),
  };
}

class Data {
  final String? status;
  final String? message;

  Data({
    this.status,
    this.message,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
