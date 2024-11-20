import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/custom_text_style.dart';
class CustomButtonSquare extends StatelessWidget {
  final Function() onPress;
  final Color? backgroundColor;
  final String? btnTitle;
  final double btnRadius;
  final double btnHeight;
  CustomButtonSquare({Key? key,
    required this.onPress,
    this.backgroundColor = MyColors.primaryColor,
    this.btnTitle = "সাবমিট",
    this.btnRadius = 7,
    this.btnHeight = 32,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(btnRadius),
      ),
      child: MaterialButton(
          height: btnHeight,
          color: backgroundColor,
          onPressed: onPress,
          child: Text(btnTitle!, style: TextStyle(
            fontFamily: "kalpurush",
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: MyColors.secondaryTextColor,
          ),)
      ),
    );
  }
}
