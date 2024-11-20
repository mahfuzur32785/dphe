import 'dart:convert';

import 'package:dphe/Data/models/base/api_response.dart';
import 'package:dphe/Data/models/common_models/dlc_model/dlc_assignment_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_constant.dart';
import '../../utils/local_storage_manager.dart';

class OtherActivityApi {
  Future<http.StreamedResponse?> getAllAssignments() async {
    http.StreamedResponse? response;
    try {
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      final request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.dlcotheractivityRoute}'));
      request.headers.addAll(headers);
      final response = await request.send();
      return response;
    } on Exception catch (e) {
      response = null;
    }
    return response;
  }

  Future<ResponseModel> insertOtherActivity(
      {required int activityID,
      required int districtID,
      required int upaID,
       int? unionID,
      required String activityType,
      required int targetParticipant,
      required int attended,
      required String date,
      required String stkHolder,
      required int completedBatch,
      String? limitation,
      String? recommendation,
      String? remarks}) async {
        ResponseModel? responsModel;
    String responsMessage = '';
    String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
    var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
    var request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.dlcotheractivityRoute}'));
    request.fields.addAll({
      'activity_id': activityID.toString(),
      'district_id': districtID.toString(),
      'upazila_id': upaID.toString(),
      'union_id':  unionID.toString(),
      'activity_type': activityType,
      'target_participant': targetParticipant.toString(),
      'attended': attended.toString(),
      'date': date,
      'stakeholder': stkHolder,
      'completed_batch': completedBatch.toString(),
      'limitation': limitation ?? '',
      'recommendation': recommendation ?? '',
      'remarks': remarks ?? ''
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var str = await response.stream.bytesToString();
    var json = jsonDecode(str);
    if (response.statusCode == 200 || response.statusCode == 201) {
     
      responsMessage = json["message"];
       responsModel = ResponseModel(true, json["message"]);
      return responsModel;
    } else if (response.statusCode == 409){
      responsMessage = json["message"];
       responsModel = ResponseModel(false, json["message"]);
      return responsModel;
    } else {
      responsMessage = "Error";
      responsModel = ResponseModel(false, responsMessage);
      return responsModel;
    }
  }
}
