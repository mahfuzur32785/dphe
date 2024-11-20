import 'dart:convert';

import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';

import '../../../Data/models/common_models/dlc_model/package_data_model.dart';
import '../../../Data/models/common_models/dlc_model/package_scheme_model.dart';
import '../../../Data/models/common_models/dlc_model/progress_item_model.dart';
import '../../../Data/models/common_models/dlc_model/work_type_model.dart';
import '../../../utils/api_constant.dart';
import '../../../utils/local_storage_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class DlcReportApi {
  Future<PackageDataModel?> getPackageData() async {
    String responsMessage = '';
    PackageDataModel? packageDataModel;
    String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
    var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
    final request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}/package?'));
    

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var str = await response.stream.bytesToString();
    log(' $str');
    var json = jsonDecode(str);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // responsMessage = json["message"];
      packageDataModel = PackageDataModel.fromJson(json);
      return packageDataModel;
    } else if (response.statusCode == 409) {
      packageDataModel = PackageDataModel.fromJson(json);
      return packageDataModel;
      //{"status":"error","status_code":409,"message":"Leave already applied for this date"}
    } else {
      responsMessage = "Error";
      packageDataModel = null;
    }
    return packageDataModel;
  }

   Future<List<PackageSchemeModel>?> getSchemeData({required int id}) async {
    String responsMessage = '';
    List<PackageSchemeModel>? packageSchemeModel = [];
    String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
    var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
    final request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}/get-scheme/$id'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var str = await response.stream.bytesToString();
    log(' $str');
    var json = jsonDecode(str);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // responsMessage = json["message"];
      for (var element in json) {
         packageSchemeModel.add(PackageSchemeModel.fromJson(element)) ;
      }
     
      return packageSchemeModel;
    } else {
      responsMessage = "Error";
      CustomSnackBar(message: 'Connection Error',isSuccess: false).show();
      packageSchemeModel = null;
    }
    return packageSchemeModel;
  }

   Future<List<WorkTypeModel>?> getWorkType() async {
    String responsMessage = '';
    List<WorkTypeModel>? workList = [];
    String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
    var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
    final request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}/get-work-types'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var str = await response.stream.bytesToString();
    log(' $str');
    var json = jsonDecode(str);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // responsMessage = json["message"];
      for (var element in json) {
         workList.add(WorkTypeModel.fromJson(element)) ;
      }
     
      return workList;
    } else {
      responsMessage = "Error";
      CustomSnackBar(message: 'Connection Error',isSuccess: false).show();
      workList = null;
    }
    return workList;
  }

   Future<ProgressItemModel?> getProgressItemData({required int schemeTypeID}) async {
    String responsMessage = '';
    ProgressItemModel? progressItemModel;
    String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
    var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};
    final request = http.Request('GET', Uri.parse('${ApiConstant.baseUrl}/progress-item?scheme_type_id=$schemeTypeID'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var str = await response.stream.bytesToString();
    log(' $str');
    var json = jsonDecode(str);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // responsMessage = json["message"];
      progressItemModel = ProgressItemModel.fromJson(json);
      return progressItemModel;
    } else {
      responsMessage = "Error";
      progressItemModel = null;
    }
    return progressItemModel;
}

Future<void> submitReport()async{
 String loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
    var headers = {ApiConstant.contentType: ApiConstant.contentTypeValue, ApiConstant.authorization: "Bearer $loginToken"};

}
}
