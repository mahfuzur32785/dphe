import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dphe/Data/models/common_models/dlc_model/dlc_question_model.dart';
import 'package:dphe/api/beneficiary_api/dlc_api/dlc_twin_pit_latrine_verification_api.dart';
import 'package:dphe/offline_database/db_tables/le_tables/beneficiary_list_table.dart';
import 'package:http/http.dart' as http;
import '../../../Data/models/common_models/dlc_model/beneficiary_model.dart';
import '../../../components/custom_snackbar/custom_snakcbar.dart';
import '../../../utils/api_constant.dart';
import '../../../utils/local_storage_manager.dart';

class BeneficiaryApi {
  Future<BeneficiaryModel?> getbeneficiaryList({
    required int districtID,
    required int upazilaID,
    required int statusID,
    int? unionID,
    int? wardNo,
    int? leid,
    bool isSearch = false,
    bool isLeWiseBeneficiaries = false,
    int? pageNO,
    //bool isSendBackLtrVerific = false,
    String? phoneOrLe,
  }) async {
    http.Request request;
    try {
      String uri =
          '${ApiConstant.baseUrl}${ApiConstant.beneficiariesRoute}?district_id=$districtID&upazila_id=$upazilaID&status_id=$statusID'; //&rows=15&page=$pageNo
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      if (!isLeWiseBeneficiaries) {
        if (unionID != null) {
          //&union_id=$unionId&ward_no=$wardNo
          uri = '$uri&union_id=$unionID';
        }
        if (wardNo != null) {
          uri = '$uri&ward_no=$wardNo';
        }
        if (isSearch) {
          uri = '$uri&search=$phoneOrLe';
        }
        request = http.Request('GET', Uri.parse(uri));
        // request = !isSearch
        //     ? http.Request(
        //         'GET',
        //         Uri.parse(
        //             '${ApiConstant.baseUrl}${ApiConstant.beneficiariesRoute}?district_id=$districtID&upazila_id=$upazilaID&status_id=$statusID'))
        //     : http.Request(
        //         'GET',
        //         Uri.parse(
        //             '${ApiConstant.baseUrl}${ApiConstant.beneficiariesRoute}?district_id=$districtID&upazila_id=$upazilaID&status_id=$statusID&search=$phoneOrLe'));
      } else {
        request = !isSearch
            ? http.Request(
                'GET',
                Uri.parse(
                    '${ApiConstant.baseUrl}${ApiConstant.beneficiariesRoute}?district_id=$districtID&upazila_id=$upazilaID&status_id=$statusID&user_id=$leid'))
            : http.Request(
                'GET',
                Uri.parse(
                    '${ApiConstant.baseUrl}${ApiConstant.beneficiariesRoute}?district_id=$districtID&upazila_id=$upazilaID&status_id=$statusID&search=$phoneOrLe&user_id=$leid'));
      }

      request.headers.addAll(headers);
      final response = await request.send().timeout(Duration(seconds: 15));
      var str = await response.stream.bytesToString();
      var json = jsonDecode(str);
      log('$str');
      if (response.statusCode == 200) {
        return BeneficiaryModel.fromJson(jsonDecode(str));
      } else {
        CustomSnackBar(message: "Server error", isSuccess: false);
      }
    } on TimeoutException catch (_) {
      CustomSnackBar(isSuccess: false, message: 'Connection Timed out').show();
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<BeneficiaryModel?> fetchPaginatedBeneficiaryList({
    required int districtID,
    required int upazilaID,
    required int statusID,
    int? isSendBack,
    int? unionID,
    int? wardNo,
    int? leid,
    bool isSearch = true,
    bool isLeWiseBeneficiaries = false,
    //bool isSendBackLtrVerific = false,
    String phoneOrLe = '',
    int? pageNo,
  }) async {
    http.Request request;
    try {
      String uri =
          '${ApiConstant.baseUrl}${ApiConstant.beneficiariesRoute}?district_id=$districtID&upazila_id=$upazilaID&status_id=$statusID&rows=4&page=$pageNo';
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      if (!isLeWiseBeneficiaries) {
        if (unionID != null) {
          //&union_id=$unionId&ward_no=$wardNo
          uri = '$uri&union_id=$unionID';
        }
        if (wardNo != null) {
          uri = '$uri&ward_no=$wardNo';
        }
        if (phoneOrLe.isNotEmpty) {
          uri = '$uri&search=$phoneOrLe';
        }
        if (leid != null) {
          uri = '$uri&user_id=$leid';
        }
        if (isSendBack != null) {
          uri = '$uri&is_send_back=1';
        }
        request = http.Request('GET', Uri.parse(uri));
        // request = !isSearch
        //     ? http.Request(
        //         'GET',
        //         Uri.parse(
        //             '${ApiConstant.baseUrl}${ApiConstant.beneficiariesRoute}?district_id=$districtID&upazila_id=$upazilaID&status_id=$statusID'))
        //     : http.Request(
        //         'GET',
        //         Uri.parse(
        //             '${ApiConstant.baseUrl}${ApiConstant.beneficiariesRoute}?district_id=$districtID&upazila_id=$upazilaID&status_id=$statusID&search=$phoneOrLe'));
      } else {
        request = !isSearch
            ? http.Request(
                'GET',
                Uri.parse(
                    '${ApiConstant.baseUrl}${ApiConstant.beneficiariesRoute}?district_id=$districtID&upazila_id=$upazilaID&status_id=$statusID&user_id=$leid'))
            : http.Request(
                'GET',
                Uri.parse(
                    '${ApiConstant.baseUrl}${ApiConstant.beneficiariesRoute}?district_id=$districtID&upazila_id=$upazilaID&status_id=$statusID&search=$phoneOrLe&user_id=$leid'));
      }

      request.headers.addAll(headers);
      final response = await request.send().timeout(Duration(seconds: 220));
      var str = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return BeneficiaryModel.fromJson(jsonDecode(str));
      } else {
        CustomSnackBar(message: "Server error", isSuccess: false);
      }
    } on TimeoutException catch (_) {
      CustomSnackBar(isSuccess: false, message: 'Connection Timed out. Please Try Again Later').show();
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<BeneficiaryModel?> getSendBackLtrVerf({
    required int districtID,
    required int upazilaID,
    required int statusID,
    int? leid,
    bool isSearch = false,

    //bool isSendBackLtrVerific = false,
    String? phoneOrLe,
  }) async {
    http.Request request;
    try {
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      request = http.Request(
          'GET',
          Uri.parse(
              '${ApiConstant.baseUrl}${ApiConstant.beneficiariesRoute}?district_id=$districtID&upazila_id=$upazilaID&status_id=$statusID&user_id=$leid&is_send_back=1'));

      request.headers.addAll(headers);
      final response = await request.send();
      var str = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return BeneficiaryModel.fromJson(jsonDecode(str));
      } else {
        CustomSnackBar(message: "Server error", isSuccess: false);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String> physicalVerifyPost({
    required int id,
    required String latitude,
    required String longitude,
    required String dlcQuestion,
    //required List<DlcQAnsModel> dlcQuestion,
    required String status,
    String? reason,
  }) async {
    String responsMessage = '';
    try {
      String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.draftPhysicalVerify}'));
      request.fields.addAll(
        {
          "id": id.toString(),
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
          "question_answer": dlcQuestion,
          "status": status,
          "reason": reason ?? '',
        },
      );
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send().timeout(Duration(seconds: 15));
      var str = await response.stream.bytesToString();
      var json = jsonDecode(str);
      if (response.statusCode == 200 || response.statusCode == 201) {
        responsMessage = json["message"];
        return responsMessage;
      } else {
        responsMessage = "Error";
        return responsMessage;
      }
    } on TimeoutException catch (_) {
      responsMessage = "TimeOut";
      // CustomSnackBar(isSuccess: false, message: 'Connection Timed out').show();
    } on Exception catch (e) {
      responsMessage = "Error";
    }
    return responsMessage;
  }

  Future<List<DlcQuestionModel>?> getPhysicalVerifyQuestionsForDlc() async {
    http.Request request;
    try {
      List<DlcQuestionModel> dlcQuesList = [];
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}/get-hcp-hhs-verification-questions'));

      request.headers.addAll(headers);
      final response = await request.send().timeout(Duration(seconds: 15));
      var str = await response.stream.bytesToString();
      var jsonMap = jsonDecode(str);
      if (response.statusCode == 200 || response.statusCode == 201) {
        for (var element in jsonMap) {
          dlcQuesList.add(DlcQuestionModel.fromJson(element));
        }

        return dlcQuesList;
        // return ExenDataModel.fromJson(jsonDecode(str));
      } else {
        return null;
        // CustomSnackBar(message: "Server error", isSuccess: false);
      }
    } catch (e) {
      if (e is TimeoutException) {
        return null;
        //AuthApi().callLogoutApi(context: context);
      }
      print(e);
    }
    return null;
  }
}
