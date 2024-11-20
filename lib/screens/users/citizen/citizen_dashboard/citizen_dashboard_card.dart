import 'package:dphe/components/common_widgets/common_widgets.dart';
import 'package:dphe/screens/users/le/le_dashboard/send_to_verify_page.dart';
import 'package:dphe/screens/users/le/le_dashboard/submit_otp.dart';
import 'package:dphe/utils/custom_text_style.dart';
import 'package:flutter/material.dart';
import '../../../../components/custom_buttons/custom_status_button.dart';
import '../../../../utils/app_colors.dart';


class CitizenDashboardCard extends StatefulWidget {
  final int statusCode;
  const CitizenDashboardCard({super.key, required this.statusCode});

  @override
  State<CitizenDashboardCard> createState() => _CitizenDashboardCardState();
}

class _CitizenDashboardCardState extends State<CitizenDashboardCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: MyColors.cardBackgroundColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: MyColors.customGreyLight, width: 1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text("আমার সার্ভিস কাজ করতেছে না", style: MyTextStyle.primaryBold(fontSize: 14),)),
              customStatus(status: "পেন্ডিং", bgColor: MyColors.customRed)
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              Text("১২/০৭/২০২৩, ১২:৩০", style: MyTextStyle.primaryLight(fontSize: 14),),

            ],
          ),
          const Divider(),
          Text("আমি আপনাদের দৃষ্টি আকর্ষণ করতে চাই যে, আমাদের এলাকায় বেশ কিছু দিন ধরে জল সরবরাহে বড় ধরনের সমস্যা দেখা দিয়েছে।"
              " প্রতিদিন কয়েক ঘণ্টা করে পানি সরবরাহ বন্ধ থাকে, এবং সরবরাহিত পানির মানও অনেক নিম্নমানের। এর ফলে আমাদের দৈনন্দিন কার্যক্রমে বড় অসুবিধার সম্মুখীন হতে হচ্ছে।", style: MyTextStyle.primaryLight(fontSize: 12),),

        ],
      ),
    );
  }
}
