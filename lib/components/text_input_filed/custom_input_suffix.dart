import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_colors.dart';
import '../../utils/custom_text_style.dart';


class CustomTextInputFieldSuffix extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final String hintText;
  final int? textLength;
  final bool isSecure;
  final String? Function(String?)? validatorFunction;
  final String? Function(String?)? onChanged;
  final bool readOnly;
  final int? maxLine;
  final Widget? suffix;
  const CustomTextInputFieldSuffix(
      {Key? key,
        this.isSecure = false,
        required this.controller,
        required this.textInputType,
        required this.hintText,
        this.validatorFunction,
        this.onChanged,
        this.readOnly = false,
        this.maxLine = 1,
        this.suffix,
        this.textLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      validator: validatorFunction,
      onChanged: onChanged,
      //autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        LengthLimitingTextInputFormatter(textLength),
      ],
      style: MyTextStyle.primaryLight(fontSize: 15),
      controller: controller,
      keyboardType: textInputType,
      maxLines: maxLine,
      cursorColor: MyColors.secondaryTextColor,
      obscureText: isSecure,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 15),
        hintText: hintText,
        suffix: suffix,
        hintStyle: MyTextStyle.secondaryLight(
            fontColor: MyColors.customGrey,
            fontSize: 15,
            fontWeight: FontWeight.normal),
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: MyColors.white,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: MyColors.submit,
            width: 0.9,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 0.9,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 0.9,
          ),
        ),
      ),
    );
  }
}
