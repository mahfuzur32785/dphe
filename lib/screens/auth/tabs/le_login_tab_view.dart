import 'package:dphe/api/auth_api/auth_api.dart';
import 'package:dphe/components/common_widgets/rememeber_me_widget.dart';
import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/components/custom_loader/custom_loader.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/components/text_input_filed/password_text_field.dart';
import 'package:dphe/components/text_input_filed/sign_in_text_input_field.dart';
import 'package:dphe/screens/users/le/le_dashboard/le_dashboard.dart';
import 'package:dphe/utils/app_constant.dart';
import 'package:dphe/utils/local_storage_manager.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_strings.dart';

class LeLoginTabView extends StatefulWidget {
  const LeLoginTabView({super.key});

  @override
  State<LeLoginTabView> createState() => _LeLoginTabViewState();
}

class _LeLoginTabViewState extends State<LeLoginTabView> {
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();
  bool isSecurePass = true;
  bool isLoading = false;
  bool isRememberMe = false;
  @override
  void initState() {
    phoneController = TextEditingController();
    passwordController = TextEditingController();

    getFromLocal();
    super.initState();
  }

  getFromLocal() async {
    phoneController.text = await LocalStorageManager.readData(AppConstant.uid) ?? '';
    passwordController.text = await LocalStorageManager.readData(AppConstant.userPassword) ?? '';
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
              const SizedBox(
                height: 15,
              ),
              MyTextFieldSignIn(
                controller: phoneController,
                textInputType: TextInputType.phone,
                prefix: const Icon(Icons.phone),
                hintText: "মোবাইল নং",
                autoFillHints: AutofillHints.telephoneNumber,
                validatorFunction: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.requiredField;
                  }
                  if (value.length != 11) {
                    return "Mobile number must be 11 digit";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              PasswordTexFieldSignin(
                controller: passwordController,
                textInputType: TextInputType.visiblePassword,
                prefix: const Icon(Icons.lock_open),
                hintText: "পাসওয়ার্ড",
                autoFillHints: AutofillHints.telephoneNumber,
                validatorFunction: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.requiredField;
                  }else if(value.length < 6){
                    return 'Password Must be in 6 character';

                  }
                  return null;
                },
              ),
              RememberMeWidget(
                isRememberMe: isRememberMe,
                onChanged: (p0) {
                  setState(() {
                    isRememberMe = !isRememberMe;
                  });
                  if (isRememberMe) {
                    LocalStorageManager.saveData(AppConstant.uid, phoneController.text);
                    LocalStorageManager.saveData(AppConstant.userPassword, passwordController.text);
                  } else {
                    LocalStorageManager.deleteData(AppConstant.uid);
                    LocalStorageManager.deleteData(AppConstant.userPassword);
                  }
                },
              ),
              // MyTextFieldSignIn(
              //   controller: passwordController,
              //   isSecure: isSecurePass,
              //   textInputType: TextInputType.visiblePassword,
              //   prefix: const Icon(Icons.lock_open),
              //   hintText: "পাসওয়ার্ড",
              //   autoFillHints: AutofillHints.telephoneNumber,
              //   suffix: _passwordVisibility(),
              //   validatorFunction: (value) {
              //     if (value == null || value.isEmpty) {
              //       return AppStrings.requiredField;
              //     }
              //     return null;
              //   },
              // ),
              // const SizedBox(
              //   height: 50,
              // ),

              isLoading == false
                  ? CustomButtonRounded(
                      title: "লগইন ",
                      onPress: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          final res = await AuthApi().callLoginAPi(email: null, phone: phoneController.text, password: passwordController.text);
                          if (res != null) {
                            if (res.statusCode == 200) {
                              if (!mounted) {
                                return;
                              }
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (builder) => const LeDashboard()),
                                (route) => false,
                              );

                              // print("upazilla id ${res.data!.user!.upazilaId}");
                              // print("disc id ${res.data!.user!.upazilaId}");
                            }else if(res.statusCode == 401){
                               setState(() {
                                isLoading = false;
                              });
                              CustomSnackBar(isSuccess: false, message:res.data == null ? 'Invalid Login Credentials': res.data?.message).show();//'Invalid Login Credentials'

                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              CustomSnackBar(isSuccess: false, message: 'Something went wrong, Connection Failed. Please Check your network connection').show();
                            }
                          } else{
                              setState(() {
                                isLoading = false;
                              });
                              CustomSnackBar(isSuccess: false, message: 'Connection Failed. Please Check your network connection').show();
                          }

                          setState(() {
                            isLoading = false;
                          });
                        }
                      })
                  : const CustomLoader(),

              // const SizedBox(
              //   height: 40,
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordVisibility() {
    return InkWell(
      onTap: () {
        setState(() {
          isSecurePass = !isSecurePass;
        });
      },
      child: Icon(isSecurePass ? Icons.visibility_off : Icons.visibility, size: 18),
    );
  }
}
