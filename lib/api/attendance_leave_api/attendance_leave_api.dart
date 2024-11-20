import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dphe/Data/models/auth_models/login_response_model.dart';
import 'package:dphe/Data/models/common_models/dlc_model/actual_time_model.dart';
import 'package:dphe/Data/models/common_models/dlc_model/attendance_details_model.dart';
import 'package:dphe/Data/models/common_models/dlc_model/exen_data.dart';
import 'package:dphe/api/auth_api/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Data/models/common_models/dlc_model/leave_details_model.dart';
import '../../Data/models/common_models/dlc_model/lv_response_model.dart';
import '../../components/custom_snackbar/custom_snakcbar.dart';
import '../../utils/api_constant.dart';
import '../../utils/local_storage_manager.dart';

class AttendanceLeaveApi {
  Future<LeaveResponseMessageModel?> giveAttendance({
    required double latitude,
    required double longitude,
    required bool isCOnfirmation,
  }) async {
    LeaveResponseMessageModel? leaveResponseMessageModel;
    try {
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {
        ApiConstant.accept: ApiConstant.acceptValue,
        ApiConstant.contentType: ApiConstant.contentTypeValue,
        ApiConstant.authorization: "Bearer $loginToken"
      };
      final request = http.Request('POST', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.attendanceRoute}'));
      if (isCOnfirmation) {
        request.body = jsonEncode({"latitude": latitude, "longitude": longitude, "confirmation": 1});
      } else {
        request.body = jsonEncode({"latitude": latitude, "longitude": longitude});
      }

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var str = await response.stream.bytesToString();
      var json = jsonDecode(str);
      if (response.statusCode == 200 || response.statusCode == 201) {
        //{"status":"error","status_code":409,"date":"2023-10-22","message":"Leave already applied for this date"}
        log("$json");
        leaveResponseMessageModel = LeaveResponseMessageModel.fromJson(json);

        // return "success";
      } else if (response.statusCode == 401) {
        leaveResponseMessageModel = null;
        // return
        // if (context.mounted) AuthApi().callLogoutApi(context: context);
      } else if (response.statusCode == 409) {
        leaveResponseMessageModel = LeaveResponseMessageModel.fromJson(json);
      }
    } catch (e) {
      if (e is TimeoutException) {
        leaveResponseMessageModel = null;
        // AuthApi().callLogoutApi(context: context);
      }
      print(e);
    }
    return leaveResponseMessageModel;
  }

  // Future<AttendanceDetailsModel?> getUserAttendance({required BuildContext context}) async {
  //   AttendanceDetailsModel? attendanceDetailsModel;
  //   try {
  //     final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
  //     final userID = await LocalStorageManager.readData(ApiConstant.userID);
  //     var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
  //     final request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.attendanceRoute}/$userID'));

  //     request.headers.addAll(headers);
  //     final response = await request.send();
  //     var str = await response.stream.bytesToString();
  //     final json = jsonDecode(str);
  //     if (response.statusCode == 200) {
  //       attendanceDetailsModel = AttendanceDetailsModel.fromJson(json);
  //     } else if (response.statusCode == 401) {
  //       if (context.mounted) AuthApi().callLogoutApi(context: context);
  //     }
  //   } catch (e) {
  //     attendanceDetailsModel = null;
  //   }
  //   return attendanceDetailsModel;
  // }
  Future<http.StreamedResponse?> getUserAttendance({required BuildContext context}) async {
    AttendanceDetailsModel? attendanceDetailsModel;
    http.StreamedResponse? response;
    try {
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      final userID = await LocalStorageManager.readData(ApiConstant.userID);
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      final request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.attendanceRoute}/$userID'));

      request.headers.addAll(headers);
      response = await request.send();
      return response;
    } catch (e) {
      response = null;
    }
    return response;
  }

  Future<ExenDataModel?> getExenDataForLeave({required BuildContext context}) async {
    http.Request request;
    try {
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.exenForLeave}'));

      request.headers.addAll(headers);
      final response = await request.send();
      var str = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return ExenDataModel.fromJson(jsonDecode(str));
      } else {
        CustomSnackBar(message: "Failed to get Data", isSuccess: false).show();
      }
    } catch (e) {
      if (e is TimeoutException) {
        CustomSnackBar(message: "Connection Timed out", isSuccess: false).show();
        // AuthApi().callLogoutApi(context: context);
      }
      print(e);
    }
    return null;
  }

  Future<LeaveResponseMessageModel>? leaveApplication({
    int? exenId,
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String? description,
    bool isEdit = false,
  }) async {
    String responsMessage = '';
    http.MultipartRequest? request;
    String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
    var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
    //if (leaveID == null) {
    request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.leaveRoute}'));
    request.fields.addAll({
      "exen_id": exenId.toString(),
      "leave_type": leaveType.toString().trim(),
      "from": fromDate,
      "to": toDate,
      "description": description.toString().trim()
    });

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var str = await response.stream.bytesToString();
    var json = jsonDecode(str);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return LeaveResponseMessageModel.fromJson(json);
      // responsMessage = json["message"];
      //return responsMessage;
    } else if (response.statusCode == 409) {
      responsMessage = "409";
      return LeaveResponseMessageModel.fromJson(json);
      // return responsMessage;
      //{"status":"error","status_code":409,"message":"Leave already applied for this date"}
    } else {
      responsMessage = "Error";
      return LeaveResponseMessageModel.fromJson(json);
    }
  }

  Future<LeaveResponseMessageModel?> updateLeaveAplication({
    required int leaveID,
    required int exenId,
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String? description,
  }) async {
    String responsMessage = '';
    LeaveResponseMessageModel? leaveResponseMessageModel;
    String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
    var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
    final request = http.Request('PUT', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.leaveRoute}/$leaveID'));
    request.body = jsonEncode({"exen_id": exenId, "leave_type": leaveType, "from": fromDate, "to": toDate, "description": description});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var str = await response.stream.bytesToString();
    log('leave update message $str');
    var json = jsonDecode(str);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // responsMessage = json["message"];
      leaveResponseMessageModel = LeaveResponseMessageModel.fromJson(json);
      return leaveResponseMessageModel;
    } else if (response.statusCode == 409) {
      leaveResponseMessageModel = LeaveResponseMessageModel.fromJson(json);
      return leaveResponseMessageModel;
      //{"status":"error","status_code":409,"message":"Leave already applied for this date"}
    } else {
      responsMessage = "Error";
      leaveResponseMessageModel = null;
    }
    return leaveResponseMessageModel;
  }

  Future<String> deleteLeave({required int leaveID}) async {
    String responsMessage = '';
    String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
    var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
    final request = http.Request('DELETE', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.leaveRoute}/$leaveID'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var str = await response.stream.bytesToString();
    var json = jsonDecode(str);
    if (response.statusCode == 200 || response.statusCode == 201) {
      responsMessage = json["message"];
      return responsMessage;
    } else if (response.statusCode == 409) {
      responsMessage = "409";
      return responsMessage;
      //{"status":"error","status_code":409,"message":"Leave already applied for this date"}
    } else {
      responsMessage = "Error";
      return responsMessage;
    }
  }

  Future<LeaveDetailsModel?> getAllLeaveData() async {
    // http.Request request;
    try {
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      final request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.leaveRoute}'));

      request.headers.addAll(headers);
      final response = await request.send();
      var str = await response.stream.bytesToString();
      log('leave $str');
      if (response.statusCode == 200) {
        return LeaveDetailsModel.fromJson(jsonDecode(str));
      } else if (response.statusCode == 401) {
        AuthApi().callLogoutApi();
      } else {
        CustomSnackBar(message: "Server error", isSuccess: false);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<LeaveDetailsModel?> getFilterLeaveData({bool isFilter = false, String? formDate, String? toDate}) async {
    // http.Request request;
    try {
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {
        ApiConstant.accept: ApiConstant.acceptValue,
        ApiConstant.contentType: ApiConstant.contentTypeValue,
        ApiConstant.authorization: "Bearer $loginToken"
      };
      final request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.leaveRoute}'));
      var param = {"filter_from_date": formDate, "filter_to_date": toDate};

      request.body = jsonEncode(param);

      request.headers.addAll(headers);
      final response = await request.send();
      var str = await response.stream.bytesToString();
      log('leave filter $str');
      if (response.statusCode == 200) {
        return LeaveDetailsModel.fromJson(jsonDecode(str));
      } else if (response.statusCode == 401) {
        AuthApi().callLogoutApi();
      } else {
        CustomSnackBar(message: "Server error", isSuccess: false);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<ActualTimeZoneModel?> getActualTime() async {
    var headers = {
      ApiConstant.accept: ApiConstant.acceptValue,
    };
    final request = http.Request('GET', Uri.parse('https://worldtimeapi.org/api/timezone/Asia/Dhaka'));
    request.headers.addAll(headers);
    final response = await request.send();
    var str = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return ActualTimeZoneModel.fromJson(jsonDecode(str));
    } else {
      return null;
    }
  }
}
