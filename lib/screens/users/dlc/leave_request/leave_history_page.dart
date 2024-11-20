import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/provider/leave_provider.dart';
import 'package:dphe/screens/users/dlc/leave_request/leave_request.dart';
import 'package:dphe/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../components/custom_snackbar/custom_snakcbar.dart';
import '../../../../helper/date_converter.dart';

class LeaveHistoryPage extends StatefulWidget {
  const LeaveHistoryPage({super.key});

  @override
  State<LeaveHistoryPage> createState() => _LeaveHistoryPageState();
}

class _LeaveHistoryPageState extends State<LeaveHistoryPage> {
  getLeaveData() async {
    final lvPr = Provider.of<LeaveProvider>(context, listen: false);
    await lvPr.getAllLeaveData(isFilter: false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLeaveData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<LeaveProvider>(builder: (context, leave, child) {
      return Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await leave.getAllLeaveData(isFilter: false);
              leave.clearHistoryDates();
            },
            child: Stack(
              children: [
                ListView(),
                Column(
                  children: [
                    Container(
                      height: 60,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: MyColors.backgroundColor,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'My Leave',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: BackButton(
                              color: const Color.fromARGB(255, 139, 139, 139),
                              onPressed: () {
                                //leave.clearAllData(rmrkController: remarksController);
                                return Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              await pickDateForHistory(ctx: context, provider: leave, isFromDate: true);
                              // if (leave.selectedLeaveType == null) {
                              //   CustomSnackBar(message: 'Please Select Leave Type', isSuccess: false).show();
                              // } else {
                              // await pickDate(ctx: context, provider: leave, isFromDate: true);
                              // }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black45)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'From ',
                                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                                      ),
                                      leave.fromDateHistry != null
                                          ? Text(
                                              '${DateConverter.dateFromForAPi(leave.fromDateHistry!)}',
                                              // '-${leave.leaveFromDate!}',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                                            )
                                          : Text(
                                              'Date :',
                                              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                                            ),
                                    ],
                                  ),
                                  Icon(Icons.calendar_month_rounded)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              await pickDateForHistory(ctx: context, provider: leave, isFromDate: false);
                              // await pickDate(ctx: context, provider: leave, isFromDate: false);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'To ',
                                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                                      ),
                                      leave.toDateHistry != null
                                          ? Text(
                                              '${DateConverter.dateFromForAPi(leave.toDateHistry!)}',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                                            )
                                          : Text(
                                              'Date :',
                                              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                                            ),
                                    ],
                                  ),
                                  Icon(Icons.calendar_month_rounded)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                      child: CustomButtonRounded(
                          height: 50,
                          title: 'Search',
                          bgColor: Colors.green,
                          onPress: () async {
                            await leave.getAllLeaveData(isFilter: true, formDate: leave.fromDateHistry, toDate: leave.toDateHistry);
                          }),
                    ),
                    leave.leaveDataList.isEmpty
                        ? Expanded(
                            child: Center(
                            child: Text('No Leave Data found on the following dates'),
                          ))
                        :
                        // leave.leaveDataList.isEmpty
                        //     ? Expanded(
                        //         child: ListView.builder(
                        //         itemCount: 2,
                        //         itemBuilder: (context, index) {
                        //           return Stack(
                        //             children: [
                        //               Container(
                        //                 margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        //                 decoration: BoxDecoration(
                        //                     color: MyColors.cardBackgroundColor,
                        //                     borderRadius: BorderRadius.circular(10),
                        //                     border: Border.all(color: Colors.grey)),
                        //                 child: Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Row(
                        //                       children: [
                        //                         Expanded(
                        //                           flex: 3,
                        //                           child: Padding(
                        //                             padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                        //                             child: Text(
                        //                               'Leave Type',
                        //                               style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        //                             ),
                        //                           ),
                        //                         ),
                        //                         Expanded(
                        //                           child: Text(
                        //                             ':',
                        //                             style: TextStyle(fontWeight: FontWeight.bold),
                        //                           ),
                        //                         ),
                        //                         // Expanded(
                        //                         //     child: Text(
                        //                         //   ':',
                        //                         //   style: TextStyle(fontWeight: FontWeight.bold),
                        //                         // )),
                        //                         Expanded(
                        //                           flex: 3,
                        //                           child: Text('Casual'),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                     leaveDataTile(),
                        //                     // Row(
                        //                     //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //                     //   children: [
                        //                     //     Expanded(
                        //                     //       flex: 2,
                        //                     //       child: Padding(
                        //                     //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        //                     //         child: Text(
                        //                     //           'Requested Date',
                        //                     //           style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        //                     //         ),
                        //                     //       ),

                        Expanded(
                            child: ListView.builder(
                              itemCount: leave.leaveDataList.length,
                              itemBuilder: (context, index) {
                                var lvData = leave.leaveDataList[index];
                                return Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      decoration: BoxDecoration(
                                          color: MyColors.cardBackgroundColor,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.grey)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 9,
                                          ),
                                          leaveDataTile(
                                            title: 'Leave Type',
                                            value: lvData.leaveType!,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          leaveDataTile(
                                            title: 'Requested Date',
                                            value:
                                                'From ${DateConverter.dateFormatFromAPi(lvData.fromDate!)} To ${DateConverter.dateFormatFromAPi(lvData.toDate!)}',
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          leaveDataTile(
                                            title: 'EXEN Name',
                                            value: lvData.exen!.name!,
                                          ),
                                       lvData.isRejected == 1 ?  leaveDataTile(
                                            title: 'Reason',
                                            value:Bidi.stripHtmlIfNeeded(lvData.comment ?? '') ,
                                          ): SizedBox.shrink(),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          // Row(
                                          //   children: [
                                          //     Padding(
                                          //       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                          //       child: Text(
                                          //         'Leave Type:',
                                          //         style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                                          //       ),
                                          //     ),
                                          //     Padding(
                                          //       padding: const EdgeInsets.only(left: 8.0),
                                          //       child: Text('${lvData.leaveType}'),
                                          //     ),
                                          //   ],
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     Expanded(
                                          //       child: Padding(
                                          //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          //         child: Text('Requested Date :'),
                                          //       ),
                                          //     ),
                                          //     Expanded(child: Text('10-2-2023 To 3-2-2023'))
                                          //   ],
                                          // ),
                                          // Column(
                                          //   crossAxisAlignment: CrossAxisAlignment.start,
                                          //   children: [
                                          //     Padding(
                                          //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          //       child: Text(
                                          //         'Leave Applied On',
                                          //         style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                                          //       ),
                                          //     ),
                                          //     Padding(
                                          //       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                          //       child: Row(
                                          //         children: [
                                          //           Text('From'),
                                          //           Padding(
                                          //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          //             child: Text('${DateConverter.dateFormatFromAPi(lvData.fromDate!)}'),
                                          //           ),
                                          //           Text('To'),
                                          //           Padding(
                                          //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          //             child: Text('${DateConverter.dateFormatFromAPi(lvData.toDate!)}'),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     Padding(
                                          //       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                          //       child: Text(
                                          //         'XEN Name:',
                                          //         style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                                          //       ),
                                          //     ),
                                          //     Text(lvData.exen!.name!),
                                          //   ],
                                          // ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                                  child: Text(
                                                    'Status',
                                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                              Expanded(child: Text(':')),
                                              lvData.isRejected == 1
                                                  ? Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        child: Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Card(
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                              color: MyColors.rejectedlvStsColor,
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(4.0),
                                                                child: Text(
                                                                  'Rejected',
                                                                  style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                                                                ),
                                                              )),
                                                        ),
                                                      ),
                                                    )
                                                  : (lvData.isForwarded == 1 && lvData.isApproved == 0 && lvData.isRejected == 0)
                                                      ? Expanded(
                                                          flex: 3,
                                                          child: Container(
                                                            child: Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Card(
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                  color: MyColors.benfMappingTile,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(4.0),
                                                                    child: Text(
                                                                      'Forwarded',
                                                                      style:
                                                                          TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  )),
                                                            ),
                                                          ),
                                                        )
                                                      : (lvData.isForwarded == 1 && lvData.isApproved == 1 && lvData.isRejected == 0)
                                                          ? Expanded(
                                                              flex: 3,
                                                              child: Container(
                                                                child: Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Card(
                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                      color: MyColors.apprvelvStsColor,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(4.0),
                                                                        child: Text(
                                                                          'Approved',
                                                                          style: TextStyle(
                                                                              fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                                                                        ),
                                                                      )),
                                                                ),
                                                              ),
                                                            )
                                                          : (lvData.isForwarded == 0 && lvData.isApproved == 0 && lvData.isRejected == 0)
                                                              ? Expanded(
                                                                  flex: 3,
                                                                  child: Container(
                                                                    child: Align(
                                                                      alignment: Alignment.centerLeft,
                                                                      child: Card(
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                          color: MyColors.pendinglvStsColor,
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(4.0),
                                                                            child: Text(
                                                                              'Pending',
                                                                              style: TextStyle(
                                                                                  fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          )),
                                                                    ),
                                                                  ),
                                                                )
                                                              : SizedBox.shrink(),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    (lvData.isForwarded == 1 || lvData.isApproved == 1 || lvData.isRejected == 1)
                                        ? SizedBox.shrink() : Positioned(
                                            right: 0,
                                            child: IconButton(
                                                onPressed: () {
                                                  leave.updateLeaveRequestData(
                                                      exnID: lvData.exen!.id!,
                                                      exnName: lvData.exen!.name!,
                                                      selectedLeaveType: lvData.leaveType!,
                                                      fromDate: lvData.fromDate!,
                                                      toDate: lvData.toDate!,
                                                      // rmrkController: lvData.description,
                                                      remarks: lvData.description!,
                                                      leaveID: lvData.id!);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => LeaveRequestPage(),
                                                      ));
                                                },
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: Color.fromARGB(255, 253, 123, 114),
                                                )))
                                        
                                  ],
                                );
                              },
                            ),
                          )
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          label: Text('New'),
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LeaveRequestPage(),
                ));
          },
        ),
      );
    });
  }

  Row leaveDataTile({required String title, required String value,}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 3,
          //flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ),
        Expanded(
          child: Text(
            ':',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
          ),
        )
      ],
    );
  }

  Future pickDateForHistory({required BuildContext ctx, required LeaveProvider provider, bool isFromDate = true}) async {
    DateTime? dateTime = await showDatePicker(
      context: ctx,
      firstDate: DateTime.now().subtract(const Duration(days: 730)),
      initialDate: isFromDate
          ? provider.fromDateHistry != null
              ? DateConverter.convertStringToDateFormat2(DateConverter.dateFormatFromAPi(provider.fromDateHistry!))
              : DateTime.now()
          : provider.toDateHistry != null
              ? DateConverter.convertStringToDateFormat2(DateConverter.dateFormatFromAPi(provider.toDateHistry!))
              : DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: MyColors.customDeepBlue, // header background color
                onPrimary: Colors.white, // header text color
                onSurface: Colors.black, // body text color
              ), // sets the text color of Calender and manual date input
            ),
            child: child!);
      },
    );
    if (dateTime != null) {
      if (isFromDate) {
        provider.forHistoryUpdateDates(dateTime, isFromDate: true);
      } else {
        provider.forHistoryUpdateDates(dateTime);
      }
    }
    if (dateTime != null) {
      if (isFromDate) {
        if (!mounted) return;
        provider.onlvHistrypdateDate(context, isFromDate: true);
      } else {
        if (!mounted) return;
        provider.onlvHistrypdateDate(
          context,
        );
      }
    }
  }
}
