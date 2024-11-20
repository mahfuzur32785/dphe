import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/custom_text_style.dart';

class ActivityTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final Widget? prefix;
  final Widget? suffix;
  final String hintText;
  final FocusNode? focusNode;
  final bool isValidatorOn;
  final int maxLines;
  final String? Function(String?)? validatorFunction;
  final String? Function(String?)? onchanged;
  final VoidCallback? onEditingComplete;
  const ActivityTextFieldWidget(
      {Key? key,
      required this.controller,
      required this.textInputType,
      this.prefix,
      this.suffix,
      required this.hintText,
      this.focusNode,
      this.isValidatorOn = true,
      this.maxLines = 1,
      this.validatorFunction,
      this.onchanged,
      this.onEditingComplete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
     
      //style: MyTextStyle.primaryLight(),
      controller: controller,
      onChanged: onchanged,
      onEditingComplete: onEditingComplete,
      
      //autovalidateMode: AutovalidateMode.always,
      focusNode: focusNode,
      keyboardType: textInputType,
      textInputAction: TextInputAction.next,
       validator:isValidatorOn ? validatorFunction : null,
      maxLines: maxLines,
      cursorColor: Colors.black,
      // autofillHints: [autoFillHints],
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,

        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0), borderSide: BorderSide(color: Colors.grey)),
        // prefixIcon: prefix,
        // suffixIcon: suffix,
        contentPadding: const EdgeInsets.only(
          left: 10,
        ),
        hintText: hintText,

        hintStyle: MyTextStyle.primaryLight(fontColor: Colors.grey, fontSize: 13),
        alignLabelWithHint: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2),
          ),
          borderSide: BorderSide(
            color: Colors.grey,
            // width: 0.5,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2),
          ),
          borderSide: BorderSide(
            color: MyColors.secondaryColor,
            width: 0.9,
          ),
        ),
       // errorText:errorText,
       // errorText: "error",
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2),
          ),
          borderSide: BorderSide(
            color: Colors.red,
            width: 0.9,
          ),
        ),
        errorStyle: TextStyle(height: 0),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2),
          ),
          borderSide: BorderSide(
            color: Colors.red,
            width: 0.9,
          ),
        ),
      ),
    );
  }
}
