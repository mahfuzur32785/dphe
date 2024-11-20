import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:dphe/Data/models/common_models/dlc_model/lv_response_model.dart';
import 'package:dphe/components/custom_appbar/custom_appbar.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/helper/date_converter.dart';
import 'package:dphe/provider/leave_provider.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/users/dlc/attendance/attendance_details_table.dart';
import 'package:dphe/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool isloading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  bool isEnable = true;

  // getAttendance() async {
  //   final lv = Provider.of<LeaveProvider>(context, listen: false);
  //   isloading = true;
  //   await Provider.of<LeaveProvider>(context, listen: false).getUserAllAttendance(context);
  //   final isRealTime = await lv.timeComparison();
  //   if (isRealTime) {
  //      if(lv.attendanceDataList.isNotEmpty){
  //    if( lv.attendanceDataList.any((element) => DateConverter.formatDateIOS(element.checkIn!) == DateConverter.localDateToIsoString(DateTime.now()))){
  //     //setState(() {
  //       isEnable = false;
  //        isloading = false;
  //   //  });
  //    } else{
  //    // setState(() {
  //       isEnable = true;
  //        isloading = false;
  //   //  });
  //    }
  //   } else {
  //  //   setState(() {
  //       isEnable = true;
  //        isloading = false;
  //   //  });
  //   }
         
  //   }else{
  //     isEnable =false;
  //     isloading = false;
  //   }
  //   isloading = false;
  //   // setState(() {
      
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    Provider.of<LeaveProvider>(context, listen: false).getAttendance(context);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getAttendance();
    // });

    final size = MediaQuery.of(context).size;
    return Consumer2<LeaveProvider, OperationProvider>(builder: (context, att, op, child) {
      return Scaffold(
        appBar: CustomAppbar(
          title: 'Attendance',
          isAttendancePage: true,
        ),
        body: Container(
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Date :',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        '${DateConverter.dateFormatStyle2(DateTime.now())}',
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
              isloading
                  ? CircularProgressIndicator(
                      color: Colors.green,
                    )
                  : !att.isAttendanceBtnEnable ? SizedBox.shrink() :  SizedBox(//
                      width: size.width / 1.3,
                      height: 70,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                            onPressed: () async {
                              setState(() {
                                isloading = true;
                              });
                              final lvres = await att.giveAttendance(op: op, context: context, isCOnfirmation: false);
                              log('leave ${jsonEncode(lvres)}');
                              setState(() {
                                isloading = false;
                              });
                              if (lvres != null) {
                                if (context.mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return LvAlertDialogWidget(
                                        lvRes: lvres,
                                      );
                                    },
                                  );
                                }
                                // CustomSnackBar(isSuccess: true, message: lvres.message).show();
                              } else {
                                CustomSnackBar(isSuccess: false, message: 'Something went wrong').show();
                              }
                            },
                            child: Text('Give Attendance')),
                      ),
                    ),
              SizedBox(
                height: (size.height / 2) * 0.1,
              ),
              // att.attendanceDataList.isEmpty
              //     ? Center(child: Text('No Data Available'))
              //     :
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Attendance Data',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              att.isAttDataLoading
                  ? Center(child: CircularProgressIndicator())
                  :
                  att.attendanceDataList.isEmpty
                      ? Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text('No Attendance data found'),
                      )
                      :
                  Container(
                      // padding:  const EdgeInsets.symmetric(horizontal: 15),
                      child: Theme(
                        data: ThemeData(
                          cardTheme: CardTheme(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          dataTableTheme: DataTableThemeData(
                            headingRowColor: MaterialStateProperty.all(MyColors.backgroundColor),
                            // decoration: BoxDecoration(border: Border.all(color: Colors.red))
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                          child: PaginatedDataTable(
                            primary: false,
                            // header: Container(
                            //   width: size.width,
                            //   child: Text('Attendance '),
                            // ),

                            //header: ,
                            // dataRowMinHeight: 23,
                            // dataRowMaxHeight: 23,
                            // arrowHeadColor: MyColors.backgroundColor,
                            columns: [
                              DataColumn(
                                label: Row(
                                  children: [
                                    Text('Date'),
                                    // VerticalDivider()
                                  ],
                                ),
                              ),
                              // DataColumn(label:VerticalDivider()),
                              DataColumn(
                                  label: Row(
                                children: [
                                  Text('Check In'),

                                  /// VerticalDivider()
                                ],
                              )),
                               
                              DataColumn(
                                  label: Row(
                                children: [
                                  Text('Location'),
                                  //VerticalDivider()
                                ],
                              )),
                              // //    DataColumn(label:VerticalDivider()),
                              // DataColumn(
                              //     label: Row(
                              //   children: [
                              //     Text('Longitude'),
                              //     // VerticalDivider()
                              //   ],
                              // )),
                            ],
                            source: AttendanceDataTable(
                              userData: att.attendanceDataList,
                              context: context,
                            ),
                            horizontalMargin: (size.width / 10) * 0.6,
                            columnSpacing:(size.width / 10)  * 1.6,
                            showCheckboxColumn: false,
                            //header: Container(color: Colors.blue,),

                            arrowHeadColor: Colors.black,

                            //header: Container(),
                            //checkboxHorizontalMargin: 15,
                            //showFirstLastButtons: true,

                            rowsPerPage: 3,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }
}

class LvAlertDialogWidget extends StatelessWidget {
  final LeaveResponseMessageModel lvRes;
  final bool islvReqPage;

  const LvAlertDialogWidget({super.key, required this.lvRes, this.islvReqPage = false});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LeaveProvider, OperationProvider>(builder: (context, lv, op, child) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        scrollable: true,
        alignment: Alignment.center,
        actionsPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: MyColors.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              )),
          child: lvRes.statusCode != 409
              ? Text('Success', style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.w500))
              : Text(
                  'Alert ',
                  textScaleFactor: 1,
                  style: TextStyle(color: Color.fromARGB(255, 218, 51, 9), fontSize: 18, fontWeight: FontWeight.w500, letterSpacing: 2),
                ),
        ),
        content: Container(
          // height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.only(
            //   bottomLeft: Radius.circular(15),
            //   bottomRight: Radius.circular(15),
            // ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18),
                  child: Text(
                    lvRes.message!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
              ),
              !islvReqPage
                  ? lvRes.date != null
                      ? Column(
                          children: [
                            Text(
                              'Leave Found on these following dates,',
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            Wrap(
                              children: [
                                ...lv
                                    .getLvCondDates(lvRes.date)
                                    .map(
                                      (e) => Text(
                                        '${DateConverter.dateFormatFromAPi(e)} ',
                                      ),
                                    )
                                    .toList(),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Do you really want to give Attendance in this date ?',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink()
                  : lvRes.date != null
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Attendance Found on these following dates,',
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                children: [
                                  ...lvRes.date
                                      .map(
                                        (e) => Text(
                                          '${DateConverter.dateFormatFromAPi(e)} ',
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
            ],
          ),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(7),
                bottomRight: Radius.circular(7),
              ),
            ),
            child: Row(
              mainAxisAlignment: !islvReqPage
                  ? lvRes.date != null
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center
                  : MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: !islvReqPage ? lvRes.date != null ?  MainAxisAlignment.spaceBetween : MainAxisAlignment.center  : MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                          child: SizedBox(
                            height: 30,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Back'),
                            ),
                          ),
                        ),
                        !islvReqPage ? SizedBox() : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
                !islvReqPage
                    ? lvRes.date != null
                        ? lv.isdiagLoading
                            ? CircularProgressIndicator()
                            : Expanded(
                                child: Container(
                                  // padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(bottomRight: Radius.circular(7))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                          height: 30,
                                          child: VerticalDivider(
                                            color: Colors.black,
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: 30,
                                          child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  foregroundColor: Colors.green,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
                                              onPressed: () async {
                                                lv.setDiagLoading(isLoading: true);
                                                final lvres = await lv.giveAttendance(op: op, context: context, isCOnfirmation: true);
                                                if (lvres != null) {
                                                  if (context.mounted) {
                                                    await Provider.of<LeaveProvider>(context, listen: false).getUserAllAttendance(context);
                                                  }
                                                  if (context.mounted) Navigator.pop(context);

                                                  CustomSnackBar(isSuccess: true, message: 'Successfully Attendance given');
                                                }
                                                lv.setDiagLoading(isLoading: false);
                                              },
                                              child: Text('OK')),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                        : SizedBox.shrink()
                    : SizedBox.shrink(),
              ],
            ),
          )
        ],
      );
    });
  }
}
