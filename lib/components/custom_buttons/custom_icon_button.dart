import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/custom_text_style.dart';

class CustomIconButtonRounded extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color bgColor;
  final Function() onPress;
  final double ? height;
  final double ? width;
  const CustomIconButtonRounded({Key? key, required this.title, required this.icon, this.bgColor =MyColors.primaryColor, required this.onPress, this.height=40, this.width=double.infinity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 57,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(7)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 25,color:  MyColors.secondaryTextColor,),
            const SizedBox(width: 5,),
            Text(title, style: MyTextStyle.secondaryLight(),)
          ],
        ),
      ),
    );
  }
}