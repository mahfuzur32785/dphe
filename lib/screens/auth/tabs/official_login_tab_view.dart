import 'dart:developer';

import 'package:dphe/components/common_widgets/notification_page.dart';
import 'package:dphe/components/common_widgets/rememeber_me_widget.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/components/text_input_filed/password_text_field.dart';
import 'package:dphe/provider/notification_provider.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/auth/forgot_password.dart';
import 'package:dphe/screens/users/official/official_dashboard/official_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../api/auth_api/auth_api.dart';
import '../../../components/custom_buttons/custom_button_rounded.dart';
import '../../../components/text_input_filed/sign_in_text_input_field.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_strings.dart';
import 'dart:developer';

import '../../../utils/local_storage_manager.dart';
import '../../users/dlc/dlc_dashboard/dlc_dashboard_page.dart';
import '../change_password_screen.dart';

class OfficialLoginTabView extends StatefulWidget {
  const OfficialLoginTabView({super.key});

  @override
  State<OfficialLoginTabView> createState() => _OfficialLoginTabViewState();
}

class _OfficialLoginTabViewState extends State<OfficialLoginTabView> {
  late TextEditingController emailController;
  late TextEditingController officialUserPasswordController;
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  final _formKey = GlobalKey<FormState>();
  bool isPasswordWidget = false;
  bool isLoading = false;
  bool isRememberMe = false;
  bool isSecurePass = true;
  String errorText = '';
  late PageController officialLoginPageViewController;

  @override
  void initState() {
    emailController = TextEditingController();
    officialUserPasswordController = TextEditingController();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    officialLoginPageViewController = PageController(initialPage: 0);
    getFromLocal();
    super.initState();
    // geoadd();
  }

  geoadd() async {
    final op = Provider.of<OperationProvider>(context, listen: false);
    await op.getAddress(lat: 24.61760191246814, lang: 88.23534950228529);
  }

  getFromLocal() async {
    emailController.text = await LocalStorageManager.readData(AppConstant.offdlcuseremail) ?? '';
    officialUserPasswordController.text = await LocalStorageManager.readData(AppConstant.offdlcpass) ?? '';
  }

  Future<void> _login() async {
    if (officialUserPasswordController.text.isEmpty) {
      CustomSnackBar(message: 'Please Enter Password', isSuccess: false).show();
    } else if (emailController.text.isEmpty) {
      CustomSnackBar(message: 'Please Enter Email', isSuccess: false).show();
    } else if (officialUserPasswordController.text.length < 6) {
      CustomSnackBar(isSuccess: false, message: 'Password must be in 6 character').show();
    } else {
      setState(() {
        isLoading = true;
      });
      log("official user email ${emailController.text}");
      log("official user password ${officialUserPasswordController.text}");
      final res = await AuthApi().callLoginAPi(email: emailController.text, password: officialUserPasswordController.text);

      if (res != null) {
        if (res.statusCode == 200) {
          //var fbToken = await  NotificationProvider.getFirebaseToken();
          //print('fbtoken $fbToken');
          if (!mounted) {
            return;
          }
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => DlcDashBoardPage(),
            ),
            (route) => false,
          );
          // Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(
          //         builder: (builder) =>
          //             const LeDashboard()));
          // print("sk");
          // print("upazilla id ${res.data!.user!.upazilaId}");
          // print("disc id ${res.data!.user!.upazilaId}");
          setState(() {
            isLoading = false;
          });
        } else if (res.statusCode == 401) {
          setState(() {
            isLoading = false;
          });
          CustomSnackBar(isSuccess: false, message: res.data == null ? 'Invalid Login Credentials' : res.data?.message)
              .show(); //'Invalid Login Credentials'
        } else {
          setState(() {
            isLoading = false;
          });
          CustomSnackBar(message: 'Failed to Connect to the server', isSuccess: false).show();
        }
      } else {
        setState(() {
          isLoading = false;
        });
        CustomSnackBar(isSuccess: false, message: 'Connection Failed. Please Check your network connection').show();
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    officialUserPasswordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.6,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: size.height * 0.5,
            child: PageView(
              scrollDirection: Axis.horizontal,
              controller: officialLoginPageViewController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (value) {
                //op.setDividerTab(value);
              },
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: MyTextFieldSignIn(
                        controller: emailController,
                        focusNode: emailFocusNode,
                        textInputType: TextInputType.emailAddress,
                        prefix: const Icon(Icons.email),
                        hintText: "Email",
                        onchanged: (p0) {
                          setState(() {
                            errorText = '';
                          });
                        },
                        autoFillHints: AutofillHints.email,
                        validatorFunction: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.requiredField;
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          if (!emailController.text.contains('.com')) {
                            setState(() {
                              errorText = 'Please Enter valid email address';
                            });
                          } else {
                            passwordFocusNode.requestFocus();
                            officialLoginPageViewController.animateToPage(
                              1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        errorText,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    // :

                    // const SizedBox(
                    //   height: 50,
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: CustomButtonRounded(
                          height: 45,
                          //width: size.width * 0.8,
                          title: "Next ",
                          onPress: () {
                            if (emailController.text.isEmpty) {
                              setState(() {
                                errorText = 'Please Enter Email';
                              });
                            } else if (!emailController.text.contains('.com')) {
                              setState(() {
                                errorText = 'Please Enter valid email address';
                              });
                            } else {
                              passwordFocusNode.requestFocus();
                              officialLoginPageViewController.animateToPage(
                                1,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                              setState(() {
                                isPasswordWidget = true;
                              });
                            }

                            //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>const OfficialDashboard()));
                          }),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      child: PasswordTexFieldSignin(
                        controller: officialUserPasswordController,
                        prefix: const Icon(Icons.lock_open),
                        passFocus: passwordFocusNode,
                        textInputType: TextInputType.visiblePassword,
                        hintText: "Password",
                        autoFillHints: AutofillHints.password,
                        validatorFunction: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.requiredField;
                          }
                          return null;
                        },
                        onEditingComplete: () async {
                          await _login();
                        },
                      ),
                    ),
                    // RememberMeWidget(
                    //   isRememberMe: isRememberMe,
                    //   onChanged: (p0) {
                    //     setState(() {
                    //       isRememberMe = !isRememberMe;
                    //     });
                    //   },
                    // ),
                    RememberMeWidget(
                      isRememberMe: isRememberMe,
                      onChanged: (p0) {
                        setState(() {
                          isRememberMe = !isRememberMe;
                        });
                        if (isRememberMe) {
                          LocalStorageManager.saveData(AppConstant.offdlcuseremail, emailController.text);
                          LocalStorageManager.saveData(AppConstant.offdlcpass, officialUserPasswordController.text);
                        } else {
                          LocalStorageManager.deleteData(AppConstant.offdlcuseremail);
                          LocalStorageManager.deleteData(AppConstant.offdlcpass);
                        }
                      },
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 8),
                    //   child: Row(
                    //     children: [
                    //       Checkbox(
                    //         value: isRememberMe,
                    //         activeColor: MyColors.primaryColor,
                    //         //fillColor:,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             isRememberMe = !isRememberMe;
                    //           });
                    //         },
                    //       ),
                    //       Text(
                    //         'Remember Me?',
                    //         style: TextStyle(color: MyColors.primaryColor),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Colors.blue,
                              )
                            : CustomButtonRounded(
                                width: size.width * 0.8,
                                height: 50,
                                //width: 80,
                                title: 'Login',
                                onPress: () async {
                                  await _login();
                                },
                              ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordPage(),
                              ));
                        },
                        //style: TextButton.styleFrom(),
                        child: Text(
                          'Forget Password',
                          style: TextStyle(
                            color: MyColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: IconButton(
                          onPressed: () {
                            officialLoginPageViewController.animateToPage(
                              0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          //style: TextButton.styleFrom(),
                          icon: Icon(Icons.arrow_back_ios)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
