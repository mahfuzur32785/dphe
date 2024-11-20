import 'package:dphe/Data/models/citizen/complain_model.dart';
import 'package:dphe/api/citizen/complain_list_api.dart';
import 'package:dphe/components/common_widgets/common_widgets.dart';
import 'package:dphe/screens/users/citizen/complain/add_new_complain.dart';
import 'package:dphe/screens/users/citizen/complain/complain_details.dart';
import 'package:dphe/utils/app_colors.dart';
import 'package:dphe/utils/custom_text_style.dart';
import 'package:dphe/utils/utlis.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../components/custom_appbar/custom_appbar.dart';

class CitizenDashboard extends StatefulWidget {
  const CitizenDashboard({super.key});

  @override
  State<CitizenDashboard> createState() => _CitizenDashboardState();
}

class _CitizenDashboardState extends State<CitizenDashboard> {
  int selectedIndex = 0;

  @override
  void initState() {
    getComplainList();
    super.initState();
  }

  List<ComplainModel> complainList = [];
  bool isComplainListLoading = false;
  getComplainList() async {
    isComplainListLoading = true;
    setState(() {});
    List<ComplainModel> allComplain =
        await CitizenApi().getCitizenComplainApi() ?? [];
    complainList = allComplain.reversed.toList();
    isComplainListLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: "Citizen",
      ),
      body: RefreshIndicator(
        onRefresh: () => getComplainList(),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (builder) => const AddNewComplain()))
                        .then(
                          (value) => getComplainList(),
                        );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text(
                      "অভিযোগ করুন",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 10),
                child: Text(
                  "অভিযোগের তালিকা",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Expanded(
                child: isComplainListLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : complainList.isEmpty
                        ? const Center(
                            child: Text("কোন তথ্য নেই",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          )
                        : ListView.builder(
                            itemCount: complainList.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ComplainDetails(
                                                      complainModel:
                                                          complainList[index])))
                                      .then((value) => getComplainList());
                                },
                                child: Container(
                                  height: 140,
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      color: MyColors.cardBackgroundColor,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: MyColors.customGreyLight,
                                          width: 1)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            "${complainList[index].subject}",
                                            style: MyTextStyle.primaryBold(
                                                fontSize: 14),
                                          )),
                                          customStatus(
                                              status:
                                                  "${complainList[index].status}",
                                              bgColor: complainList[index]
                                                          .status ==
                                                      "Resolved"
                                                  ? Colors.green
                                                  : complainList[index]
                                                              .status ==
                                                          "Invalid"
                                                      ? Colors.red
                                                      : complainList[index]
                                                                  .status ==
                                                              "Pending"
                                                          ? Colors.orange
                                                          : complainList[index]
                                                                      .status ==
                                                                  "Processing"
                                                              ? Colors.blue
                                                              : MyColors
                                                                  .customRed,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            Utils.convertToBengaliNumerals(
                                                DateFormat('dd/MM/yyyy, hh:mm')
                                                    .format(complainList[index]
                                                        .createdAt!)),
                                            style: MyTextStyle.primaryLight(
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      Expanded(
                                        child: Text(
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          "${complainList[index].body}",
                                          style: MyTextStyle.primaryLight(
                                              fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
              )
            ],
          ),
        ),
      ),
      // body: Column(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Text("নোটিশ", style: MyTextStyle.primaryBold(fontSize: 16),),
      //           InkWell(
      //             onTap: (){
      //
      //             },
      //               child: Text("সব দেখুন", style: MyTextStyle.primaryLight(fontSize: 14),)),
      //         ],
      //       ),
      //     ),
      //
      //     customCard(
      //       horizontalMargin: 10,
      //         child: Row(
      //           children: [
      //             Image.network("https://seeklogo.com/images/D/dphe-logo-202B57F760-seeklogo.com.png", height: 60,),
      //             const SizedBox(width: 10,),
      //             Expanded(
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text("নোটিশ Title demo", style: MyTextStyle.primaryBold(fontSize: 16),),
      //                   Text("12/07/2023, 12:30pm", style: MyTextStyle.primaryLight(fontSize: 12),),
      //                 ],
      //               ),
      //             )
      //           ],
      //         )
      //     ) ,
      //
      //
      //
      //     //tabs
      //     const SizedBox(height: 30,),
      //     Row(
      //       children: [
      //         Expanded(
      //           child: customTabWithNotification(index: 0, selectedIndex: selectedIndex, title: "Complaint",number: 20,
      //               onTap: (){
      //                 setState(() {
      //                   selectedIndex = 0;
      //                   //currentPageNo = 1;
      //                 });
      //               }
      //           ),
      //         ),
      //         Expanded(
      //           child: customTabWithNotification(index: 1, selectedIndex: selectedIndex, title: "Resolved", number: 60, bgColor: MyColors.customGreenLight,
      //               onTap: (){
      //                 setState(() {
      //                   selectedIndex = 1;
      //                   //currentPageNo = 1;
      //                 });
      //               }
      //           ),
      //         ),
      //       ],
      //     ),
      //     const Divider(),
      //
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
      //         child: ListView.builder(
      //             itemCount: StaticList().statusList.length,
      //             shrinkWrap: true,
      //             itemBuilder: (BuildContext context, int index){
      //               return CitizenDashboardCard(
      //                 statusCode: StaticList().statusList[index],
      //               );
      //             }
      //         ),
      //       ),
      //     )
      //
      //
      //
      //
      //   ],
      // ),
    );
  }
}
