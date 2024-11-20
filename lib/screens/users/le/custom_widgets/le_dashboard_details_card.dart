import 'dart:developer';

import 'package:dphe/Data/models/common_models/dlc_model/beneficiary_model.dart';
import 'package:dphe/api/le_dashboard_api/le_dashboard_api.dart';
import 'package:dphe/components/common_widgets/common_widgets.dart';
import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/components/custom_loader/custom_loader.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/offline_database/db_tables/le_tables/latrine_progress_table.dart';
import 'package:dphe/provider/le_providers/le_dashboard_provider.dart';
import 'package:dphe/provider/network_connectivity_provider/network_connectivity_provider.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/users/le/le_dashboard/le_qsn_screen.dart';
import 'package:dphe/screens/users/le/le_dashboard/new_latrine_progress_screen.dart';
import 'package:dphe/screens/users/le/le_dashboard/send_to_verify_page.dart';
import 'package:dphe/screens/users/le/le_dashboard/submit_otp.dart';
import 'package:dphe/screens/users/le/le_dashboard/update_screening.dart';
import 'package:dphe/utils/app_strings.dart';
import 'package:dphe/utils/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../../../Data/models/le_models/benificiary_models/non_selected_benificiary_list_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../components/custom_buttons/custom_status_button.dart';
import '../../../../utils/common_functions.dart';

class LeDashboardDetailsCard extends StatefulWidget {
  final int index;
  final bool isNetworkConnected;
  final BeneficiaryDetailsData beneficiary;
  // final NonSelectedBeneficiaryListData beneficiary;
  const LeDashboardDetailsCard({super.key, required this.index, required this.beneficiary, required this.isNetworkConnected});

  @override
  State<LeDashboardDetailsCard> createState() => _LeDashboardDetailsCardState();
}

class _LeDashboardDetailsCardState extends State<LeDashboardDetailsCard> {
  bool isSelectBenfonListItem = false;
  bool isShuruKorunLoading = false;
  bool ischolomanloading = false;
 
  // bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Consumer2<OperationProvider, LeDashboardProvider>(builder: (context, op, lep, child) {
      return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 9),
        decoration: BoxDecoration(
            color: MyColors.cardBackgroundColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: MyColors.customGreyLight, width: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text('${widget.beneficiary.id}'),
            op.isConnected
                ? Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          widget.beneficiary.banglaname ?? "Unknown name",
                          //overflow: TextOverflow.ellipsis,
                          style: MyTextStyle.primaryBold(fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "মোবাইল : ${CommonFunctions.convertNumberToBangla(widget.beneficiary.phone ?? 00000000)}",
                          style: MyTextStyle.primaryLight(fontSize: 16),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          widget.beneficiary.banglaname ?? "Unknown name",
                          //overflow: TextOverflow.ellipsis,
                          style: MyTextStyle.primaryBold(fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "মোবাইল : ${CommonFunctions.convertNumberToBangla(widget.beneficiary.phone ?? 00000000)}",
                          style: MyTextStyle.primaryLight(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text('নাম (ইংরেজি) :', style: MyTextStyle.primaryLight(fontSize: 16)),
                Text(
                  '${widget.beneficiary.name ?? "Unknown name"}',
                  style: MyTextStyle.primaryLight(fontSize: 16),
                )
              ],
            ),
            Text(
              "এন আই ডি : ${CommonFunctions.convertNumberToBangla(widget.beneficiary.nid ?? 00000000000)}",
              textScaleFactor: 1,
              style: MyTextStyle.primaryLight(fontSize: 16),
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
            // widget.isNetworkConnected == true
            op.isConnected
                ? Text(
                    "জেলা: ${widget.beneficiary.district?.bnName ?? ""}, উপজেলা: ${widget.beneficiary.upazila?.bnName ?? ""}, ইউনিয়ন: ${widget.beneficiary.union?.bnName ?? ""},ওয়ার্ড: ${widget.beneficiary.wardNo ?? ''}, বাসা/বাড়ি: ${widget.beneficiary.houseName ?? "--"}",
                    style: MyTextStyle.primaryLight(fontSize: 16),
                  ) //ওয়ার্ড: ${widget.beneficiary.wardId},
                : Text(
                    "জেলা: ${widget.beneficiary.district?.bnName ?? ""}, উপজেলা: ${widget.beneficiary.upazila?.bnName ?? ""}, ইউনিয়ন: ${widget.beneficiary.union?.bnName ?? ""},ওয়ার্ড: ${widget.beneficiary.wardNo ?? ''}, বাসা/বাড়ি: ${widget.beneficiary.houseName ?? "--"}",
                    style: MyTextStyle.primaryLight(fontSize: 16),
                  ),
            const SizedBox(
              height: 5,
            ),
            if (widget.beneficiary.statusId == 6) ...[
              Align(
                  alignment: Alignment.centerRight,
                  child: isSelectBenfonListItem
                      ? CircularProgressIndicator()
                      : CustomStatusButton(
                          title: "Select",
                          bgColor: MyColors.customDeepBlue,
                          onPress: () async {
                            setState(() {
                              isSelectBenfonListItem = true;
                            });
                            log('ben id ${widget.beneficiary.id}');
                            //await Future.delayed(Duration(seconds: 2));
                            await lep.selectBeneficiary(id: widget.beneficiary.id ?? 0, index: widget.index);
                            //CustomSnackBar(message: 'Successfully selected',isSuccess: true).show();
                            setState(() {
                              isSelectBenfonListItem = false;
                            });
                          })),
            ] else if (widget.beneficiary.statusId == 9) ...[
              // if status is 3/approved submit otp button will appear
              Align(
                  alignment: Alignment.centerRight,
                  child: widget.beneficiary.otpVerified != 1
                      ? isShuruKorunLoading
                          ? CircularProgressIndicator()
                          : CustomStatusButton(
                              title: AppStrings.suruKorun,
                              bgColor: MyColors.customRed,
                              onPress: () async {
                                final navigator = Navigator.of(context);
                                final isConnected = await NetworkConnectivity().checkConnectivity();
                                if (isConnected == true) {
                                  setState(() {
                                    isShuruKorunLoading = true;
                                  });
                                  final res = await LeDashboardApi().generateOtp(beneficiaryId: widget.beneficiary.id!);
                                  if (res == "200") {
                                    setState(() {
                                      isShuruKorunLoading = false;
                                    });
                                    navigator.push(MaterialPageRoute(
                                        builder: (builder) => SubmitOtpScreen(
                                              beneficiary: widget.beneficiary,
                                            )));
                                  } else {
                                    setState(() {
                                      isShuruKorunLoading = false;
                                    });
                                    return;
                                  }
                                } else {
                                  setState(() {
                                    isShuruKorunLoading = false;
                                  });
                                  CustomSnackBar(message: AppStrings.connectWithInternet, isSuccess: false).show();
                                }
                              })
                      : CustomStatusButton(
                          width: MediaQuery.of(context).size.width / 2,
                          title: "স্ক্রীনিং প্রশ্নের উত্তর দিন",
                          bgColor: MyColors.customRed,
                          onPress: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (builder) => LeQsnScreen(
                                      beneficiaryId: widget.beneficiary.id!,
                                    )));
                          })),
            ]
            // else if(widget.beneficiary.statusId==null)...[
            //   Align(
            //       alignment: Alignment.centerRight,
            //       child: CustomStatusButton(title: "Start Work", bgColor: MyColors.primaryColor,onPress: (){})),
            // ]
            else if (widget.beneficiary.statusId == 10) ...[
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomStatusButton(
                          width: 200,
                          title: 'স্ক্রীনিং প্রশ্ন সম্পাদনা করুন',
                          onPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateScreeningQuestionScreen(beneficiary: widget.beneficiary),
                                ));
                          },
                        ),
                      ),
                      ischolomanloading
                          ? CircularProgressIndicator()
                          : CustomStatusButton(
                              width: 250,
                              title: widget.beneficiary.isSendBack == 1 ? AppStrings.sendbkupd : AppStrings.update,
                              bgColor: widget.beneficiary.isSendBack == 1 ? MyColors.resubmit : MyColors.customGreenLight,
                              onPress: () async {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (builder) => SendToVerifyPage(
                                //           beneficiary: widget.beneficiary,
                                //         )));
                                setState(() {
                                  ischolomanloading = true;
                                });
                                final res = await LatrineProgressTable().getSingleImage(beneficiaryId: widget.beneficiary.id!);
                                if (res == null) {
                                  final res = await LatrineProgressTable().insertImage(
                                    beneficiaryId: widget.beneficiary.id!.toInt(),
                                    isCompleted: 0,
                                    photoStep1: "",
                                    photoStep2: "",
                                    photoStep3: "",
                                    photoStep4: "",
                                    photoStep5: "",
                                    photoStep1sts: "",
                                    photoStep2sts: "",
                                    photoStep3sts: "",
                                    photoStep4sts: "",
                                    photoStep5sts: "",
                                    latitude: "",
                                    longitude: "",
                                    latitude2: "",
                                    longitude2: "",
                                  );
                                  print(res);
                                  // await updateImgFrmInternet(beneficiaryId: element.id!, op: op);
                                  print('img upd done');
                                  setState(() {
                                    ischolomanloading = false;
                                  });
                                } else {
                                  if (op.isConnected) {
                                     final recheckNetwork = await LeDashboardApi().recheckInternetConnection();
                                     if (recheckNetwork) {
                                       await lep.updateImgFrmInternet(beneficiaryId: widget.beneficiary.id!, op: op);
                                     }
                                    
                                  }
                                  setState(() {
                                    ischolomanloading = false;
                                  });
                                }
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (builder) => LatrineProgress(
                                          beneficiary: widget.beneficiary,
                                          benficiaryID: widget.beneficiary.id!,
                                        )));

                                //await LatrineProgressTable().dropTable();
                                //  final res = await LatrineProgressTable().getSingleImage(beneficiaryId:  widget.beneficiary.id!);
                                //  if (res == null) {
                                //    final res = await LatrineProgressTable().insertImage(
                                //     beneficiaryId: widget.beneficiary.id!.toInt(),
                                //     isCompleted: 0,
                                //     photoStep1: "",
                                //     photoStep2: "",
                                //     photoStep3: "",
                                //     photoStep4: "",
                                //     photoStep5: "",
                                //     photoStep1sts: "",
                                //     photoStep2sts: "",
                                //     photoStep3sts: "",
                                //     photoStep4sts: "",
                                //     photoStep5sts: "",
                                //     latitude: "",
                                //     longitude: "");
                                // print(res);
                                //  } else {
                                //    return;
                                //  }
                              }),
                    ],
                  ),
                ),
              ),
            ] else if (widget.beneficiary.statusId == 7) ...[
              Align(alignment: Alignment.centerRight, child: customStatus(status: AppStrings.nirbachito, bgColor: MyColors.customDeepBlue)),
            ] else if (widget.beneficiary.statusId == 8) ...[
              Align(alignment: Alignment.centerRight, child: customStatus(status: AppStrings.forwarded, bgColor: MyColors.yellowf0ad4e)),
            ] else if (widget.beneficiary.statusId == 11) ...[
              Align(alignment: Alignment.centerRight, child: customStatus(status: AppStrings.bibechonadhin, bgColor: MyColors.customGreenLight)),
            ] else if (widget.beneficiary.statusId == 12) ...[
              Align(alignment: Alignment.centerRight, child: customStatus(status: AppStrings.verified, bgColor: MyColors.customGreen)),
            ] else if (widget.beneficiary.statusId == 14) ...[
              Align(alignment: Alignment.centerRight, child: customStatus(status: AppStrings.verified, bgColor: MyColors.customGreen)),
            ] else if (widget.beneficiary.statusId == 15) ...[
              Align(alignment: Alignment.centerRight, child: customStatus(status: AppStrings.verified, bgColor: MyColors.customGreen)),
            ] else if (widget.beneficiary.statusId == 16) ...[
              Align(alignment: Alignment.centerRight, child: customStatus(status: AppStrings.verified, bgColor: MyColors.customGreen)),
            ] else if (widget.beneficiary.statusId == 17) ...[
              Align(alignment: Alignment.centerRight, child: customStatus(status: AppStrings.praptoBill, bgColor: MyColors.customRed)),
            ]
          ],
        ),
      );
    });
  }
}
