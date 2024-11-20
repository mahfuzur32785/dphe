import 'package:dphe/provider/operation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../utils/custom_text_style.dart';
class PasswordTexFieldSignin extends StatefulWidget {
  final bool isSecure;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Widget prefix;
  final Widget ? suffix;
  final String hintText;
  final String autoFillHints;
  final FocusNode? passFocus;
  final String? Function(String?)? validatorFunction;
  final String? Function(String?)? onchanged;
  final VoidCallback? onEditingComplete;
  const PasswordTexFieldSignin(
      {Key? key,
        this.isSecure = false,
        required this.controller,
        required this.textInputType,
        required this.prefix,
        this.suffix,
        required this.hintText,
        required this.autoFillHints,
        this.passFocus,
        this.validatorFunction,
        this.onchanged,
        this.onEditingComplete})
      : super(key: key);

  @override
   createState() => _PasswordTexFieldSigninState();
}

class _PasswordTexFieldSigninState extends State<PasswordTexFieldSignin> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OperationProvider>(
      builder: (context,op,child) {
        return TextFormField(
          validator: widget.validatorFunction,
          style: MyTextStyle.primaryLight(),
          controller: widget.controller,
          onChanged: widget.onchanged,
          onEditingComplete: widget.onEditingComplete,
          focusNode: widget.passFocus,
         // keyboardType: widget.textInputType,
          obscureText: op.isPasswordVisible,
          cursorColor: MyColors.primaryColor,
          //autofillHints: [widget.autoFillHints],
          decoration: InputDecoration(
            prefixIcon: widget.prefix,
            suffixIcon: IconButton(onPressed: (){
              op.setPasswordVisibility();
            }, icon: op.isPasswordVisible ?  Icon(Icons.visibility_off) : Icon(Icons.visibility) ),
            contentPadding: const EdgeInsets.only(left: 10),
            hintText: widget.hintText,
            hintStyle: MyTextStyle.primaryLight(
                fontColor: Colors.grey, fontSize: 13),
            alignLabelWithHint: true,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
              borderSide: BorderSide(
                color: MyColors.secondaryTextColor,
                width: 0.5,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
              borderSide: BorderSide(
                color: MyColors.secondaryColor,
                width: 0.9,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
              borderSide: BorderSide(
                color: Colors.red,
                width: 0.9,
              ),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
              borderSide: BorderSide(
                color: Colors.red,
                width: 0.9,
              ),
            ),
          ),
        );
      }
    );
  }
}