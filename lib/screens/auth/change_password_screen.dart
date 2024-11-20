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

class ChangePasswordPage extends StatefulWidget {
  final String userName;
  final String designation;
  final String mobileNo;

  const ChangePasswordPage({super.key, required this.userName, required this.designation, required this.mobileNo});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool isLoading = false;
  final newPasswordController = TextEditingController();
  final oldPasswordController = TextEditingController();
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
                    Text(
                      '${widget.userName}',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                    Text(
                      '${widget.designation}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.06,
                    ),
                    Text(
                      "Create New Password",
                      textAlign: TextAlign.center,
                      style: MyTextStyle.primaryBold(fontSize: size.height * 0.023),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                      child: TextField(
                        controller: oldPasswordController,
                        obscureText: op.isPasswordVisible,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                          hintText: 'Enter Old Password',
                          hintStyle: TextStyle(color: Colors.black45),
                          filled: true,
                          suffixIcon: IconButton(
                              onPressed: () {
                                op.setPasswordVisibility();
                              },
                              icon: op.isPasswordVisible ? Icon(Icons.visibility_off) : Icon(Icons.visibility)),
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.lock),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                      child: TextField(
                        controller: newPasswordController,
                        obscureText: op.isPasswordVisible,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                          hintText: 'Enter New Password',
                          hintStyle: TextStyle(color: Colors.black45),
                          filled: true,
                          suffixIcon: IconButton(
                              onPressed: () {
                                op.setPasswordVisibility();
                              },
                              icon: op.isPasswordVisible ? Icon(Icons.visibility_off) : Icon(Icons.visibility)),
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.lock),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                      child: TextField(
                        controller: confirmPasswordController,
                        obscureText: op.isPasswordVisible,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                          hintText: 'Confirm New Password',
                          hintStyle: TextStyle(color: Colors.black45),
                          filled: true,
                          suffixIcon: IconButton(
                              onPressed: () {
                                op.setPasswordVisibility();
                              },
                              icon: op.isPasswordVisible ? Icon(Icons.visibility_off) : Icon(Icons.visibility)),
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.lock),
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
                    //  SizedBox(height: 90,),
                    isLoading
                        ? CircularProgressIndicator()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                            child: CustomButtonRounded(
                                title: 'Submit',
                                onPress: () async {
                                  var oldPassword = oldPasswordController.text;
                                  var newpass = newPasswordController.text;
                                  var confirmPassword = confirmPasswordController.text;
                                  if (newpass.isEmpty || confirmPassword.isEmpty || oldPassword.isEmpty) {
                                    CustomSnackBar(isSuccess: false, message: 'Password Field must not be empty').show();
                                  } else {
                                    if (newpass != confirmPassword) {
                                      CustomSnackBar(isSuccess: false, message: 'Password Must be same').show();
                                    } else {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      final isPop =
                                          await op.changePassword(currentPass: oldPassword, newPass: newpass, passwordConfirmation: confirmPassword);
                                      if (isPop) {
                                        CustomSnackBar(isSuccess: true,message: op.successOnPassword);

                                       if(context.mounted) Navigator.pop(context);
                                      } else {
                                          CustomSnackBar(isSuccess: false,message: op.successOnPassword).show();
                                      }
                                      setState(() {
                                        isLoading = false;
                                      });
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
