import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/custom_text_style.dart';

class CustomStatusButton extends StatelessWidget {
  final String title;
  final Function() onPress;
  final double ?height;
  final double ? width;
  final Color? bgColor;
  const CustomStatusButton({Key? key, required this.title, required this.onPress, this.height=30,  this.width=120,this.bgColor = MyColors.primaryColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPress,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(bgColor!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        child: Text(title,style: MyTextStyle.secondaryLight(fontSize: 13),),
      ),
    );
  }
}