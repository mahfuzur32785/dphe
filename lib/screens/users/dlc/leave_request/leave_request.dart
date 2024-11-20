import 'dart:developer';

import 'package:dphe/components/custom_appbar/custom_appbar.dart';
import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/provider/leave_provider.dart';
import 'package:dphe/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helper/date_converter.dart';
import '../../../../utils/custom_text_style.dart';
import '../attendance/attendance_screen.dart';
import 'leave_details_page.dart';

class LeaveRequestPage extends StatefulWidget {
  const LeaveRequestPage({super.key});

  @override
  State<LeaveRequestPage> createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  String? leaveType;
  late TextEditingController remarksController ;
  final titleController = TextEditingController();
  int? getExnID;
  String? exnName;
  bool islvLoading = false;
  bool isLvFilterLoading = false;
  @override
  void initState() {
   remarksController = TextEditingController();
   getDescription();
    super.initState();
    getExen();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Provider.of<LeaveProvider>(context, listen: false).getAllLeaveData(isFilter: false);
    // });

    getLeaveData();
  }
  getDescription(){
    final lv = Provider.of<LeaveProvider>(context,listen: false);
    remarksController.text = lv.lvdescription.isEmpty ? '' : lv.lvdescription;
  }

  getExen() async {
    Provider.of<LeaveProvider>(context, listen: false).getExenForLeave(context);
  }

  getLeaveData() async {
    final lvPr = Provider.of<LeaveProvider>(context, listen: false);
    await lvPr.getAllLeaveData(isFilter: false);
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // getExen();
    //Provider.of<LeaveProvider>(context,).getAllLeaveData();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<LeaveProvider>(context, listen: false).getAllLeaveData(isFilter: false);
    // });
    final size = MediaQuery.of(context).size;
    getLeaveData();

    return Consumer<LeaveProvider>(builder: (context, leave, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
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
                          'My Leave Request',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: BackButton(
                          color: const Color.fromARGB(255, 139, 139, 139),
                          onPressed: () {
                            leave.clearAllData(rmrkController: remarksController);
                            return Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(37)),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                              value: leave.exenName,
                              isExpanded: true,
                              hint: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('Select Exen'),
                              ),
                              // items: ['ABdur Rahman Mollah Hossain ALi','ABdur Rahman Mollah'].map((e) => DropdownMenuItem(child: Text(e),value: e,)).toList(),
                              items: leave.exenDataList
                                  .map((e) => DropdownMenuItem(
                                      value: e.name,
                                      onTap: () {
                                        leave.setExenID(value: e.id!);
                                        // setState(() {
                                        //   getExnID = e.id;
                                        // });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(e.name!),
                                      )))
                                  .toList(),
                              onChanged: (value) {
                                leave.setExenName(value: value as String);
                              },
                            )),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.grey)),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                            value: leave.selectedLeaveType,
                            // value: leaveType,
                            isExpanded: true,
                            hint: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('Leave Type'),
                            ),
                            items: leave.leaveTypeList
                                .map((e) => DropdownMenuItem(
                                    value: e.leaveTypeName,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(e.leaveTypeName!),
                                    )))
                                .toList(),
                            onChanged: (value) {
                              leave.setLeaveType(value: value as String);
                              // setState(() {
                              //   leaveType = value as String;
                              // });
                            },
                          )),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  if (leave.selectedLeaveType == null) {
                                    CustomSnackBar(message: 'Please Select Leave Type', isSuccess: false).show();
                                  } else {
                                    await pickDate(ctx: context, provider: leave, isFromDate: true);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                                          leave.forapiFromDate != null
                                              ? Text(
                                                  '${DateConverter.dateFromForAPi(leave.forapiFromDate!)}',
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
                                  await pickDate(ctx: context, provider: leave, isFromDate: false);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                                          leave.forapiTodate != null
                                              ? Text(
                                                  '${DateConverter.dateFromForAPi(leave.forapiTodate!)}',
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
                        // Divider(),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: TextField(
                        //     controller: titleController,
                        //     // maxLines: 3,
                        //     decoration: InputDecoration(
                        //       hintText: 'Title..',
                        //       contentPadding: const EdgeInsets.symmetric(
                        //           horizontal: 8, vertical: 18),
                        //       hintStyle: MyTextStyle.secondaryLight(
                        //           fontColor: MyColors.customGrey,
                        //           fontSize: 15,
                        //           fontWeight: FontWeight.normal),
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(7),
                        //         borderSide: const BorderSide(
                        //           color: MyColors.customGrey,
                        //           width: 0.5,
                        //         ),
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(7),
                        //         borderSide: const BorderSide(
                        //           color: MyColors.submit,
                        //           width: 0.9,
                        //         ),
                        //       ),
                        //       errorBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(7),
                        //         borderSide: const BorderSide(
                        //           color: Colors.red,
                        //           width: 0.9,
                        //         ),
                        //       ),
                        //       focusedErrorBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(7),
                        //         borderSide: const BorderSide(
                        //           color: Colors.red,
                        //           width: 0.9,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            child: TextField(
                              controller: remarksController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                hintText: 'Remarks',
                                hintStyle: MyTextStyle.secondaryLight(fontColor: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: const BorderSide(
                                    color: MyColors.customGrey,
                                    width: 0.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: const BorderSide(
                                    color: MyColors.submit,
                                    width: 0.9,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 0.9,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 0.9,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        //Divider(),
                        islvLoading
                            ? Center(child: CircularProgressIndicator())
                            : Row(
                                children: [
                                  leave.leaveID == null
                                      ? SizedBox.shrink()
                                      : Expanded(
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(foregroundColor: Colors.black),
                                            onPressed: () {
                                              leave.clearAllData(rmrkController: remarksController);
                                            },
                                            child: FittedBox(child: Text('New')),
                                          ),
                                        ),
                                  leave.leaveID == null
                                      ? SizedBox.shrink()
                                      : Expanded(
                                          child: islvLoading
                                              ? CircularProgressIndicator()
                                              : Padding(
                                                padding: const EdgeInsets.only(left:6.0),
                                                child: OutlinedButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        islvLoading = true;
                                                      });
                                                      final res = await leave.deleteLeaveRequest(leaveID: leave.leaveID!);
                                                      if (res != 'Error' || res != '409') {
                                                        leave.clearAllData(rmrkController: remarksController);
                                                        getLeaveData();
                                                        setState(() {
                                                          islvLoading = false;
                                                        });
                                                        CustomSnackBar(message: 'Successfully Deleted Leave Application', isSuccess: true).show();
                                                      } else {
                                                        CustomSnackBar(message: 'Operation Failed', isSuccess: false).show();
                                                      }
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      //size: 18,
                                                    )),
                                              )),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: SizedBox(
                                        height: leave.leaveID != null ? 40 : 50,
                                        child: CustomButtonRounded(
                                          title: leave.leaveID == null ? 'Submit' : 'Update',
                                          onPress: () async {
                                            if (leave.forapiFromDate == null || leave.forapiTodate == null) {
                                              CustomSnackBar(message: 'From Date or To date must not be empty', isSuccess: false).show();
                                            } else if (remarksController.text.isEmpty) {
                                              CustomSnackBar(message: 'Please add a remarks', isSuccess: false).show();
                                            } else if (leave.selectedLeaveType == null) {
                                              CustomSnackBar(message: 'Please select leave Type', isSuccess: false).show();
                                            } else if (leave.selectedExenID == null) {
                                              CustomSnackBar(message: 'Please select ExEN', isSuccess: false).show();
                                            } else {
                                              if (leave.leaveID == null) {
                                                setState(() {
                                                  islvLoading = true;
                                                });
                                                final isSuccessResponse = await leave.leaveRequest(
                                                  exenId: leave.selectedExenID!,
                                                  // exenId: getExnID!,
                                                  leaveType: leave.selectedLeaveType!,
                                                  fromDate: leave.forapiFromDate!,
                                                  toDate: leave.forapiTodate!,
                                                  description: remarksController.text,
                                                );
                                                if (isSuccessResponse == null) {
                                                  setState(() {
                                                    islvLoading = false;
                                                  });
                                                  CustomSnackBar(message: 'Failed', isSuccess: false).show();
                                                } else if (isSuccessResponse.statusCode == 409) {
                                                  setState(() {
                                                    islvLoading = false;
                                                  });

                                                  if (context.mounted) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return LvAlertDialogWidget(
                                                          lvRes: isSuccessResponse,
                                                          islvReqPage: true,
                                                        );
                                                      },
                                                    );
                                                  }

                                                  // CustomSnackBar(message: '${isSuccessResponse.message} On ${isSuccessResponse.date}', isSuccess: false).show();
                                                } else {
                                                  leave.clearAllData(rmrkController: remarksController);
                                                  getLeaveData();
                                                  if(context.mounted) Navigator.pop(context);
                                                  setState(() {
                                                    islvLoading = false;
                                                  });
                                                  CustomSnackBar(message: 'Successfully created Leave Application', isSuccess: true).show();
                                                }
                                              } else {
                                                setState(() {
                                                  islvLoading = true;
                                                });
                                                final lvRes = await leave.updateLeave(
                                                    //  exenId: leave.selectedExenID!,
                                                    // exenId: getExnID!,
                                                    leaveID: leave.leaveID,
                                                    leaveType: leave.selectedLeaveType!,
                                                    fromDate: leave.forapiFromDate!,
                                                    toDate: leave.forapiTodate!,
                                                    description: remarksController.text,
                                                    exenID: leave.selectedExenID!,
                                                    context: context);

                                                if (lvRes != null) {
                                                  setState(() {
                                                    islvLoading = false;
                                                  });
                                                  leave.clearAllData(rmrkController: remarksController);
                                                  getLeaveData();
                                                  if (context.mounted) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return LvAlertDialogWidget(
                                                          lvRes: lvRes,
                                                          islvReqPage: true,
                                                        );
                                                      },
                                                    );
                                                  }

                                                  // CustomSnackBar(message: 'Failed', isSuccess: false).show();
                                                } else {
                                                  leave.clearAllData(rmrkController: remarksController);
                                                  getLeaveData();
                                                  setState(() {
                                                    islvLoading = false;
                                                  });
                                                  if (context.mounted) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return LvAlertDialogWidget(
                                                          lvRes: lvRes!,
                                                          islvReqPage: true,
                                                        );
                                                      },
                                                    );
                                                  }

                                                  // CustomSnackBar(message: 'Successfully Updated Leave Application', isSuccess: true).show();
                                                }
                                              }
                                            }
                                            FocusManager.instance.primaryFocus?.unfocus();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // leave.leaveDataList.isEmpty
                //     ? Align(alignment: Alignment.bottomCenter, child: Text('No Previous Data Available'))
                //     : Container(
                //         // height: size.height / 2,
                //         // width: size.width,
                //         child: SingleChildScrollView(
                //           child: Column(
                //             children: [
                //               Row(
                //                 children: [
                //                   IconButton(
                //                       onPressed: () {
                //                         leave.clearAllData(rmrkController: remarksController);
                //                         getLeaveData();
                //                       },
                //                       icon: Icon(Icons.clear)),
                //                   Expanded(
                //                     child: InkWell(
                //                       onTap: () async {
                //                         await pickDate(ctx: context, provider: leave, isFromDate: true);
                //                       },
                //                       child: Container(
                //                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                //                         margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                //                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
                //                         child: Row(
                //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                           children: [
                //                             leave.forapiFromDate != null
                //                                 ? Expanded(
                //                                     child: Padding(
                //                                       padding: const EdgeInsets.symmetric(horizontal: 4),
                //                                       child: FittedBox(
                //                                         child: Text(
                //                                           '${DateConverter.dateFromForAPi(leave.forapiFromDate!)}',
                //                                           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                //                                         ),
                //                                       ),
                //                                     ),
                //                                   )
                //                                 : Text(
                //                                     'From :',
                //                                     style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                //                                   ),
                //                             leave.forapiFromDate != null ? SizedBox.shrink() : Icon(Icons.calendar_month_rounded)
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                   // SizedBox(
                //                   //   height: 10,
                //                   // ),
                //                   Expanded(
                //                     child: InkWell(
                //                       onTap: () async {
                //                         await pickDate(ctx: context, provider: leave, isFromDate: false);
                //                       },
                //                       child: Container(
                //                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                //                         margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                //                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
                //                         child: Row(
                //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                           children: [
                //                             leave.forapiTodate != null
                //                                 ? Expanded(
                //                                     child: Padding(
                //                                       padding: const EdgeInsets.symmetric(horizontal: 4),
                //                                       child: FittedBox(
                //                                         child: Text(
                //                                           '${DateConverter.dateFromForAPi(leave.forapiTodate!)}',
                //                                           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                //                                         ),
                //                                       ),
                //                                     ),
                //                                   )
                //                                 : Text(
                //                                     'To :',
                //                                     style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                //                                   ),
                //                             leave.forapiTodate != null ? SizedBox.shrink() : Icon(Icons.calendar_month_rounded)
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                   IconButton(
                //                       style: IconButton.styleFrom(backgroundColor: MyColors.primaryColor, foregroundColor: Colors.white),
                //                       onPressed: () async {
                //                         await leave.getAllLeaveData(isFilter: true, formDate: leave.forapiFromDate, toDate: leave.forapiTodate);
                //                       },
                //                       icon: Icon(Icons.search))
                //                 ],
                //               ),
                              // Theme(
                              //   data: ThemeData(
                              //       cardTheme: CardTheme(
                              //         color: Colors.white,
                              //         shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(4),
                              //           side: BorderSide(
                              //             color: Colors.black,
                              //           ),
                              //         ),
                              //       ),
                              //       dataTableTheme: DataTableThemeData(
                              //         headingRowColor: MaterialStateProperty.all(MyColors.backgroundColor),
                              //         // decoration: BoxDecoration(border: Border.all(color: Colors.red))
                              //       )),
                              //   child: Padding(
                              //     padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                              //     child: PaginatedDataTable(
                              //       primary: false,

                              //       //header: ,
                              //       // dataRowMinHeight: 23,
                              //       // dataRowMaxHeight: 23,
                              //       // arrowHeadColor: MyColors.backgroundColor,
                              //       columns: [
                              //         DataColumn(
                              //           label: Row(
                              //             children: [
                              //               Text('From Date'),
                              //               // VerticalDivider()
                              //             ],
                              //           ),
                              //         ),
                              //         // DataColumn(label:VerticalDivider()),
                              //         DataColumn(
                              //             label: Row(
                              //           children: [
                              //             Text('To  Date'),

                              //             /// VerticalDivider()
                              //           ],
                              //         )),
                              //         //  DataColumn(label:VerticalDivider()),
                              //         DataColumn(
                              //             label: Row(
                              //           children: [
                              //             Text('Leave Type'),
                              //             //VerticalDivider()
                              //           ],
                              //         )),
                              //         //    DataColumn(label:VerticalDivider()),
                              //         DataColumn(
                              //             label: Row(
                              //           children: [
                              //             Text('Status'),
                              //             // VerticalDivider()
                              //           ],
                              //         )),
                              //       ],
                              //       source: UserDataTableSource(userData: leave.leaveDataList, context: context, rmrkController: remarksController),
                              //       // horizontalMargin: ( size.width / 10) * 0.5,
                              //       // columnSpacing: (size.width / 10) * 0.3,
                              //       horizontalMargin: (size.width / 10) * 0.7,
                              //       columnSpacing: size.width  * 0.034,
                              //       showCheckboxColumn: false,
                              //       //header: Container(color: Colors.blue,),

                              //       arrowHeadColor: Colors.black,

                              //       //header: Container(),
                              //       //checkboxHorizontalMargin: 15,
                              //       //showFirstLastButtons: true,

                              //       rowsPerPage: 3,
                              //     ),
                              //   ),
                              // )
                            //],
                         // ),
                       // ),
                    //  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future pickDate({required BuildContext ctx, required LeaveProvider provider, bool isFromDate = true}) async {
    DateTime? dateTime = await showDatePicker(
      context: ctx,
      firstDate: DateTime.now().subtract(const Duration(days: 60)),
      initialDate: isFromDate
          ? provider.forapiFromDate != null
              ? DateConverter.convertStringToDateFormat2(DateConverter.dateFormatFromAPi(provider.forapiFromDate!))
              : DateTime.now()
          : provider.forapiTodate != null
              ? DateConverter.convertStringToDateFormat2(DateConverter.dateFormatFromAPi(provider.forapiTodate!))
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
        provider.updateDates(dateTime, isFromDate: true);
      } else {
        provider.updateDates(dateTime);
      }
    }
    if (dateTime != null) {
      if (isFromDate) {
        if (!mounted) return;
        provider.onSavedDates(context, isFromDate: true);
      } else {
        if (!mounted) return;
        provider.onSavedDates(
          context,
        );
        if (provider.leaveID == null) {
          await provider.leaveOperation();
        } else {
          return;
        }
       
      }
    }
  }
}
