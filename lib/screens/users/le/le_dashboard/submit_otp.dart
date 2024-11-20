import 'dart:async';

import 'package:dphe/Data/models/common_models/dlc_model/beneficiary_model.dart';
import 'package:dphe/components/custom_appbar/custom_appbar_inner.dart';
import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/helper/date_converter.dart';
import 'package:dphe/provider/le_providers/le_dashboard_provider.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/users/le/le_dashboard/le_qsn_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../api/le_dashboard_api/le_dashboard_api.dart';
import '../../../../Data/models/le_models/benificiary_models/non_selected_benificiary_list_model.dart';
import '../../../../offline_database/db_tables/le_tables/beneficiary_list_table.dart';
import '../../../../utils/api_constant.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/custom_text_style.dart';
import '../../../../utils/local_storage_manager.dart';

class SubmitOtpScreen extends StatefulWidget {
  // final NonSelectedBeneficiaryListData beneficiary;
  final BeneficiaryDetailsData beneficiary;
  const SubmitOtpScreen({Key? key, required this.beneficiary}) : super(key: key);

  @override
  State<SubmitOtpScreen> createState() => _SubmitOtpScreenState();
}

class _SubmitOtpScreenState extends State<SubmitOtpScreen> {
  TextEditingController emailController = TextEditingController();
  String verificationCode = '';
  List<String> verificationCodeList = [];
  bool showWarning = false;
  int minutes = 3;
  int seconds = 0;
  late Timer timer;
  late int _counter;
  late DateTime _otpTime;
  late Timer _timer;
  int _minutes = 0;
  int _seconds = 0;

  @override
  void initState() {
    // TODO: implement initState
    verificationCodeList.clear();
    super.initState();
    // _loadTimeAndStartCounter();
    startTimer();
  }

  void _loadTimeAndStartCounter() async {
    final storedTime = await LocalStorageManager.readData(ApiConstant.storedTimeOtp);

    if (storedTime != null) {
      _otpTime = DateTime.fromMillisecondsSinceEpoch(storedTime);
      startTimer();
    } else {
      _otpTime = DateTime.now();
      // Handle if time is not available
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    var totalDuration = Duration(minutes: 1);

    // final currentTime = DateTime.now();
    // final timeDifference = currentTime.difference(_otpTime);
    // const otpValidityDuration = Duration(minutes: 3);
    // var totalDuration = otpValidityDuration - timeDifference;

    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (totalDuration.inSeconds == 0) {
            timer.cancel();
            // You can add code here to execute when the countdown reaches 0.
          } else {
            totalDuration -= oneSec;
            minutes = totalDuration.inMinutes;
            seconds = totalDuration.inSeconds % 60;
          }
        });
      },
    );
  }

  // void startTimer() {
  //   final currentTime = DateTime.now();
  //   final timeDifference = currentTime.difference(_otpTime);
  //   const otpValidityDuration = Duration(minutes: 3);
  //   var remainingTime = otpValidityDuration - timeDifference;
  //    _minutes = remainingTime.inMinutes;
  //   _seconds = remainingTime.inSeconds % 60;
  //   const oneSec = const Duration(seconds: 1);
  //   var totalDuration = Duration(minutes: 1);
  //    timer = Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //      setState(() {
  //       if (_seconds > 0) {
  //         _seconds--;
  //       } else {
  //         if (_minutes > 0) {
  //           _minutes--;
  //           _seconds = 59;
  //         } else {
  //           timer.cancel();
  //           // Handle OTP expiration
  //         }
  //       }
  //     });
  //     },
  //   );

  //   // timer = Timer.periodic(
  //   //   oneSec,
  //   //   (Timer timer) {
  //   //     setState(() {
  //   //       if (totalDuration.inSeconds == 0) {
  //   //         timer.cancel();
  //   //         // You can add code here to execute when the countdown reaches 0.
  //   //       } else {
  //   //         totalDuration -= oneSec;
  //   //         minutes = totalDuration.inMinutes;
  //   //         seconds = totalDuration.inSeconds % 60;
  //   //       }
  //   //     });
  //   //   },
  //   // );
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LeDashboardProvider, OperationProvider>(builder: (context, lep, op, child) {
      return WillPopScope(
        onWillPop: () async {
          LocalStorageManager.saveData(ApiConstant.storedTimeOtp, DateTime.now().millisecondsSinceEpoch);
          return true;
        },
        child: Scaffold(
          appBar: const CustomAppbarInner(
            title: "Submit OTP",
          ),
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: MyColors.customGreyLight)),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "${widget.beneficiary.banglaname}",
                          style: MyTextStyle.primaryBold(fontSize: 17),
                        ),
                      ),
                      Text(
                        "মোবাইল : ${widget.beneficiary.phone}",
                        style: MyTextStyle.primaryLight(fontSize: 17),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Name:',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "${widget.beneficiary.name}",
                          style: MyTextStyle.primaryLight(fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                  
                  Row(
                    children: [
                      Text('পিতা/স্বামীর নাম :', style: MyTextStyle.primaryLight(fontSize: 16)),
                      Text(
                        ' ${widget.beneficiary.fatherOrHusbandName ?? "Unknown name"}',
                        style: MyTextStyle.primaryLight(fontSize: 16),
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "এন আই ডি : ${widget.beneficiary.nid}",
                    style: MyTextStyle.primaryLight(fontSize: 12),
                  ),

                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "ঠিকানা: , জেলা: ${widget.beneficiary.district?.bnName ?? ""}, উপজেলা: ${widget.beneficiary.upazila?.bnName ?? ""}, ইউনিয়ন: ${widget.beneficiary.union?.bnName ?? ""}, বাসা/বাড়ি: ${widget.beneficiary.address ?? "--"}",
                    style: MyTextStyle.primaryLight(fontSize: 12),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _verifyField(index: 0, first: true, last: false),
                      _verifyField(index: 1, first: false, last: false),
                      _verifyField(index: 2, first: false, last: false),
                      _verifyField(index: 3, first: false, last: false),
                      _verifyField(index: 4, first: false, last: false),
                      _verifyField(index: 5, first: false, last: true),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'The OTP will expire in:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '$minutes:${seconds.toString().padLeft(2, '0')}',
                        ),
                      ),
                    ],
                  ),
                  //const SizedBox(height: 15,),
                  showWarning
                      ? Text(
                          "All fields are required",
                          style: MyTextStyle.primaryLight(fontColor: MyColors.customRed, fontWeight: FontWeight.normal, fontSize: 16),
                        )
                      : const SizedBox(),

                  //TextButton(onPressed: (){}, child: Text("Resend Code", )),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButtonRounded(
                      title: AppStrings.verify,
                      onPress: () async {
                        if (verificationCodeList.length == 6) {
                          setState(() {
                            showWarning = false;
                            verificationCode = verificationCodeList[0] +
                                verificationCodeList[1] +
                                verificationCodeList[2] +
                                verificationCodeList[3] +
                                verificationCodeList[4] +
                                verificationCodeList[5];
                          });
                          final res = await LeDashboardApi().verifyOtp(beneficiaryId: widget.beneficiary.id!, otp: verificationCode);
                          if (res == "200") {
                            await BeneficiaryListTable().updateBeneficiary(id: widget.beneficiary.id!, otpVerified: 1);
                            //lep.nonSelectedBeneficiaryList.clear();
                            lep.lePaginatedRefresh();
                           await lep.fetchNonSelectedPaginatedLeBenf(statusIdList: [3], op: op);
                            // Provider.of<LeDashboardProvider>(context, listen: false)
                            //     .getNonSelectedBeneficiaryList(statusIdList: [3],
                            //     // pageNo: 1,rows: 15,
                            //     );
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (builder) => LeQsnScreen(
                                      beneficiaryId: widget.beneficiary.id!,
                                    )));
                          }
                        } else {
                          setState(() {
                            showWarning = true;
                          });
                        }
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  Consumer<LeDashboardProvider>(builder: (context, controller, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "এখনো ভেরিফিকেশন কোড পাননি? ",
                          style: MyTextStyle.primaryLight(fontSize: 13),
                        ),
                        timer.isActive
                            ? SizedBox.shrink()
                            : InkWell(
                                onTap: () async {
                                  await LeDashboardApi().generateOtp(beneficiaryId: widget.beneficiary.id!);
                                  startTimer();
                                  //controller.startCountdownTimer();
                                },
                                child: Text(
                                  "RESEND",
                                  style: MyTextStyle.blueLight(fontSize: 14),
                                )),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _verifyField({required int index, required bool first, required bool last}) {
    return SizedBox(
      height: 60,
      //width: 50,
      child: AspectRatio(
        aspectRatio: 0.7,
        child: TextField(
          autofocus: true,
          //showCursor: false,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }

            // storing value
            if (value.length == 1 && verificationCodeList.length < 6) {
              verificationCodeList.insert(index, value);
            }
            if (value.length == 0) {
              verificationCodeList.removeAt(index);
            }
            print("verificationCode : $verificationCodeList");
          },
          readOnly: false,
          maxLength: 1,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            counter: Offstage(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(7),
              ),
              borderSide: BorderSide(
                color: MyColors.secondaryTextColor,
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(7),
              ),
              borderSide: BorderSide(
                color: MyColors.secondaryColor,
                width: 0.9,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
