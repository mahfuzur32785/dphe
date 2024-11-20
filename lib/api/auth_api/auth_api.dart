import 'dart:async';
import 'dart:convert';

import 'package:dphe/Data/models/auth_models/citizen_login_model.dart';
import 'package:dphe/offline_database/db_tables/le_tables/beneficiary_list_table.dart';
import 'package:dphe/offline_database/db_tables/union_table.dart';
import 'package:dphe/provider/hive_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../components/custom_snackbar/custom_snakcbar.dart';
import '../../Data/models/auth_models/login_response_model.dart';
import '../../Data/models/auth_models/logout_response_model.dart';
import '../../screens/auth/login_screen.dart';
import '../../utils/api_constant.dart';
import '../../utils/app_constant.dart';
import '../../utils/global_keys.dart';
import '../../utils/local_storage_manager.dart';
import 'dart:developer';

class AuthApi {
  Future<LoginResponseModel?> callLoginAPi({String? email, String? phone, required String? password}) async {
    log('base url ${ApiConstant.baseUrl}');
    try {
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.loginRoute}'),);
      if (email != null) {
        request.fields.addAll({'email': email.trim(), 'password': password!.trim()});
      } else {
        request.fields.addAll({'phone': phone!.trim(), 'password': password!.trim()});
      }

      http.StreamedResponse response = await request.send().timeout(Duration(seconds: 120));

      var str = await response.stream.bytesToString();
      //print("response.statusCode ${response.statusCode}");
      if (response.statusCode == 200) {
        log('${LoginResponseData.fromJson(jsonDecode(str)["data"]).token}');
        log('user Data ${str}');
        //sharedPreference(LogInModel.fromJson(str));
        // print(str);
        // print(LoginResponseData.fromJson(jsonDecode(str)["data"]).token);
        // print(LoginResponseData.fromJson(jsonDecode(str)["data"]).user!.type);

        LocalStorageManager.saveData(ApiConstant.loginToken, LoginResponseData.fromJson(jsonDecode(str)["data"]).token);
        LocalStorageManager.saveData(ApiConstant.userID, LoginResponseData.fromJson(jsonDecode(str)["data"]).user!.id);
        LocalStorageManager.saveData(AppConstant.userType, LoginResponseData.fromJson(jsonDecode(str)["data"]).user!.type);
        LocalStorageManager.saveData(AppConstant.designaton, LoginResponseData.fromJson(jsonDecode(str)["data"]).user!.designation?.name);

        LocalStorageManager.saveData(AppConstant.userName, LoginResponseData.fromJson(jsonDecode(str)["data"]).user!.name);
        LocalStorageManager.saveData(AppConstant.userEmail, LoginResponseData.fromJson(jsonDecode(str)["data"]).user!.email ?? "");
        LocalStorageManager.saveData(AppConstant.userPhone, LoginResponseData.fromJson(jsonDecode(str)["data"]).user!.phone ?? "");
        //LocalStorageManager.saveData(AppConstant.userDivisionId, LoginResponseData.fromJson(jsonDecode(str)["data"]).user!.divisionId??-1);
        LocalStorageManager.saveData(AppConstant.userDistrictId, LoginResponseData.fromJson(jsonDecode(str)["data"]).user!.districtId ?? -1);
        LocalStorageManager.saveData(AppConstant.userUpazilaId, LoginResponseData.fromJson(jsonDecode(str)["data"]).user!.upazilaId ?? -1);
        LocalStorageManager.saveData(AppConstant.userUnionId, LoginResponseData.fromJson(jsonDecode(str)["data"]).user!.unionId ?? -1);
        LocalStorageManager.saveData(AppConstant.userUnionId, LoginResponseData.fromJson(jsonDecode(str)["data"]).user!.unionId ?? -1);
        LocalStorageManager.saveData(AppConstant.userPhoto, LoginResponseData.fromJson(jsonDecode(str)["data"]).user?.photoUrl ?? "");

        LocalStoreHiveProvider()
            .storeUserPermission(permissions: jsonEncode(LoginResponseData.fromJson(jsonDecode(str)["data"]).user?.permissions ?? ''));

        var district = LoginResponseData.fromJson(jsonDecode(str)["data"]).user?.districts;

        LocalStorageManager.saveData(AppConstant.districts, jsonEncode(district));
        log(jsonEncode(district));
        var upazillas = LoginResponseData.fromJson(jsonDecode(str)["data"]).user?.upazilas;
        LocalStorageManager.saveData(AppConstant.upazillas, jsonEncode(upazillas));

        //await UserApi().getUserDetailsApi();jsonen
        CustomSnackBar(message: "Logged in Successfully", isSuccess: true).show();
        return LoginResponseModel(
            statusCode: jsonDecode(str)["status_code"], status: jsonDecode(str)["status"], data: LoginResponseData.fromJson(jsonDecode(str)["data"]));
      } else {
        //CustomSnackBar(message: jsonDecode(str)["message"], isSuccess: false).show();
        //return LoginResponseModel();
       // log('Message ${jsonDecode(str)["message"]}');
        return LoginResponseModel.fromJson(jsonDecode(str));
      }
    } on TimeoutException catch(_){
      CustomSnackBar(message: 'Connection Time out', isSuccess: false).show();
    } catch (e) {
      print("Error: $e");
      CustomSnackBar(message: 'Cannot Access the Login server', isSuccess: false).show();
      //return LoginResponseModel( accessToken: e.toString());
      return LoginResponseModel(
        statusCode: 500,
      );
    }
    return null;
  }

  Future<CitizenLoginModel?> citizenLoginApi({required String phone, required String deviceID}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.citizenLoginRoute}'),);
        request.fields.addAll({'mobile': phone.trim(), 'device_id': deviceID});

      http.StreamedResponse response = await request.send().timeout(const Duration(seconds: 120));
      log('base url ${phone}');
      log('base url ${deviceID}');
      var str = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        // log('user Data ${str}');
        LocalStorageManager.saveData(ApiConstant.citizenUserID, CitizenLoginModel.fromJson(jsonDecode(str)).data?.id);
        LocalStorageManager.saveData(ApiConstant.citizenUserPhone, CitizenLoginModel.fromJson(jsonDecode(str)).data?.mobile);

        return CitizenLoginModel.fromJson(jsonDecode(str));
      } else {
        return CitizenLoginModel.fromJson(jsonDecode(str));
      }
    } on TimeoutException catch(_){
      CustomSnackBar(message: 'Connection Time out', isSuccess: false).show();
    } catch (e) {
      print("Error: $e");
      return null;
    }
    return null;
  }

  Future<Map<String, dynamic>?> otpVerify({required String phone, required String otp, required String deviceID}) async {
    // try {
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.citizenOtpVerify}'),);
        request.fields.addAll({'mobile': phone.trim(), 'device_id': deviceID, 'otp': otp});

      http.StreamedResponse response = await request.send().timeout(const Duration(seconds: 120));

      var str = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return jsonDecode(str);
      } else {
        CustomSnackBar(message: jsonDecode(str)['message'], isSuccess: true).show();
        return jsonDecode(str);
      }
    // }
    // on TimeoutException catch(_){
    // } catch (e) {
    //   print("Error: $e");
    //   CustomSnackBar(message: jsonDecode(str)['message'], isSuccess: true).show();
    //   return null;
    // }
    return null;
  }

  Future<ChangePassModel?> changePassword({
    required String currentPass,
    required String newPass,
    required String passwordConfirmation,
  }) async {
    String responseString = "";
    ChangePassModel? changePassModel;
    try {
      String userToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {
        ApiConstant.contentType: ApiConstant.contentTypeValue,
        ApiConstant.accept: ApiConstant.contentTypeValue,
        ApiConstant.authorization: "Bearer $userToken"
      };
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.changePassword}'));
      request.fields.addAll({
        "current_password": currentPass,
        "password": newPass,
        "password_confirmation": passwordConfirmation,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var str = await response.stream.bytesToString();
      log('$str');
      var jsonRes = jsonDecode(str);
      if (response.statusCode == 200) {
        changePassModel = ChangePassModel(changePassMessage:  jsonRes['message'],statusCode:  response.statusCode);
        //responseString = str;
      } else {
        changePassModel = ChangePassModel(changePassMessage:  jsonRes['message'],statusCode:  response.statusCode);
      }
      return changePassModel;
    } on Exception catch (e) {
      responseString = 'error';
      CustomSnackBar(message: 'Error Occurred', isSuccess: false).show();
      return changePassModel;
    }
  }

   Future<ChangePassModel?> forgetPassword({
    required String email,
  
  }) async {
    String responseString = "";
    ChangePassModel? changePassModel;
    try {
     // String userToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
      var headers = {
        ApiConstant.contentType: ApiConstant.contentTypeValue,
        ApiConstant.accept: ApiConstant.contentTypeValue,
       // ApiConstant.authorization: "Bearer $userToken"
      };
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}${ApiConstant.forgetPassword}'));
      request.fields.addAll({
        "email": email,
       
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var str = await response.stream.bytesToString();
      log('$str');
      var jsonRes = jsonDecode(str);
      if (response.statusCode == 200) {
        changePassModel = ChangePassModel(changePassMessage:  jsonRes['message'],statusCode:  response.statusCode);
        //responseString = str;
      } else {
        changePassModel = ChangePassModel(changePassMessage:  jsonRes['message'],statusCode:  response.statusCode);
      }
      return changePassModel;
    } on Exception catch (e) {
      responseString = 'error';
      CustomSnackBar(message: 'Error Occurred', isSuccess: false).show();
      return changePassModel;
    }
  }

  //logout api call
  Future<LogoutResponseModel?> callLogoutApi({BuildContext? context}) async {
    try {
      String userToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
       String userType = await LocalStorageManager.readData(AppConstant.userType) ?? "";
      //print("User token : $userToken");
      var headers = {
        // ApiConstant.contentType: ApiConstant.acceptValue,
        ApiConstant.authorization: 'Bearer $userToken'
      };

      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstant.baseUrl}/logout'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send().timeout(Duration(seconds: 10));
      var str = await response.stream.bytesToString();
      print(response.statusCode);
      if (response.statusCode == 200) {
        
         if (userType == 'le') {
            BeneficiaryListTable().deleteNonSelectedBenficiaries(6);
         }
        deleteUserData();
        
        LocalStoreHiveProvider().deleteAllPermission();
        UnionTable().deleteUnionTable();
        CustomSnackBar(message: "Logged out successfully", isSuccess: true).show();
        //if (context.mounted) {
        // navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.loginRoute,(route) => false,);
        // }

        return LogoutResponseModel(
            status: jsonDecode(str)["status"], statusCode: jsonDecode(str)["status_code"], message: jsonDecode(str)["message"]);
      } else if (response.statusCode == 401) {
        //if token is not validate or expired
        deleteUserData();
         UnionTable().deleteUnionTable();
         
        LocalStoreHiveProvider().deleteAllPermission();
        CustomSnackBar(message: "Logged out successfully", isSuccess: true).show();
        // navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.loginRoute,(route) => false,);
        //   if (context.mounted) {
        //    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
        // }
        navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
        return LogoutResponseModel();
      } else {
        deleteUserData();
         UnionTable().deleteUnionTable();
          if (userType == 'le') {
            BeneficiaryListTable().deleteNonSelectedBenficiaries(6);
         }
          // BeneficiaryListTable().deleteNonSelectedBenficiaries(6);
       // BeneficiaryListTable().deleteNonSelectedBenficiaries(6);
        CustomSnackBar(message: "Logged out successfully", isSuccess: false).show();
        //if (context.mounted) {
        //  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
        //}
        // navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.loginRoute,(route) => false,);
        navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
        return LogoutResponseModel();
      }
    } on TimeoutException catch(_){
        navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
    } catch (e) {
      navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
      CustomSnackBar(message: e.toString(), isSuccess: false).show();
      return LogoutResponseModel(message: e.toString());
    }
    return null;
  }

  // //change password
  // Future<String> callResetPassAPi({required String email, required String otp, required String password, required String confirmPassword}) async {
  //   try {
  //     var headers = {ApiConstant.accept: ApiConstant.acceptValue};
  //     var request = http.MultipartRequest(
  //         'POST', Uri.parse('${ApiConstant.baseUrl}/change-password'));
  //     request.fields.addAll({
  //       'email': email,
  //       'otp': otp,
  //       'password': password,
  //       'confirm_password': confirmPassword
  //     });
  //
  //     request.headers.addAll(headers);
  //
  //     http.StreamedResponse response = await request.send();
  //     var str = await response.stream.bytesToString();
  //     //print("response.statusCode ${response.statusCode}");
  //     if (response.statusCode == 200) {
  //       CustomSnackBar(message: "Password updated successfully!", isSuccess: true).show();
  //       return "200";
  //     } else {
  //       CustomSnackBar(message: jsonDecode(str)["error"].toString(), isSuccess: false).show();
  //       return "Invalid email or Server Error";
  //     }
  //   } catch (e) {
  //     CustomSnackBar(message: e.toString(), isSuccess: false).show();
  //     return e.toString();
  //   }
  // }

  void deleteUserData() {
    LocalStorageManager.deleteData(ApiConstant.loginToken);
    LocalStorageManager.deleteData(AppConstant.userName);
    LocalStorageManager.deleteData(AppConstant.userEmail);
    LocalStorageManager.deleteData(AppConstant.userType);
    LocalStorageManager.deleteData(AppConstant.userPhone);
    LocalStorageManager.deleteData(AppConstant.userDivisionId);
    LocalStorageManager.deleteData(AppConstant.userDistrictId);
    LocalStorageManager.deleteData(AppConstant.userUpazilaId);
    LocalStorageManager.deleteData(AppConstant.userUnionId);
    LocalStorageManager.deleteData(AppConstant.userPhoto);
    LocalStorageManager.deleteData(AppConstant.designaton);
  }
}

class ChangePassModel {
  final String? changePassMessage;
  final int? statusCode;

  ChangePassModel({this.changePassMessage, this.statusCode});
}
