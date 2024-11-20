import 'package:dphe/api/auth_api/auth_api.dart';
import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/components/text_input_filed/custom_textFIeld.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/asset_strings.dart';
import '../../utils/custom_text_style.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({
    super.key,
    // required this.userName,
    // required this.designation,
    // required this.mobileNo,
  });

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool isLoading = false;
  final emailController = TextEditingController();
  // final oldPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<OperationProvider>(builder: (context, op, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 28,
                    )),
                Column(
                  children: [
                    Image.asset(
                      AssetStrings.dpheLogo,
                      height: size.height / 9,
                      // height: 70,
                    ),
                    Text(
                      "IMVS For RWSHHCDP",
                      textAlign: TextAlign.center,
                      style: MyTextStyle.primaryBold(fontSize: size.height * 0.03),
                    ),
                    SizedBox(
                      height: size.height * 0.06,
                    ),
                    // Text(
                    //   '${widget.userName}',
                    //   style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                    // ),
                    // Text(
                    //   '${widget.designation}',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    // ),
                    SizedBox(
                      height: size.height * 0.06,
                    ),
                    Text(
                      "Reset Password",
                      textAlign: TextAlign.center,
                      style: MyTextStyle.primaryBold(fontSize: size.height * 0.023),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                      child: TextField(
                        controller: emailController,
                        // obscureText: op.isPasswordVisible,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                          hintText: 'Enter your Email Address',
                          hintStyle: TextStyle(color: Colors.black45),
                          filled: true,
                          suffixIcon: IconButton(
                              onPressed: () {
                                // op.setPasswordVisibility();
                              },
                              icon: Icon(Icons.email)),
                          fillColor: Colors.white,
                          //prefixIcon: Icon(Icons.lock),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                    //   child: TextField(
                    //     controller: confirmPasswordController,
                    //     obscureText: op.isPasswordVisible,
                    //     decoration: InputDecoration(
                    //       contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                    //       hintText: 'Confirm New Password',
                    //       hintStyle: TextStyle(color: Colors.black45),
                    //       filled: true,
                    //       suffixIcon: IconButton(
                    //           onPressed: () {
                    //             op.setPasswordVisibility();
                    //           },
                    //           icon: op.isPasswordVisible ? Icon(Icons.visibility_off) : Icon(Icons.visibility)),
                    //       fillColor: Colors.white,
                    //       prefixIcon: Icon(Icons.lock),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(20),
                    //         borderSide: BorderSide(
                    //           width: 1.0,
                    //           color: Colors.grey,
                    //         ),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(20),
                    //         borderSide: BorderSide(
                    //           width: 1.0,
                    //           color: Colors.grey,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    //  SizedBox(height: 90,),
                    isLoading
                        ? CircularProgressIndicator()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                            child: CustomButtonRounded(
                                title: 'Request your Password',
                                onPress: () async {
                                  var email = emailController.text;
                                  //  var confirmPassword = confirmPasswordController.text;
                                  if (email.isEmpty) {
                                    CustomSnackBar(isSuccess: false, message: 'Email Field must not be empty').show();
                                  } else {
                                    final forgetPass = await AuthApi().forgetPassword(email: email);
                                    if (forgetPass != null) {
                                      if (forgetPass.statusCode == 200) {
                                          CustomSnackBar(isSuccess: true, message: 'An Email has been sent to your email address').show();

                                      } else {
                                         CustomSnackBar(isSuccess: false, message: 'Email not matched or Invalid Email').show();
                                      }
                                    }
                                  }
                                }),
                          )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

// class EmailForResetPassword extends StatefulWidget {
//   const EmailForResetPassword({super.key});

//   @override
//   State<EmailForResetPassword> createState() => _EmailForResetPasswordState();
// }

// class _EmailForResetPasswordState extends State<EmailForResetPassword> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: Icon(
//                   Icons.arrow_back,
//                   size: 28,
//                 )),

//           ],
//         ),
//       ),
//     );
//   }
// }
