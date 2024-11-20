import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dphe/Data/models/common_models/hcppStatusModel.dart';
import 'package:http/http.dart' as http;
import '../../../Data/models/common_models/dlc_model/le_data_model.dart';
import '../../../components/custom_snackbar/custom_snakcbar.dart';
import '../../../utils/api_constant.dart';
import '../../../utils/local_storage_manager.dart';

class HcpHssFrwrdApi {
  Future<StatusWiseLeHousehldModel?> getstsWiseLEData(
      {required int districtID, required int upazilaID, required int statusID, bool isSearch = false, String? phoneOrLe}) async {
    try {
      final String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue, ApiConstant.authorization: "Bearer $loginToken"};
      final request = !isSearch
          ? http.Request('GET',
              Uri.parse('${ApiConstant.baseUrl}${ApiConstant.stsWiseLeHouseHold}?district_id=$districtID&upazila_id=$upazilaID&status_id=$statusID'))
          : http.Request(
              'GET',
              Uri.parse(
                  '${ApiConstant.baseUrl}${ApiConstant.stsWiseLeHouseHold}?district_id=$districtID&upazila_id=$upazilaID&status_id=$statusID&search=$phoneOrLe'));
      request.headers.addAll(headers);
      final response = await request.send().timeout(Duration(seconds: 5));
      var str = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return StatusWiseLeHousehldModel.fromJson(jsonDecode(str));
      } else {
        CustomSnackBar(message: "Server error", isSuccess: false).show();
      }
    } on TimeoutException catch (_) {
      CustomSnackBar(message: "Connection Timeout", isSuccess: false).show();
    } catch (e) {
      print(e);
    }
    return null;
  }

  //  Future<String> selectBeneficiary({
  //   required int beneficiaryId,
  // }) async {
  //   try {
  //     String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken)??"";
  //     var headers = {
  //       ApiConstant.contentType: ApiConstant.contentTypeValue,
  //       ApiConstant.authorization: "Bearer $loginToken"
  //     };
  //     var request = http.Request(
  //         'POST', Uri.parse('${ApiConstant.baseUrl}/selected-beneficiaries'));
  //     request.body = json.encode({
  //       "ids": [beneficiaryId]
  //     });

  //     request.headers.addAll(headers);
  //     print(request.body);

  //     http.StreamedResponse response = await request.send();
  //     var str = await response.stream.bytesToString();
  //     print("response.statusCode ${response.statusCode}");
  //     if (response.statusCode == 200) {
  //       CustomSnackBar(message: "Selected Successfully", isSuccess: true);
  //       return "200";
  //     }else if (response.statusCode == 401) {
  //       await AuthApi().callLogoutApi();
  //       return "401";
  //     } else {
  //       CustomSnackBar(message: "Server error", isSuccess: false);
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

  generateArrayJson(List<int> ids) {}

  Future<bool> selectForwardedData({
    List<int>? ids,
  }) async {
    bool isSuccess = false;
    try {
      String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.selectForwarded}'));
      //request.b
      request.headers.addAll(headers);
      // request.fields[];

      // int count = 0;

      for (var i = 0; i < ids!.length; i++) {
        request.fields['ids[$i]'] = '${ids[i]}';
      }

      http.StreamedResponse response = await request.send().timeout(Duration(seconds: 5));
      // var str = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responsData = await response.stream.bytesToString();
        isSuccess = true;
        log('res $responsData');
      } else {
        isSuccess = false;
      }
    } on TimeoutException catch (_) {
      CustomSnackBar(message: 'Connection Timeout', isSuccess: false).show();
    } catch (e) {
      print(e.toString());
    }

    //  var json = jsonDecode(str);
    return isSuccess;
  }

   Future<bool> sendBackselectedData({
    List<int>? ids,
  }) async {
    bool isSuccess = false;
    try {
      String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.selectSendback}'));
      //request.b
      request.headers.addAll(headers);
      // request.fields[];

      // int count = 0;

      for (var i = 0; i < ids!.length; i++) {
        request.fields['ids[$i]'] = '${ids[i]}';
      }

      http.StreamedResponse response = await request.send().timeout(Duration(seconds: 5));
      // var str = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responsData = await response.stream.bytesToString();
        isSuccess = true;
        log('res $responsData');
      } else {
        isSuccess = false;
      }
    } on TimeoutException catch (_) {
      CustomSnackBar(message: 'Connection Timeout', isSuccess: false).show();
    } catch (e) {
      print(e.toString());
    }

    //  var json = jsonDecode(str);
    return isSuccess;
  }

  Future<http.Response> sendSelectedForwarded(List<int>? ids) async {
    String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
    var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
    var request = http.post(Uri.parse('${ApiConstant.baseUrl}${ApiConstant.selectForwarded}'),
        body: jsonEncode({for (int i = 0; i < ids!.length; i++) 'ids[$i]': ids[i]}), headers: headers);
    return request;
  }

  getforwardDio(List<int>? ids) async {
    final dio = Dio();
    // FormData formData = FormData();
    String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";

    final formData = Map<String, dynamic>();

    // Add each value to the FormData as ids[0], ids[1], ...
    for (int i = 0; i < ids!.length; i++) {
      formData['ids[$i]'] = ids[i];
    }
    // Add each value to the FormData as ids[0], ids[1], ...
    // for (int i = 0; i < ids.length; i++) {
    //   formData['ids[$i]'] = ids[i];
    // }
    // for (var i = 0; i < ids!.length; i++) {
    //   formData = FormData.fromMap({
    //     'ids[$i]': ids[i],
    //   });
    // }

    final response = await dio.post(
      '${ApiConstant.baseUrl}${ApiConstant.selectForwarded}',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $loginToken',
        },
      ),
    );
    log('${response.data}');
  }
}
