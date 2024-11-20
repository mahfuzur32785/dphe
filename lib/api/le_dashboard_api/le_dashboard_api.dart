import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dphe/Data/models/common_models/dlc_model/beneficiary_model.dart';
import 'package:dphe/Data/models/le_models/benificiary_models/le_beneficiary_details.dart';
import 'package:dphe/api/auth_api/auth_api.dart';
import 'package:dphe/Data/models/common_models/union_dropdown_model.dart';
import 'package:dphe/Data/models/le_models/le_dashboard_models/le_qsn_model.dart';
import 'package:dphe/utils/local_storage_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;
import '../../Data/models/common_models/dlc_model/dlc_question_model.dart';
import '../../Data/models/le_models/le_answer_mode.dart';
import '../../components/custom_snackbar/custom_snakcbar.dart';
import '../../Data/models/common_models/upazila_dropdown_model.dart';
import '../../Data/models/le_models/benificiary_models/non_selected_benificiary_list_model.dart';
import '../../Data/models/le_models/le_dashboard_models/image_response_model.dart';
import '../../Data/models/le_models/le_dashboard_models/le_dashboard.dart';
import '../../utils/api_constant.dart';
import '../../utils/app_constant.dart';
import '../beneficiary_api/dlc_api/dlc_twin_pit_latrine_verification_api.dart';

class LeDashboardApi {
  //to get union
  Future<LeDashboardModel?> getLeDashboardApi() async {
    try {
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      final request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}/get-le-dashboard-data'));
      request.headers.addAll(headers);
      final response = await request.send();
      debugPrint('${ApiConstant.baseUrl}/get-le-dashboard-data}');
      var str = await response.stream.bytesToString();
      log('le dashbrd ${str}');
      if (response.statusCode == 200) {
        LocalStorageManager.saveData(
            AppConstant.leDashboardUnderSelectionCount, LeDashboardModel.fromJson(jsonDecode(str)).underSelection!.count ?? 0);
        LocalStorageManager.saveData(AppConstant.leDashboardApprovedSelectionCount, LeDashboardModel.fromJson(jsonDecode(str)).approved!.count ?? 0);
        LocalStorageManager.saveData(AppConstant.leDashboardOngoingCount, LeDashboardModel.fromJson(jsonDecode(str)).ongoing!.count ?? 0);
        LocalStorageManager.saveData(
            AppConstant.leDashboardUnderVerificationCount, LeDashboardModel.fromJson(jsonDecode(str)).underVerification!.count ?? 0);
        LocalStorageManager.saveData(AppConstant.leDashboardVerifiedCount, LeDashboardModel.fromJson(jsonDecode(str)).verified!.count ?? 0);
        LocalStorageManager.saveData(AppConstant.leDashboardBillPaid, LeDashboardModel.fromJson(jsonDecode(str)).billPaid!.count ?? 0);
        return LeDashboardModel.fromJson(jsonDecode(str));
      } else if (response.statusCode == 401) {
        await AuthApi().callLogoutApi();
        return LeDashboardModel();
      } else {
        return LeDashboardModel();
      }
    } catch (e) {
      print("Error le Dashboard api: $e");
    }
    return null;
  }

  //to get upazila list
  Future<UpazilaDropdownModel?> getUpazillaDropdownApi({required int districtId}) async {
    try {
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      final request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}/get-upazila/$districtId'));
      request.headers.addAll(headers);
      final response = await request.send();
      var str = await response.stream.bytesToString();
      print(response.statusCode);
      if (response.statusCode == 200) {
        return UpazilaDropdownModel.fromJson(jsonDecode(str));
      } else if (response.statusCode == 401) {
        await AuthApi().callLogoutApi();
        return UpazilaDropdownModel();
      } else {
        return UpazilaDropdownModel();
      }
    } catch (e) {
      print("Error getUpazillaDropdownApi: $e");
    }
    return null;
  }

  //to get union
  Future<UnionDropdownModel?> getUnionDropdownApi({required int upazilaId}) async {
    try {
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      final request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}/get-union/$upazilaId'));
      request.headers.addAll(headers);
      final response = await request.send();
      var str = await response.stream.bytesToString();

      print(response.statusCode);
      if (response.statusCode == 200) {
        return UnionDropdownModel.fromJson(jsonDecode(str));
      } else if (response.statusCode == 401) {
        await AuthApi().callLogoutApi();
        return UnionDropdownModel();
      } else {
        return UnionDropdownModel();
      }
    } catch (e) {
      print("Error UnionDropdown api: $e");
    }
    return null;
  }

  // Future<NonSelectedBeneficiaryListModel?> getNonSelectedBeneficiaryListApi({
  //   required List statusIdList,
  //   required int upazillaId,
  //    int? unionId,

  //   int? wardNo,
  //   required int pageNo,
  // }) async {
  //   try {
  //     print("upazillaId $upazillaId");
  //     print("unionId $unionId");
  //     print("pageNo $pageNo");
  //     String statusIds = jsonEncode(statusIdList);
  //     final String loginToken =
  //         await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
  //     var headers = {
  //       ApiConstant.accept: ApiConstant.acceptValue,
  //       ApiConstant.authorization: "Bearer $loginToken"
  //     };
  //     if (upazillaId != -10 || (unionId != null && wardNo != null)) {
  //       //final request = http.Request('GET',Uri.parse('${ApiConstant.baseUrl}/get-beneficiaries?status_id=$statusId&upazila_id=$upazillaId&union_id=$unionId&rows=15&page=$pageNo'));
  //       final request = http.Request(
  //           'GET',
  //           Uri.parse(
  //               '${ApiConstant.baseUrl}/get-beneficiaries?status_ids=$statusIds&upazila_id=$upazillaId&union_id=$unionId&ward_no=$wardNo&rows=15&page=$pageNo'));
  //       request.headers.addAll(headers);
  //       final response = await request.send();
  //       var str = await response.stream.bytesToString();
  //       print(response.statusCode);
  //       if (response.statusCode == 200) {
  //         return NonSelectedBeneficiaryListModel.fromJson(jsonDecode(str));
  //       } else {
  //         return NonSelectedBeneficiaryListModel();
  //       }
  //     } else if (upazillaId != -10) {
  //       //final request = http.Request('GET',Uri.parse('${ApiConstant.baseUrl}/get-beneficiaries?status_id=$statusId&upazila_id=$upazillaId&rows=15&page=$pageNo'));
  //       final request = http.Request(
  //           'GET',
  //           Uri.parse(
  //               '${ApiConstant.baseUrl}/get-beneficiaries?status_ids=$statusIds&upazila_id=$upazillaId&rows=15&page=$pageNo'));
  //       request.headers.addAll(headers);
  //       final response = await request.send();
  //       var str = await response.stream.bytesToString();
  //       print(response.statusCode);
  //       if (response.statusCode == 200) {
  //         return NonSelectedBeneficiaryListModel.fromJson(jsonDecode(str));
  //       } else {
  //         return NonSelectedBeneficiaryListModel();
  //       }
  //     } else if (unionId != -10) {
  //       //final request = http.Request('GET',Uri.parse('${ApiConstant.baseUrl}/get-beneficiaries?status_id=$statusId&union_id=$unionId&rows=15&page=$pageNo'));
  //       final request = http.Request(
  //           'GET',
  //           Uri.parse(
  //               '${ApiConstant.baseUrl}/get-beneficiaries?status_ids=$statusIds&union_id=$unionId&rows=15&page=$pageNo'));
  //       request.headers.addAll(headers);
  //       final response = await request.send();
  //       var str = await response.stream.bytesToString();
  //       print(response.statusCode);
  //       if (response.statusCode == 200) {
  //         return NonSelectedBeneficiaryListModel.fromJson(jsonDecode(str));
  //       } else {
  //         return NonSelectedBeneficiaryListModel();
  //       }
  //     } else if (upazillaId == -10 && unionId == -10) {
  //       //final request = http.Request('GET',Uri.parse('${ApiConstant.baseUrl}/get-beneficiaries?status_id=$statusId&rows=15&page=$pageNo'));
  //       final request = http.Request(
  //           'GET',
  //           Uri.parse(
  //               '${ApiConstant.baseUrl}/get-beneficiaries?status_ids=$statusIds&rows=15&page=$pageNo'));
  //       request.headers.addAll(headers);
  //       final response = await request.send();
  //       var str = await response.stream.bytesToString();
  //       print(response.statusCode);
  //       //print(str);
  //       if (response.statusCode == 200) {
  //         return NonSelectedBeneficiaryListModel.fromJson(jsonDecode(str));
  //       } else {
  //         return NonSelectedBeneficiaryListModel();
  //       }
  //     }
  //   } catch (e) {
  //     print("Error non selected beneficiary list: $e");
  //   }
  //   return null;
  // }
  Future<NonSelectedBeneficiaryListModel?> getNonSelectedBeneficiaryListApi({
    required List statusIdList,
    int? upazillaId,
    int? unionId,
    int? wardNo,
    bool isSearch = false,
    String? phoneOrLe,
    required int pageNo,
    // required int rows,
  }) async {
    try {
      print("upazillaId $upazillaId");
      print("unionId $unionId");
      //print("pageNo $pageNo");
      String statusIds = jsonEncode(statusIdList);
      String uri =
          '${ApiConstant.baseUrl}/get-beneficiaries?status_ids=$statusIds&rows=15&page=$pageNo'; //&upazila_id=$upazillaId&union_id=$unionId&ward_no=$wardNo

      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      if (upazillaId != null) {
        //&union_id=$unionId&ward_no=$wardNo
        uri = '$uri&upazila_id=$upazillaId';
      }
      if (unionId != null) {
        //&union_id=$unionId&ward_no=$wardNo
        uri = '$uri&union_id=$unionId';
      }
      if (wardNo != null) {
        uri = '$uri&ward_no=$wardNo';
      }
      if (phoneOrLe != null) {
        uri = '$uri&search=$phoneOrLe';
      }
      final request = http.Request('GET', Uri.parse(uri));
      request.headers.addAll(headers);
      final response = await request.send();
      var str = await response.stream.bytesToString();
      var json = jsonDecode(str);
      log('message$str');
      print(response.statusCode);
      if (response.statusCode == 200) {
        return NonSelectedBeneficiaryListModel.fromJson(jsonDecode(str));
      } else {
        return NonSelectedBeneficiaryListModel();
      }
      // if (upazillaId != null && unionId != null && wardNo != null) {
      //   //final request = http.Request('GET',Uri.parse('${ApiConstant.baseUrl}/get-beneficiaries?status_id=$statusId&upazila_id=$upazillaId&union_id=$unionId&rows=15&page=$pageNo'));
      //   final request = http.Request(
      //       'GET',
      //       Uri.parse(
      //           '${ApiConstant.baseUrl}/get-beneficiaries?status_ids=$statusIds&upazila_id=$upazillaId&union_id=$unionId&ward_no=$wardNo'));//&rows=15&page=$pageNo
      //   request.headers.addAll(headers);
      //   final response = await request.send();
      //   var str = await response.stream.bytesToString();
      //    log('message$str');
      //   print(response.statusCode);
      //   if (response.statusCode == 200) {
      //     return NonSelectedBeneficiaryListModel.fromJson(jsonDecode(str));
      //   } else {
      //     return NonSelectedBeneficiaryListModel();
      //   }
      // } else if (upazillaId != null && (unionId == null && wardNo == null)) {
      //   //final request = http.Request('GET',Uri.parse('${ApiConstant.baseUrl}/get-beneficiaries?status_id=$statusId&rows=15&page=$pageNo'));
      //   final request = http.Request(
      //       'GET', Uri.parse('${ApiConstant.baseUrl}/get-beneficiaries?status_ids=$statusIds&upazila_id=$upazillaId')); //&rows=15&page=$pageNo
      //   request.headers.addAll(headers);
      //   final response = await request.send();
      //   var str = await response.stream.bytesToString();
      //   log('message$str');
      //   print(response.statusCode);
      //   //print(str);
      //   if (response.statusCode == 200) {
      //     return NonSelectedBeneficiaryListModel.fromJson(jsonDecode(str));
      //   } else {
      //     return NonSelectedBeneficiaryListModel();
      //   }
      // } else if ((upazillaId != null && unionId != null) && wardNo == null) {
      //   final request = http.Request(
      //       'GET',
      //       Uri.parse(
      //           '${ApiConstant.baseUrl}/get-beneficiaries?status_ids=$statusIds&upazila_id=$upazillaId&union_id=$unionId'));//&rows=15&page=$pageNo
      //   request.headers.addAll(headers);
      //   final response = await request.send();
      //   var str = await response.stream.bytesToString();
      //   log('message$str');
      //   print(response.statusCode);
      //   //print(str);
      //   if (response.statusCode == 200) {
      //     return NonSelectedBeneficiaryListModel.fromJson(jsonDecode(str));
      //   } else {
      //     return NonSelectedBeneficiaryListModel();
      //   }
      // } else if (upazillaId == null && unionId == null && wardNo == null) {
      //   final request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}/get-beneficiaries?status_ids=$statusIds'));//changes//&rows=15&page=$pageNo
      //   request.headers.addAll(headers);
      //   final response = await request.send();
      //   var str = await response.stream.bytesToString();
      //   log('message$str');
      //   print(response.statusCode);
      //   //print(str);
      //   if (response.statusCode == 200) {
      //     return NonSelectedBeneficiaryListModel.fromJson(jsonDecode(str));
      //   } else {
      //     return NonSelectedBeneficiaryListModel();
      //   }
      // }
    } catch (e) {
      print("Error non selected beneficiary list: $e");
    }
    return null;
  }

  // le beneficiary select api
  Future<String> selectBeneficiary({
    required int beneficiaryId,
  }) async {
    try {
      String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
      var request = http.Request('POST', Uri.parse('${ApiConstant.baseUrl}/selected-beneficiaries'));
      request.body = json.encode({
        "ids": [beneficiaryId]
      });

      request.headers.addAll(headers);
      print(request.body);

      http.StreamedResponse response = await request.send();
      var str = await response.stream.bytesToString();
      var jsonMap = jsonDecode(str);
      List<dynamic> alreadySelectedList = jsonMap['data']['already_selected'];
      List<dynamic> selectedList = jsonMap['data']['selected'];

      print("response.statusCode ${response.statusCode}");
      if (response.statusCode == 200) {
        if (selectedList.isNotEmpty) {
          CustomSnackBar(message: "সফলভাবে সিলেক্ট করা হয়েছে", isSuccess: true).show();
          return "200";
        } else if (alreadySelectedList.isNotEmpty) {
          CustomSnackBar(message: "ইতিমধ্যে পরিবারটি সিলেক্ট করা হয়েছে", isSuccess: false).show();
          return "300";
        } else {
          return '500';
        }
      } else if (response.statusCode == 401) {
        await AuthApi().callLogoutApi();
        return "401";
      } else {
        CustomSnackBar(message: "Server error", isSuccess: false);
        return "0";
      }
    } catch (e) {
      CustomSnackBar(message: "Error: $e", isSuccess: false);
      if (kDebugMode) {
        print("Error: $e");
      }
      return e.toString();
    }
  }

  // generate otp
  Future<String> generateOtp({
    required int beneficiaryId,
  }) async {
    try {
      String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
      var request = http.Request('POST', Uri.parse('${ApiConstant.baseUrl}/generate-otp'));
      request.body = json.encode({"id": beneficiaryId});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var str = await response.stream.bytesToString();
      print("response.statusCode ${response.statusCode}");
      if (response.statusCode == 200) {
        CustomSnackBar(message: "আপনার গ্রাহকের মোবাইলে একটি OTP পাঠানো হয়েছে!", isSuccess: true).show();
        print(jsonDecode(str)["message"]);

        return "200";
      } else {
        CustomSnackBar(message: jsonDecode(str)["message"], isSuccess: false).show();
        return "0";
      }
    } catch (e) {
      CustomSnackBar(message: "Error: $e", isSuccess: false);
      if (kDebugMode) {
        print("Error: $e");
      }
      return e.toString();
    }
  }

  // verify otp
  Future<String> verifyOtp({
    required int beneficiaryId,
    required String otp,
  }) async {
    try {
      String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
      var request = http.Request('POST', Uri.parse('${ApiConstant.baseUrl}/verify-otp'));
      request.body = json.encode({"id": beneficiaryId, "otp": otp});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var str = await response.stream.bytesToString();
      var jsonres = jsonDecode(str);
      print("response.statusCode ${response.statusCode}");
      if (response.statusCode == 200) {
        CustomSnackBar(message: "OTP ভেরিফাইড", isSuccess: true).show();
        return "200";
      } else {
        CustomSnackBar(message: jsonres['message'], isSuccess: false).show();
        return "0";
      }
    } catch (e) {
      CustomSnackBar(message: "Error: $e", isSuccess: false).show();
      if (kDebugMode) {
        print("Error: $e");
      }
      return e.toString();
    }
  }

  Future<List<DlcQuestionModel>> getLEQuestions() async {
    bool questionsFromAPi = false;
    List<DlcQuestionModel> getLeQuesList = [];
    List<DlcQuestionModel> vargetDlc = [];
    try {
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      final request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.getLEQuestions}'));
      request.headers.addAll(headers);
      final response = await request.send();
      var str = await response.stream.bytesToString();

      jsonDecode(str).forEach((element) {
        getLeQuesList.add(DlcQuestionModel.fromJson(element));
      });
      if (response.statusCode == 200) {
        questionsFromAPi = true;

        return getLeQuesList;
      } else {
        getLeQuesList = [];
        questionsFromAPi = false;
        //  return questionsFromAPi;
        // CustomSnackBar(message: "Server error", isSuccess: false).show();
      }
    } catch (e) {
      questionsFromAPi = false;
      print(e);
    }
    return getLeQuesList;
  }

  // le answer qsn api
  // Future<String> leAnsQsnPost(
  //     {required int beneficiaryId,
  //     required List<LeAnsModel> ansList,
  //     required int ans1,
  //     required int ans2,
  //     required int ans3,
  //     required int ans4,
  //     required int ans5,
  //     required int ans6,
  //     required String lat,
  //     required String long,
  //     required String image}) async {
  //   try {
  //     String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
  //     var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
  //     var request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}/le-question-answers'));
  //     request.fields.addAll({
  //       "beneficiary_id": beneficiaryId.toString(),
  //      "question_answer": jsonEncode(object)
  //       // 'questions[0][question_id]': ' 1',
  //       // 'questions[0][answer]': ans1.toString(),
  //       // 'questions[1][question_id]': ' 2',
  //       // 'questions[1][answer]': ans2.toString(),
  //       // 'questions[2][question_id]': ' 3',
  //       // 'questions[2][answer]': ans3.toString(),
  //       // 'questions[3][question_id]': ' 4',
  //       // 'questions[3][answer]': ans4.toString(),
  //       // 'questions[4][question_id]': ' 5',
  //       // 'questions[4][answer]': ans5.toString(),
  //       // 'questions[5][question_id]': ' 6',
  //       // 'questions[5][answer]': ans6.toString(),
  //       "lat": lat,
  //       "long": long,
  //       // "image": image
  //     });
  //     request.files.add(await http.MultipartFile.fromPath('image', image));
  //     request.headers.addAll(headers);
  //     //print(request.body);

  //     http.StreamedResponse response = await request.send();
  //     var str = await response.stream.bytesToString();
  //     print(
  //         "response.statusCode ${response.statusCode}"); //{"message":"Call to undefined function Intervention\\Image\\Gd\\imagecreatefromjpeg()","data":[],"status":400}
  //     print("response ${response}");
  //     if (response.statusCode == 200) {
  //       CustomSnackBar(message: "প্রশ্নের উত্তরগুলো সাবমিট করা হয়েছে", isSuccess: true).show();
  //       return "200";
  //     } else {
  //       CustomSnackBar(message: "সার্ভার জনিত সমস্যা", isSuccess: false);
  //       return "0";
  //     }
  //   } catch (e) {
  //     CustomSnackBar(message: "Error: $e", isSuccess: false);
  //     if (kDebugMode) {
  //       print("Error: $e");
  //     }
  //     return e.toString();
  //   }
  // }

  //newLeQuest
  Future<String> newLeQuestionAnswerSubmit(
      {required int beneficiaryId,
      required String jsonAnswer,
      //required List<DlcQAnsModel> leQuestionData,
      required String lat,
      required String long,
      required String image}) async {
    try {
      String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}/le-question-answers'));
      request.fields.addAll({
        "beneficiary_id": beneficiaryId.toString(),
        "question_answer": jsonAnswer,
        "lat": lat,
        "long": long,
        // "image": image
      });
      request.files.add(await http.MultipartFile.fromPath('image', image));
      request.headers.addAll(headers);
      //print(request.body);

      http.StreamedResponse response = await request.send();
      var str = await response.stream.bytesToString();
      print(
          "response.statusCode ${response.statusCode}"); //{"message":"Call to undefined function Intervention\\Image\\Gd\\imagecreatefromjpeg()","data":[],"status":400}
      print("response ${response}");
      if (response.statusCode == 200) {
        CustomSnackBar(message: "প্রশ্নের উত্তরগুলো সাবমিট করা হয়েছে", isSuccess: true).show();
        return "200";
      } else {
        CustomSnackBar(message: "সার্ভার জনিত সমস্যা", isSuccess: false).show();
        return "0";
      }
    } catch (e) {
      CustomSnackBar(message: "Error: $e", isSuccess: false);
      if (kDebugMode) {
        print("Error: $e");
      }
      return e.toString();
    }
  }

  Future<String> submitUpdatedScreening({
    required int beneficiaryId,
    required List<LeUpdScrnAnswer> leQuestionData,
  }) async {
    try {
      String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}/update-le-question-answers'));
      request.fields.addAll({
        "beneficiary_id": beneficiaryId.toString(),
        "question_answer": jsonEncode(leQuestionData),
      });

      request.headers.addAll(headers);
      //print(request.body);

      http.StreamedResponse response = await request.send();
      var str = await response.stream.bytesToString();
      print(
          "response.statusCode ${response.statusCode}-${str}"); //{"message":"Call to undefined function Intervention\\Image\\Gd\\imagecreatefromjpeg()","data":[],"status":400}
      print("response ${response}");
      if (response.statusCode == 200) {
        CustomSnackBar(message: "প্রশ্নের উত্তরগুলো সম্পাদিত হয়েছে", isSuccess: true).show();
        return "200";
      } else {
        CustomSnackBar(message: "সার্ভার জনিত সমস্যা", isSuccess: false);
        return "0";
      }
    } catch (e) {
      CustomSnackBar(message: "Error: $e", isSuccess: false);
      if (kDebugMode) {
        print("Error: $e");
      }
      return e.toString();
    }
  }

  Future<List<LeGivenAnswerModel>?> getLeGivenQuestion({
    required int id,
  }) async {
    http.Request request;
    try {
      List<LeGivenAnswerModel> leGivenQuestionModel = [];
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}/le-answer-question-reports/$id'));

      request.headers.addAll(headers);
      final response = await request.send();
      var str = await response.stream.bytesToString();
      var jsonMap = jsonDecode(str);
      if (response.statusCode == 200) {
        for (var element in jsonMap) {
          leGivenQuestionModel.add(LeGivenAnswerModel.fromJson(element));
        }

        return leGivenQuestionModel;
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

  //new beneficiary get
  Future<LEBeneficiaryModel?> getBeneficiaryDataByID(int benfID) async {
    //String uri = '${ApiConstant.baseUrl}/get-beneficiaries/$benfID';
    final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
    var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
    final request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}/beneficiaries/$benfID'));
    request.headers.addAll(headers);
    final response = await request.send().timeout(Duration(seconds: 120));
    var str = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return LEBeneficiaryModel.fromJson(jsonDecode(str));
    } else {
      return null;
    }
  }

  // le photo submission

  Future<String> lePhotoSubmission(
      {required int beneficiaryId,
      dynamic latitude,
      dynamic longitude,
      dynamic latitude2,
      dynamic longitude2,
      int index = -1,
      String? step1,
      String? step2,
      String? step3,
      String? step4,
      String? step5}) async {
    try {
      String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}/twin-pit-construction'));
      request.fields.addAll({'beneficiary_id': beneficiaryId.toString()});
     
        if (latitude2 != null) {
          request.fields.addAll({
            'pit_latitude': latitude2,
          });
        }

        if (longitude2 != null) {
          request.fields.addAll({'pit_longitude': longitude2});
        }
  
        if (latitude != null) {
          request.fields.addAll({
            'latitude': latitude,
          });
        }

        if (longitude != null) {
          request.fields.addAll({'longitude': longitude});
        }
      

      if (step1 != null) {
        request.files.add(await http.MultipartFile.fromPath('step_1', step1));
      }
      if (step2 != null) {
        request.files.add(await http.MultipartFile.fromPath('step_2', step2));
      }
      if (step3 != null) {
        request.files.add(await http.MultipartFile.fromPath('step_3', step3));
      }
      if (step4 != null) {
        request.files.add(await http.MultipartFile.fromPath('step_4', step4));
      }
      if (step5 != null) {
        request.files.add(await http.MultipartFile.fromPath('step_5', step5));
      }

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send().timeout(Duration(seconds: 120));
      var str = await response.stream.bytesToString();
      log('image res $str');
      print("response.statusCode ${response.statusCode}");
      if (response.statusCode == 200) {
        CustomSnackBar(message: "Photo Submitted", isSuccess: false);
        return "200";
      } else if (response.statusCode == 400) {
        CustomSnackBar(message: jsonDecode(str)['message'], isSuccess: false).show();
        return "400";
      } else {
        CustomSnackBar(message: "Server error", isSuccess: false);
        return "500";
      }
    } on TimeoutException catch (e) {
      CustomSnackBar(message: "Connection Timed out,Please Try again Later", isSuccess: false).show();
      return "500";
    } catch (e) {
      //if (kDebugMode) {
      print("Error: $e");
      // }
      return e.toString();
    }
  }

  //to get union
  Future<LatrineImageResponseModel?> getLatrineImages({required int beneficiaryId}) async {
    try {
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      final request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}/latrine-progress-images/$beneficiaryId'));
      request.headers.addAll(headers);
      final response = await request.send().timeout(Duration(seconds: 130));
      var str = await response.stream.bytesToString();
      log('${str.toString()}');
      print(response.statusCode);
      if (response.statusCode == 200) {
        return LatrineImageResponseModel.fromJson(jsonDecode(str));
      } else if (response.statusCode == 401) {
        await AuthApi().callLogoutApi();
        return LatrineImageResponseModel();
      } else {
        return LatrineImageResponseModel();
      }
    } on TimeoutException catch(_){
      return LatrineImageResponseModel(data: null);

    } catch (e) {
      print("Error image api: $e");
    }
    return null;
  }

  Future<String> constructionComplete({required int beneficiaryId, required String junction}) async {
    try {
      String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
      var request = http.Request('POST', Uri.parse('${ApiConstant.baseUrl}/construction-complete'));
      request.body = json.encode({"beneficiary_id": beneficiaryId, "junction": junction});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var str = await response.stream.bytesToString();
      print("response.statusCode ${response.statusCode}");
      if (response.statusCode == 200) {
        CustomSnackBar(message: "নির্মাণ সম্পন্ন হয়েছে", isSuccess: true).show(); //Construction Completed
        return "200";
      } else {
        CustomSnackBar(message: jsonDecode(str)['message'], isSuccess: false).show();
        return "0";
      }
    } catch (e) {
      CustomSnackBar(message: "Error: $e", isSuccess: false).show();
      if (kDebugMode) {
        print("Error: $e");
      }
      return e.toString();
    }
  }

   Future<bool> recheckInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(Duration(seconds: 6));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }else{
        return Future.value(false);
      }
    }on TimeoutException catch (_){
      return Future.value(false);
    } on SocketException catch (_) {
      return Future.value(false);
    }
    
  }

}
