import 'package:dphe/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../utils/custom_text_style.dart';

Widget customCard(
    {required Widget child,
    double horizontalPadding = 10,
    double verticalPadding = 10,
    double horizontalMargin = 0,
    double verticalMargin = 0,
    Color borderColor = MyColors.customGreyLight}) {
  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding, vertical: verticalPadding),
    margin: EdgeInsets.symmetric(
        horizontal: horizontalMargin, vertical: verticalMargin),
    decoration: BoxDecoration(
      border: Border.all(
        color: borderColor,
      ),
      borderRadius: BorderRadius.circular(7),
    ),
    child: child,
  );
}

Widget customTab(
    {required int index,
    required int selectedIndex,
    required String title,
    required Function() onTap}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'kalpurush',
            fontSize: 17,
            fontWeight: FontWeight.w600,
              color: selectedIndex == index
                  ? MyColors.primaryColor
                  : MyColors.primaryTextColor),
        ),
        const SizedBox(
          height: 5,
        ),
        selectedIndex == index
            ? Container(
                height: 2.5,
                decoration: const BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
              )
            : const SizedBox.shrink()
      ],
    ),
  );
}

Widget customTabWithNotification(
    {required int index,
    required int selectedIndex,
    required String title,
    int? number,
    Color bgColor = MyColors.customRed,
    required Function() onTap}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: MyTextStyle.primaryLight(
                  fontColor: selectedIndex == index
                      ? MyColors.primaryColor
                      : MyColors.primaryTextColor),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              //height: 20,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                  child: Text(
                "$number",
                style: MyTextStyle.secondaryLight(fontSize: 14),
              )),
            )
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        selectedIndex == index
            ? Container(
                height: 2.5,
                decoration: const BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
              )
            : const SizedBox()
      ],
    ),
  );
}

Widget newCustomTab(
    {required int index,
      required int selectedIndex,
      required String title,
      required VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Text(
          title,
          style: MyTextStyle.primaryLight(
              fontColor: selectedIndex == index
                  ? MyColors.customGreen
                  : MyColors.primaryTextColor,
                  fontWeight: FontWeight.w600,fontSize: 18),
        ),
        // const SizedBox(
        //   height: 5,
        // ),S
        //SizedBox(width: 70,child: Divider(color: selectedIndex == index ? Colors.green : MyColors.primaryTextColor,))

        // selectedIndex == index
        //     ? Container(
        //   height: 2.5,
        //   decoration: const BoxDecoration(
        //       color: MyColors.primaryColor,
        //       borderRadius: BorderRadius.only(
        //           topLeft: Radius.circular(10),
        //           topRight: Radius.circular(10))),
        // )
        //     : const SizedBox.shrink()
      ],
    ),
  );
}





Widget customStatus({required String status, required Color bgColor}) {
  // return Container(
  //   padding: EdgeInsets.symmetric(horizontal: 10),
  //   decoration: BoxDecoration(
  //     color: bgColor,
  //     borderRadius: BorderRadius.circular(15),
  //   ),
  //   child: Center(child: Text(status, style: MyTextStyle.secondaryLight(fontSize: 14),)),
  // );
  return Text(
    status,
    style: MyTextStyle.primaryBold(fontSize: 14, fontColor: bgColor),
  );
}
