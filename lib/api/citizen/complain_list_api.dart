import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dphe/Data/models/citizen/citizen_benificiary_model.dart';
import 'package:dphe/Data/models/citizen/complain_model.dart';
import 'package:dphe/utils/api_constant.dart';
import 'package:dphe/utils/local_storage_manager.dart';
import 'package:http/http.dart' as http;

class CitizenApi{

  Future<List<ComplainModel>?> getCitizenComplainApi() async {
    http.Request request;
    try {
      final citizenId = await LocalStorageManager.readData(ApiConstant.citizenUserID) ?? "";
      var headers = {ApiConstant.accept: ApiConstant.acceptValue};
      var url = Uri.parse('${ApiConstant.baseUrl}/citizen/get-complaints?citizen_id=$citizenId');
      request = http.Request('GET', url);
      print("Complain List url $url");
      request.headers.addAll(headers);
      final response = await request.send().timeout(const Duration(seconds: 15));
      var str = await response.stream.bytesToString();
      var jsonMap = jsonDecode(str);
      if (response.statusCode == 200) {
        return List<ComplainModel>.from(jsonMap.map((e) => ComplainModel.fromJson(e)));
      } else {
        return null;
      }
    } catch (e) {
      if (e is TimeoutException) {
        return null;
      }
      print(e);
    }
    return null;
  }

  Future<CitizenBeneficiaryModel?> getBeneficiaryDataApi({required String nid}) async {
    try {
      var headers = {ApiConstant.accept: ApiConstant.acceptValue};
      var url = Uri.parse('${ApiConstant.baseUrl}/citizen/beneficiary-check');
      var request = http.MultipartRequest('POST', url);
      print("Beneficiary Data url $url");
      request.headers.addAll(headers);
      request.fields.addAll({'nid': nid});

      final response = await request.send().timeout(const Duration(seconds: 15));
      var str = await response.stream.bytesToString();
      var jsonMap = jsonDecode(str);
      if (response.statusCode == 200 && jsonMap['success'] == true) {
        return CitizenBeneficiaryModel.fromJson(jsonMap['data']);
      } else {
        return null;
      }
    } catch (e) {
      if (e is TimeoutException) {
        return null;
      }
      print(e);
    }
    return null;
  }

  Future<String?> complainSubmitApi(
      {required String serviceId,
        String? beneficiaryId,
        required String name,
        required String address,
        required String subject,
        required String body,
        required String imagePath,
      }) async {
    try {
      final citizenId = await LocalStorageManager.readData(ApiConstant.citizenUserID) ?? "";
      final mobile = await LocalStorageManager.readData(ApiConstant.citizenUserPhone) ?? "";

      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}/citizen/submit-complaint'),);
      Map<String, String> data = {
        "citizen_id": "$citizenId",
        "work_type_id": serviceId,
        if (beneficiaryId != null && beneficiaryId.isNotEmpty && beneficiaryId != 'null') "beneficiary_id": beneficiaryId,
        "name": name,
        "mobile": "$mobile",
        "address": address,
        "subject": subject,
        "body": body
      };
      print("asjhdfdjh $data");
      request.fields.addAll(data);
      if (imagePath != "" && imagePath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'document', // This should be the parameter name expected by the API
          imagePath,
        ));
      }

      http.StreamedResponse response = await request.send().timeout(const Duration(seconds: 120));
      var str = await response.stream.bytesToString();
      log("akjdfkjasdhf ${jsonDecode(str)}");
      if (response.statusCode == 200) {
        return jsonDecode(str)['message'];
      } else {
        return null;
      }
    } on TimeoutException catch(_){
    } catch (e) {
      print("Error: $e");
      return null;
    }
    return null;
  }

  Future<Comment> commentSubmitApi({required String complainId, required String comment}) async {
      final citizenId = await LocalStorageManager.readData(ApiConstant.citizenUserID) ?? "";

      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}/citizen/submit-comment/$complainId'),);
      Map<String, String> data = {
        "citizen_id": "$citizenId",
        "comment": comment
      };
      print("asjhdfdjh $data");
      request.fields.addAll(data);

      http.StreamedResponse response = await request.send().timeout(const Duration(seconds: 120));
      var str = await response.stream.bytesToString();
      log("akjdfkjasdhf ${jsonDecode(str)}");
      if (response.statusCode == 200) {
        return Comment.fromJson(jsonDecode(str)['data']);
      }else{
        return Comment();
      }
  }
}