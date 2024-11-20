import 'package:dphe/utils/app_colors.dart';
import 'package:dphe/utils/custom_text_style.dart';
import 'package:flutter/material.dart';

class DashBoardCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color bgColor;
  final bool isBill;
  final Function() onTap;
  const DashBoardCard({
    super.key,
    required this.title,
    required this.value,
    this.icon=Icons.group,
    required this.bgColor,
    required this.onTap,
    this.isBill = false
  });

  @override
  State<DashBoardCard> createState() => _DashBoardCardState();
}

class _DashBoardCardState extends State<DashBoardCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:widget.bgColor,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: MyTextStyle.secondaryBold(fontSize: 17),),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.value, style: MyTextStyle.secondaryBold(fontSize: 25),),
              widget.isBill ? Text('\u09F3', style: MyTextStyle.secondaryBold(fontSize: 30,fontColor:MyColors.customWhiteTransparent )) : Icon(widget.icon, size: 40,color: MyColors.customWhiteTransparent,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
