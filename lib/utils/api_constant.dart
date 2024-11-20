import 'dart:core';

class ApiConstant{
  //static const String baseUrl = " http://192.168.10.125:80/api"; //local
   //static const String baseUrl = "http://192.168.68.113:8000/api"; //jewel vai local
 //static const String baseUrl = "http://192.168.10.171:80/api";
  //static const String baseUrl = "http://192.168.68.123:8000/api";
  //static const String baseUrl = "http://118.179.149.36:8081/api";

 static const String baseUrl = "http://165.232.182.172:8000/api"; //live server
  //static const String baseUrl = "http://192.168.10.43:8000/api";
 // static const String baseUrl = "http://192.168.10.117:8080/api/v1"; //local
 // static const String imageBaseUrl = "http://167.71.226.75:8080";
  //static const String paymentBaseUrl = "http://192.168.10.48:4001/api/v1";
  // static const String paymentBaseUrl = "http://167.71.226.75:8080/api/v1";
  // static const String nidUrlTest = "https://api.porichoybd.com/sandbox-api/v2/verifications/autofill";
  // static const String nidUrlLive = "https://api.porichoybd.com/api/v2/verifications/autofill";

  static const String accept = "Accept";
  static const String acceptValue = "application/json";
  static const String contentType = "Content-Type";
  static const String contentTypeValue = "application/json";
  static const String authorization = "Authorization";
  static const String patToken = 'patToken';

  //ApiRoutes
  static const String loginRoute = "/auth/app-signin";
  static const String citizenLoginRoute = "/citizen/signin";
  static const String citizenOtpVerify = "/citizen/otp-verify";
  static const String changePassword = "/update-password";
  static const String forgetPassword = "/forget-password";
  static const String upazilaRoute = "/get-upazila/";
  static const String unionRoute = "/get-union/";
  static const String beneficiariesRoute = "/get-beneficiaries";
  static const String stsWiseLeHouseHold = "/status-wise-le-households";
  static const String statusRoute = "/get-status";
  static const String draftPhysicalVerify = "/household-draft-physical-verify";
  static const String selectForwarded = "/selected-forwarded";
   static const String selectSendback = "/selected-undo";
  static const String getDlcQuestions = "/get-dlc-questions";
  static const String getDlcQuesAnswer = "/dlc-question-answer";
  static const String sendBacklatrVerification = "/construction-send-back";
  static const String getLEQuestions = "/get-le-questions";
  static const String exenForLeave = "/get-district-wise-ExEn";
  static const String leaveRoute = "/leaves";
  static const String attendanceRoute = "/attendance";

  //dlc activities
  static const String dlcotheractivityRoute = '/assignments';



  static const String showDashboard = "showDashboard";
  static const String loginToken = "loginToken";
  static const String loginResponseData = "loginResponseData";
  static const String userID = "userid";
  static const String citizenUserID = "citizenUserID";
  static const String citizenUserPhone = "citizenUserPhone";

  static const String storedTimeOtp = 'otptime';

  static const String supportPhone1 = '01312527111';
  static const String supportPhone2 = '01540579506';
  static const String supportPhone3 = '01540574206';
}