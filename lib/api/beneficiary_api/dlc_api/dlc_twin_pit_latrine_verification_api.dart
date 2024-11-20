import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../Data/models/common_models/dlc_model/dlc_question_model.dart';
import '../../../Data/models/common_models/dlc_model/send_back_model.dart';
import '../../../components/custom_snackbar/custom_snakcbar.dart';
import '../../../utils/api_constant.dart';
import '../../../utils/local_storage_manager.dart';
import 'package:http/http.dart' as http;

import '../../auth_api/auth_api.dart';

class DlcLatrineVerificationApi {
  Future<List<DlcQuestionModel>> getDlcQuestions() async {
    bool questionsFromAPi = false;
    List<DlcQuestionModel> getDlcQuesList = [];
    List<DlcQuestionModel> vargetDlc = [];
    try {
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      final request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.getDlcQuestions}'));
      request.headers.addAll(headers);
      final response = await request.send();
      var str = await response.stream.bytesToString();

      jsonDecode(str).forEach((element) {
        getDlcQuesList.add(DlcQuestionModel.fromJson(element));
      });
      if (response.statusCode == 200) {
        questionsFromAPi = true;

        return getDlcQuesList;
      } else {
        getDlcQuesList = [];
        questionsFromAPi = false;
        //  return questionsFromAPi;
        // CustomSnackBar(message: "Server error", isSuccess: false).show();
      }
    } catch (e) {
      questionsFromAPi = false;
      print(e);
    }
    return getDlcQuesList;
  }

  Future<http.Response?> verifyLatrineInstallation({required int benfiD, required List<DlcQAnsModel> dlcQuestion}) async {
    String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
    var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
    var request = http.post(Uri.parse('${ApiConstant.baseUrl}${ApiConstant.getDlcQuesAnswer}'), //dlcQuestion.map((e) => e.toJson()).toList(),
        body: jsonEncode({
          'question_answer': dlcQuestion,
          'beneficiary_id': benfiD,
        }),
        headers: headers);
    return request;
  }

  //updatedVerifyLatrineInstallation
  Future<String> newverifyLatrineInstallation(
      {required int beneficiaryId,
      required List<DlcQAnsModel> dlcQuestion,
      List<DlcSendBQAModel>? sendBackQues,
      //required List<LeAnsModel> ansList,

      String? image}) async {
    try {
      http.MultipartRequest request;
      String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
      request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.getDlcQuesAnswer}'));
      var map = {
        "question_answer": jsonEncode(dlcQuestion),
        "beneficiary_id": beneficiaryId.toString(),
      };
      if (sendBackQues != null) {
        map.addAll({
          "send_backs": jsonEncode(sendBackQues),
        });
      }
      if (image != null) {
        map.addAll({
          "image": image,
        });
        request.files.add(await http.MultipartFile.fromPath('image', image));
      }

      request.fields.addAll(map);

      request.headers.addAll(headers);
      //print(request.body);

      http.StreamedResponse response = await request.send();
      var str = await response.stream.bytesToString();
      print(
          "response.statusCode ${response.statusCode}"); //{"message":"Call to undefined function Intervention\\Image\\Gd\\imagecreatefromjpeg()","data":[],"status":400}
      print("response ${response}");
      if (response.statusCode == 200) {
        CustomSnackBar(message: "Verification Submitted Successfully", isSuccess: true).show();
        return "200";
      } else {
        CustomSnackBar(message: "Server Error", isSuccess: false);
        return "0";
      }
    } catch (e) {
      CustomSnackBar(message: "Error: $e", isSuccess: false);

      return e.toString();
    }
  }

  Future<List<SendBackModel>?> getSendBackReasonsData({
    required int id,
  }) async {
    http.Request request;
    try {
      List<SendBackModel> sendBackList = [];
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}/get-send-back-reasons/$id'));

      request.headers.addAll(headers);
      final response = await request.send();
      var str = await response.stream.bytesToString();
      var jsonMap = jsonDecode(str);
      if (response.statusCode == 200) {
        for (var element in jsonMap) {
          sendBackList.add(SendBackModel.fromJson(element));
        }

        return sendBackList;
        // return ExenDataModel.fromJson(jsonDecode(str));
      } else {
        return null;
        // CustomSnackBar(message: "Server error", isSuccess: false);
      }
    } catch (e) {
      if (e is TimeoutException) {
        //AuthApi().callLogoutApi(context: context);
      }
      print(e);
    }
    return null;
  }

  Future<Map> sendBackLatrineVerification({required int benfiD, required String comment}) async {
    log('base URl ; ${ApiConstant.baseUrl}');
    try {
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {
        ApiConstant.accept: ApiConstant.acceptValue,
        ApiConstant.contentType: ApiConstant.contentTypeValue,
        ApiConstant.authorization: "Bearer $loginToken"
      };
      final request = http.Request('POST', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.sendBacklatrVerification}'));

      request.body = jsonEncode({
        'comment': comment,
        'beneficiary_id': benfiD,
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var str = await response.stream.bytesToString();
      Map json = jsonDecode(str);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json;

        // return "success";
      } else {
        return {
          'message': 'Something Went Wrong',
          'status': 400
        };
      }
    } catch (e) {
      print(e);
      if (e is TimeoutException) {
        return {
          'message': 'Connection Timed Out',
          'status': 500
        };
        // AuthApi().callLogoutApi(context: context);
      } else {
        return {
          'message': '${e.toString()}',
          'status': 500
        };
      }
    }
  }
}

class DlcQAnsModel {
  int? questionId;
  String? answer;

  DlcQAnsModel({this.questionId, this.answer});

  DlcQAnsModel.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    data['answer'] = this.answer;
    return data;
  }
}

class LeUpdScrnAnswer {
  int? id;
  String? answer;

  LeUpdScrnAnswer({this.id, this.answer});

  LeUpdScrnAnswer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['answer'] = this.answer;
    return data;
  }
}

class DlcSendBQAModel {
  int? questionId;
  String? answer;

  DlcSendBQAModel({this.questionId, this.answer});

  DlcSendBQAModel.fromJson(Map<String, dynamic> json) {
    questionId = json['id'];
    answer = json['is_resolved_answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.questionId;
    data['is_resolved_answer'] = this.answer;
    return data;
  }
}
