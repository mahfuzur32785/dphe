import 'dart:convert';

class OtpResponseModel {
  final bool? success;
  final String? message;
  final int? otp;

  OtpResponseModel({
    this.success,
    this.message,
    this.otp,
  });

  factory OtpResponseModel.fromRawJson(String str) => OtpResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) => OtpResponseModel(
    success: json["success"],
    message: json["message"],
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "otp": otp,
  };
}
