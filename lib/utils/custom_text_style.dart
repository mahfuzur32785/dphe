   import 'package:flutter/cupertino.dart';
import 'app_colors.dart';
import 'app_constant.dart';



class MyTextStyle{
  static primaryLight({Color fontColor = MyColors.primaryTextColor, double fontSize = 16,FontWeight fontWeight = FontWeight.w500}){
    return TextStyle(
        fontFamily: AppConstant.kalpurush,
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight
    );
  }
  static primaryBold({Color fontColor = MyColors.primaryTextColor, double fontSize = 20,FontWeight fontWeight = FontWeight.w700}){
    return TextStyle(
        fontFamily: AppConstant.kalpurush,
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight
    );
  }

  static robotoHeadline({Color fontColor = MyColors.primaryTextColor, double fontSize = 20,FontWeight fontWeight = FontWeight.w700}){
    return TextStyle(
        fontFamily: AppConstant.roboto,
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight
    );
  }


  static secondaryLight({String fontFamily=AppConstant.kalpurush,Color fontColor = MyColors.secondaryTextColor, double fontSize = 16,FontWeight fontWeight = FontWeight.w500}){
    return TextStyle(
      //fontFamily: MyTexts.solaimanFont,
        fontFamily: fontFamily,
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight
    );
  }

  static secondaryBold({Color fontColor = MyColors.secondaryTextColor, double fontSize = 48,FontWeight fontWeight = FontWeight.bold}){
    return TextStyle(
      //fontFamily: MyTexts.solaimanFont,
        fontFamily: AppConstant.kalpurush,
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight
    );
  }

  static blueLight({Color fontColor = MyColors.primaryColor, double fontSize = 20,FontWeight fontWeight = FontWeight.w700}){
    return TextStyle(
        fontFamily: AppConstant.kalpurush,
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight
    );
  }

  static blueBold({Color fontColor = MyColors.primaryColor, double fontSize = 20,FontWeight fontWeight = FontWeight.bold}){
    return TextStyle(
      //fontFamily: MyTexts.solaimanFont,
        fontFamily: AppConstant.kalpurush,
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight
    );
  }

  static appLogoStyle({String fontFamily=AppConstant.kalpurush,Color fontColor = MyColors.primaryTextColor, double fontSize = 28,FontWeight fontWeight = FontWeight.bold}){
    return TextStyle(
        fontFamily: fontFamily,
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight
    );
  }

}