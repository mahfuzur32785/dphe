import 'dart:developer';
import 'dart:io';

import 'package:dphe/api/auth_api/auth_api.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/screens/users/citizen/citizen_dashboard/citizen_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:uuid/uuid.dart';
import '../../../components/custom_buttons/custom_button_rounded.dart';
import '../../../components/text_input_filed/sign_in_text_input_field.dart';
import '../../../utils/app_strings.dart';
import 'package:device_info_plus/device_info_plus.dart';

class CitizenLoginTabView extends StatefulWidget {
  const CitizenLoginTabView({super.key});

  @override
  State<CitizenLoginTabView> createState() => _CitizenLoginTabViewState();
}

class _CitizenLoginTabViewState extends State<CitizenLoginTabView> {
  final TextEditingController phoneController = TextEditingController();
  final _formKey =  GlobalKey<FormState>();
  bool isLoading = false;
  bool isOtpShow = false;

  String uniqueId = "";
  late final SmsRetrieverImpl smsRetrieverImpl;

  @override
  void initState() {
    getDeviceId();
    smsRetrieverImpl = SmsRetrieverImpl(SmartAuth());
    super.initState();
  }


  getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    var uuid = const Uuid();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      uniqueId = uuid.v5(Uuid.NAMESPACE_OID, androidInfo.id);
      print("skdljhfkjasdgf ${uniqueId}");
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      uniqueId = uuid.v5(Uuid.NAMESPACE_OID, iosInfo.identifierForVendor);
    } else {
      uniqueId = uuid.v4();
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 15,),
              MyTextFieldSignIn(
                controller: phoneController,
                textInputType: TextInputType.phone,
                prefix: const Icon(Icons.phone),
                hintText: "মোবাইল নং",
                autoFillHints: AutofillHints.telephoneNumber,
                validatorFunction: (value) {
                  if (value == null || value.isEmpty) {
                    return "মোবাইল নম্বর প্রদান করুন";
                  }
                  return null;
                },
              ),
              Visibility(
                visible: isOtpShow,
                child: Column(
                  children: [
                    const SizedBox(height: 15,),
                    Pinput(
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      length: 6,
                      smsRetriever: smsRetrieverImpl,
                      defaultPinTheme: PinTheme(
                        width: 50,
                        height: 50,
                        textStyle: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      autofillHints: const [AutofillHints.oneTimeCode],
                      onCompleted: (pin) async{
                        final res = await AuthApi().otpVerify(
                          deviceID: uniqueId,
                          phone: phoneController.text.trim(),
                          otp: pin
                        );
                        if (res?['success']==true) {
                          CustomSnackBar(message: "You have successfully login", isSuccess: true).show();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>const CitizenDashboard()));
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),

              Container(
                child: isLoading?const Center(child: CircularProgressIndicator(),):CustomButtonRounded(
                    title: "লগইন",
                    onPress: () async {
                      if (_formKey.currentState!.validate()) {
                        isOtpShow = false;
                        isLoading = true;
                        setState(() {});
                        final res = await AuthApi().citizenLoginApi(
                          phone: phoneController.text.trim(),
                          deviceID: uniqueId,
                        );
                        isLoading = false;
                        setState(() {});
                        if(res != null){
                          if(res.otpSend == true){
                            CustomSnackBar(message: "Otp is sent to your phone", isSuccess: true).show();
                            isOtpShow = true;
                            setState(() {});
                          }else{
                            CustomSnackBar(message: "You have successfully login", isSuccess: true).show();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>const CitizenDashboard()));
                          }
                        }
                      }

                    }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}


class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeSmsListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final res = await smartAuth.getSmsCode(
      useUserConsentApi: true,
    );
    if (res.succeed && res.codeFound) {
      return res.code!;
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}