import 'dart:convert';
import 'dart:developer';

import 'package:dphe/Data/models/common_models/dlc_model/beneficiary_model.dart';
import 'package:dphe/components/common_widgets/common_widgets.dart';
import 'package:dphe/components/custom_appbar/custom_appbar.dart';
import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/provider/hive_provider.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/users/dlc/dlc_hhs_verification/twin_pit_le.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../Data/models/hiveDbModel/dlc_ph_verify_model.dart';
import '../../../../utils/app_constant.dart';
import '../../../../utils/custom_text_style.dart';

class DlcVerificationPage extends StatefulWidget {
  final BeneficiaryDetailsData? beneficiaryData;
  final PhysicalVerifyModelHive? localBenfData;
  final int? localIndex;

  const DlcVerificationPage({
    super.key,
    this.beneficiaryData,
    this.localBenfData,
    this.localIndex,
  });

  @override
  State<DlcVerificationPage> createState() => _DlcVerificationPageState();
}

class _DlcVerificationPageState extends State<DlcVerificationPage> {
  int selectedValue = -1;
  List<int> answerList = [];
  final reasonController = TextEditingController();
  bool isVerifLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDlcQuestions();
    //getD();
  }

  getLocationServiceStatus() {
    final op = Provider.of<OperationProvider>(context, listen: false);
    op.locationServiceStatusStream();
  }

  getDlcQuestions() async {
    final op = Provider.of<OperationProvider>(context, listen: false);
    final local = Provider.of<LocalStoreHiveProvider>(context, listen: false);
    await op.getDlcQuestionsForPhysicalVerify(local, op);
    //vif (context.mounted) await op.getSendBackList(id: widget.benfData!.id!, context: context);
  }

  getD() {
    final local = Provider.of<LocalStoreHiveProvider>(context, listen: false);
    local.phVerifBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // getDlcQuestions();
    return Consumer2<OperationProvider, LocalStoreHiveProvider>(builder: (context, op, local, child) {
      return WillPopScope(
        onWillPop: () async {
          op.clearDlcQuesAns();
          // await op.fetchPaginatedBenfData(
          //     distID: widget.beneficiaryData!.districtId!, upazilaID: widget.beneficiaryData!.upazilaId!, statusID: 1, local: local);
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: CustomAppbar(
            title: 'Pending for verify',
            istwnpitDlcVerification: true,
          ),
          body: Container(
            height: size.height,
            width: size.width,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  // op.isConnected
                  //     ?
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: customCard(
                      horizontalMargin: 8,
                      verticalMargin: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                widget.beneficiaryData?.name ?? "Unknown name",
                                style: MyTextStyle.primaryBold(fontSize: 20),
                              )),
                              // Text(
                              //   "Mobile : ${widget.beneficiaryData?.phone ?? 000000}",
                              //   style: MyTextStyle.primaryLight(fontSize: 11),
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Mobile'),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(':'),
                                  ),
                                  Text('${widget.beneficiaryData?.phone ?? 000000}')
                                ],
                              ),
                              Row(
                                children: [
                                  Text('NID'),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(':'),
                                  ),
                                  Text('${widget.beneficiaryData?.nid ?? 000000}'),
                                ],
                              ),
                              // Text(
                              //   "Mobile : ${widget.beneficiaryData?.phone ?? 000000}",
                              //   style: MyTextStyle.primaryLight(fontSize: 17),
                              // ),
                              // Text(
                              //   "NID : ${widget.beneficiaryData?.nid ?? 000000}",
                              //   style: MyTextStyle.primaryLight(fontSize: 17),
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: RichText(
                                text: TextSpan(
                                    text: 'Address : ',
                                    style: TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
                                    children: [
                                  TextSpan(
                                      style:
                                          TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                      children: [
                                        TextSpan(
                                          text: '${widget.beneficiaryData?.houseName ?? ''}, ',
                                          style: TextStyle(
                                              fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 18),
                                        ),
                                      ]),
                                  TextSpan(
                                      text: 'Ward: ',
                                      style:
                                          TextStyle(fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                      children: [
                                        TextSpan(
                                          text: '${widget.beneficiaryData?.wardNo ?? ''}, ',
                                          style: TextStyle(
                                              fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                        ),
                                      ]),
                                  op.isConnected
                                      ? TextSpan(
                                          style: TextStyle(
                                              fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                          children: [
                                              TextSpan(
                                                text: '${widget.beneficiaryData?.union?.name ?? ''}, ',
                                                style: TextStyle(
                                                    fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                              ),
                                            ])
                                      : TextSpan(
                                          style: TextStyle(
                                              fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                          children: [
                                              TextSpan(
                                                text: '${widget.beneficiaryData?.union?.name ?? ''}, ',
                                                style: TextStyle(
                                                    fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                              ),
                                            ]),
                                  op.isConnected
                                      ? TextSpan(
                                          style: TextStyle(
                                              fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                          children: [
                                              TextSpan(
                                                text: '${widget.beneficiaryData?.upazila!.name}, ',
                                                style: TextStyle(
                                                    fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                              ),
                                            ])
                                      : TextSpan(
                                          style: TextStyle(
                                              fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                          children: [
                                              TextSpan(
                                                text: '${widget.beneficiaryData?.upazila!.name}, ',
                                                style: TextStyle(
                                                    fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                              ),
                                            ]),
                                  op.isConnected
                                      ? TextSpan(
                                          style: TextStyle(
                                              fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                          children: [
                                            TextSpan(
                                              text: '${widget.beneficiaryData?.district?.name} ',
                                              style: TextStyle(
                                                  fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                            ),
                                          ],
                                        )
                                      : TextSpan(
                                          style: TextStyle(
                                              fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                          children: [
                                            TextSpan(
                                              text: '${widget.beneficiaryData?.district?.name} ',
                                              style: TextStyle(
                                                  fontFamily: AppConstant.roboto, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                            ),
                                          ],
                                        ),
                                ])),
                          )
                          // Wrap(
                          //   // alignment: WrapAlignment.start,
                          //   direction: Axis.horizontal,

                          //   children: [
                          //     AddressCardTextWidget(
                          //       title: 'Address :',
                          //     ),
                          //     AddressCardTextWidget(
                          //       title: 'District :',
                          //     ),
                          //     AddressCardTextWidget(
                          //       title: '${widget.beneficiaryData?.district?.name},',
                          //     ),
                          //     AddressCardTextWidget(
                          //       title: 'Upazila :',
                          //     ),
                          //     AddressCardTextWidget(
                          //       title: '${widget.beneficiaryData?.upazila!.name},',
                          //     ),
                          //     AddressCardTextWidget(title: 'Union :'),
                          //     AddressCardTextWidget(title: '${widget.beneficiaryData?.union?.name ?? ''}'),
                          //     AddressCardTextWidget(title: 'House :'),
                          //     AddressCardTextWidget(title: '${widget.beneficiaryData?.houseName ?? ''}')
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                  // : Container(
                  //     decoration: BoxDecoration(color: Colors.white),
                  //     child: customCard(
                  //       horizontalMargin: 8,
                  //       verticalMargin: 8,
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Row(
                  //             children: [
                  //               Expanded(
                  //                   child: Text(
                  //                 widget.localBenfData?.benfName ?? "Unknown name",
                  //                 style: MyTextStyle.primaryBold(fontSize: 15),
                  //               )),
                  //               Text(
                  //                 "Mobile : ${widget.localBenfData?.benfMobileNo ?? 000000}",
                  //                 style: MyTextStyle.primaryLight(fontSize: 11),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 5,
                  //           ),
                  //           Text(
                  //             "NID : ${widget.localBenfData?.benfNID ?? 000000}",
                  //             style: MyTextStyle.primaryLight(fontSize: 10),
                  //           ),
                  //           const SizedBox(
                  //             height: 8,
                  //           ),
                  //           Wrap(
                  //             // alignment: WrapAlignment.start,
                  //             direction: Axis.horizontal,

                  //             children: [
                  //               AddressCardTextWidget(
                  //                 title: 'Address :',
                  //               ),
                  //               AddressCardTextWidget(
                  //                 title: 'District :',
                  //               ),
                  //               // AddressCardTextWidget(
                  //               //   title: '${  widget.localBenfData?.},',
                  //               // ),
                  //               AddressCardTextWidget(
                  //                 title: 'Upazila :',
                  //               ),
                  //               AddressCardTextWidget(
                  //                 title: '${widget.localBenfData?.upazillaName},',
                  //               ),
                  //               AddressCardTextWidget(title: 'Union :'),
                  //               AddressCardTextWidget(title: '${widget.localBenfData?.unionName ?? ''}'),
                  //               AddressCardTextWidget(title: 'House :'),
                  //               AddressCardTextWidget(title: '${widget.localBenfData?.benfHouse ?? ''}')
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  InkWell(
                    // onTap: (){
                    //   op.tstdList();
                    // },
                    child: Text(
                      'Answer This Questions',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Divider(),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          op.dlcPhvQuesList.isEmpty
                              ? Text('Question is Loading.... ')
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: op.dlcPhvQuesList.length,
                                  itemBuilder: (context, index) {
                                    var dlcQ = op.dlcPhvQuesList[index];
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '${index + 1}. ${dlcQ.dlcQ.title}',
                                                style: TextStyle(fontWeight: FontWeight.w400),
                                              ),
                                            ),
                                            // opm.modalBottomOnVerificationErrorText.isEmpty ? SizedBox.shrink() : Flexible(child: Text(opm.modalBottomOnVerificationErrorText,style: TextStyle(color: Colors.red),))
                                          ],
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: 1,
                                                      //value:index == 1 ? 0: 1,
                                                      groupValue: dlcQ.value,
                                                      onChanged: (value) {
                                                        op.updatePhvQuestionDlcList(value: value!, index: index);
                                                        op.getDlcAnswerForPhysicalVerif();

                                                        // if (index == 1) {
                                                        //   if (op.getdlcAnswerForPhysicalVerif[1].answer == "1") {
                                                        //     setState(() {
                                                        //       selectedValue = 0;
                                                        //     });
                                                        //   } else {
                                                        //     setState(() {
                                                        //       selectedValue = 1;
                                                        //     });
                                                        //   }
                                                        //   // for (var element in op.getdlcAnswerForPhysicalVerif) {

                                                        //   // }
                                                        // } else {
                                                        //   if (op.getdlcAnswerForPhysicalVerif.any((element) => element.answer == "0")) {
                                                        //     setState(() {
                                                        //       //  answerList.add(value)
                                                        //       selectedValue = 0;
                                                        //     });
                                                        //   } else {
                                                        //     setState(() {
                                                        //       //  answerList.add(value)
                                                        //       selectedValue = 1;
                                                        //     });
                                                        //   }
                                                        // }
                                                      },
                                                    ),
                                                    Text('Yes'),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: 0,
                                                      // value:index == 1 ? 1 : 0,
                                                      groupValue: dlcQ.value,
                                                      onChanged: (value) {
                                                        op.updatePhvQuestionDlcList(value: value!, index: index);
                                                        op.getDlcAnswerForPhysicalVerif();
                                                        //  if (index == 1) {
                                                        //   if (op.getdlcAnswerForPhysicalVerif[1].answer == "1") {
                                                        //     setState(() {
                                                        //       selectedValue = 0;
                                                        //     });
                                                        //   } else {
                                                        //     setState(() {
                                                        //       selectedValue = 1;
                                                        //     });
                                                        //   }
                                                        //   // for (var element in op.getdlcAnswerForPhysicalVerif) {

                                                        //   // }
                                                        // } else {
                                                        //   if (op.getdlcAnswerForPhysicalVerif.any((element) => element.answer == "0")) {
                                                        //     setState(() {
                                                        //       //  answerList.add(value)
                                                        //       selectedValue = 0;
                                                        //     });
                                                        //   } else {
                                                        //     setState(() {
                                                        //       //  answerList.add(value)
                                                        //       selectedValue = 1;
                                                        //     });
                                                        //   }
                                                        // }
                                                        // setState(() {
                                                        //   selectedValue = value;
                                                        // });
                                                      },
                                                    ),
                                                    Text('No'),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ],
                                    );
                                  },
                                ),
                          Divider(),
                         op.dlcPhvQuesList.isEmpty ? SizedBox.shrink():  Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                  child: Text(
                                    'Do you want to Reject this HCP-HHs?',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: op.isPhysVerifRejectSelected
                                      ? null
                                      : () {
                                          showDialog(
                                            // barrierColor: Colors.white,
                                            context: context,
                                            builder: (context) {
                                              return Consumer<OperationProvider>(builder: (context, opd, child) {
                                                return AlertDialog(
                                                  contentPadding: EdgeInsets.zero,
                                                  titlePadding: EdgeInsets.zero,
                                                  backgroundColor: Colors.white,
                                                  title: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7))),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(
                                                            'Confirmation',
                                                            style: TextStyle(fontWeight: FontWeight.w500),
                                                          ),
                                                        ),
                                                        Divider(),
                                                      ],
                                                    ),
                                                  ),
                                                  content: Container(
                                                    width: MediaQuery.of(context).size.width * 0.4,
                                                    height: MediaQuery.of(context).size.height * 0.12,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.only(
                                                        bottomLeft: Radius.circular(7),
                                                        bottomRight: Radius.circular(7),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      //mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Flexible(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(
                                                              'Do you really want to Reject this HCP-HHs?',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actionsPadding: EdgeInsets.zero,
                                                  actions: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.only(
                                                          bottomLeft: Radius.circular(20),
                                                          bottomRight: Radius.circular(20),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Colors.green,
                                                              foregroundColor: Colors.white,
                                                            ),
                                                            onPressed: () {
                                                              opd.setPhysVerifRejected(isRej: false);
                                                              log('dlc physical verify status ${opd.phyVerifStatus}');
                                                              Navigator.pop(context);
                                                            },
                                                            child: Text('Cancel'),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                            child: ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Colors.red,
                                                                foregroundColor: Colors.white,
                                                              ),
                                                              onPressed: () {
                                                                opd.setPhysVerifRejected(isRej: true);
                                                                log('dlc physical verify status ${opd.phyVerifStatus}');
                                                                Navigator.pop(context);
                                                              },
                                                              child: Text('YES'),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                            },
                                          );
                                          // op.setPhysVerifRejected();
                                        },
                                  child: Text('Reject'),
                                ),
                              ),
                              op.isPhysVerifRejectSelected
                                  ? TextButton(
                                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        op.setPhysVerifRejected(isRej: false);
                                      },
                                      //icon: Icon(Icons.close),
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                          //   child: Text(
                          //     'Is this HH actually HCP ?', //'Do you want to verify this ?',
                          //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          //   ),
                          // ),
                          // Row(
                          //   children: [
                          //     Radio(
                          //       value: 1,
                          //       groupValue: selectedValue,
                          //       onChanged: (value) {
                          //         setState(() {
                          //           selectedValue = value!;
                          //         });
                          //       },
                          //     ),
                          //     Text('Yes'),
                          //   ],
                          // ),
                          // Row(
                          //   children: [
                          //     Radio(
                          //       value: 2,
                          //       groupValue: selectedValue,
                          //       onChanged: (value) {
                          //         setState(() {
                          //           selectedValue = value!;
                          //         });
                          //       },
                          //     ),
                          //     Text('No'),
                          //   ],
                          // ),
                          //selectedValue == 0
                          // op.getdlcAnswerForPhysicalVerif.isNotEmpty
                          //     ? (op.getdlcAnswerForPhysicalVerif[0].answer == "0" ||
                          //             op.getdlcAnswerForPhysicalVerif[1].answer == "1" ||
                          //             op.getdlcAnswerForPhysicalVerif[2].answer == "0")
                          //         ?
                          !op.isPhysVerifRejectSelected
                              ? SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: reasonController,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                      hintText: 'Write your reasons',
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          width: 1.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(2),
                                        borderSide: BorderSide(
                                          width: 1.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                      //enabledBorder:
                                    ),
                                  ),
                                ),
                          //     : SizedBox.shrink()
                          // : SizedBox.shrink(),
                          SizedBox(
                            height: 20,
                          ),
                          isVerifLoading
                              ? CircularProgressIndicator()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  child:    op.dlcPhvQuesList.isEmpty ? SizedBox.shrink(): CustomButtonRounded(
                                      title: 'Submit',
                                      onPress: () async {
                                        op.getDlcAnswerForPhysicalVerif();
                                        op.setPhysicalVerifyStatus();
                                        // final pos = await op.getUsersPosition();
                                        // if (pos != null) {
                                        //    CustomSnackBar(
                                        //         message: 'Success', isSuccess: true).show();
                                        // } else {
                                        //    CustomSnackBar(
                                        //         message: 'Failed', isSuccess: false).show();
                                        // }
                                        final isServiceEnabled = await op.checkLocationServiceStatus();
                                        LocationPermission permission = await Geolocator.checkPermission();
                                        print('location ${permission.name}');
                                        if (!isServiceEnabled) {
                                          Geolocator.openLocationSettings();
                                        } else if (await Permission.location.isDenied) {
                                          Geolocator.openAppSettings();
                                        } else if (await Permission.location.isPermanentlyDenied) {
                                          Geolocator.openAppSettings();
                                        } else if (op.isPhysVerifRejectSelected && reasonController.text.isEmpty) {
                                          CustomSnackBar(isSuccess: false, message: 'Please Write your reasons for rejection').show();
                                        }
                                        // else {
                                        //   if (op.getdlcAnswerForPhysicalVerif.isNotEmpty
                                        //   &&
                                        //       (op.getdlcAnswerForPhysicalVerif[0].answer == "0" ||
                                        //           op.getdlcAnswerForPhysicalVerif[1].answer == "1" ||
                                        //           op.getdlcAnswerForPhysicalVerif[2].answer == "0"
                                        //           ) &&
                                        //       reasonController.text.isEmpty) {
                                        //     CustomSnackBar(message: "Please write your reasons", isSuccess: false).show();
                                        //   }
                                        else {
                                          if (op.getdlcAnswerForPhysicalVerif.any((element) => element.answer == "null")) {
                                            CustomSnackBar(isSuccess: false, message: 'Please Answer All Questions').show();
                                          } else {
                                            setState(() {
                                              isVerifLoading = true;
                                            });
                                            final position = await op.getUsersPosition();
                                            if (position != null) {
                                              if (op.isConnected) {
                                                final isSuccess = await op.physicalVerifyBeneficiary(
                                                  id: widget.beneficiaryData!.id!,
                                                  dlcQuestion: jsonEncode(op.getdlcAnswerForPhysicalVerif),
                                                  status: op.phyVerifStatus,
                                                  //status: selectedValue == 1 ? "Verify" : "Reject",
                                                  reason: reasonController.text.isEmpty ? '' : reasonController.text,
                                                  latitude: position.latitude.toString(),
                                                  longitude: position.longitude.toString(),
                                                );
                                                // op.clearDlcQuesAnswerphysver();

                                                if (isSuccess) {
                                                  // local.updateLocalPhysicalVerifyStatus(
                                                  //   benfiD: widget.beneficiaryData!.id!,
                                                  //   latitude: position.latitude.toString(),
                                                  //   isOnline: 'onlineDrafted',
                                                  //   longitude: position.longitude.toString(),
                                                  //   status: op.phyVerifStatus,
                                                  //   reason: reasonController.text.isEmpty ? '' : reasonController.text,
                                                  //   distID: widget.beneficiaryData!.districtId!,
                                                  //   upaiD: widget.beneficiaryData!.upazilaId!,
                                                  //   qansJson: jsonEncode(op.getdlcAnswerForPhysicalVerif),
                                                  // );
                                                  op.clearDlcQuesAnswerphysver();
                                                  op.clearDlcQuesAns();
                                                  reasonController.clear();
                                                  if (op.phyVerifStatus == 'Reject') {
                                                    CustomSnackBar(message: "Beneficiary Rejected Successfully", isSuccess: true).show();
                                                  } else {
                                                    CustomSnackBar(message: "Beneficiary Verified Successfully", isSuccess: true).show();
                                                  }
                                                  op.clearPysVerifStatus();
                                                  op.paginatedRefresh();
                                                  await op.fetchPaginatedBenfData(
                                                      distID: widget.beneficiaryData!.districtId!,
                                                      upazilaID: widget.beneficiaryData!.upazilaId!,
                                                      statusID: 1,
                                                      local: local);
                                                  setState(() {
                                                    isVerifLoading = false;
                                                  });
                                                  // op.getBeneficiaryList(
                                                  //     distID: widget.beneficiaryData!.district!.id!,
                                                  //     upazilaID: widget.beneficiaryData!.upazila!.id!,
                                                  //     isSearch: false,
                                                  //     statusID: 1,
                                                  //     local: local);
                                                  if (mounted) {
                                                    Navigator.pop(context);
                                                  }
                                                } else {
                                                  CustomSnackBar(message: "Failed to verify, Please Check your internet connection", isSuccess: false)
                                                      .show();
                                                }
                                              } else {
                                                setState(() {
                                                  isVerifLoading = false;
                                                });
                                                // op.clearPysVerifStatus();
                                                // local.updateLocalPhysicalVerifyStatus(
                                                //   benfiD: widget.beneficiaryData!.id!,
                                                //   latitude: position.latitude.toString(),
                                                //   longitude: position.longitude.toString(),
                                                //   isOnline: 'offlineDrafted',
                                                //   status: op.phyVerifStatus,
                                                //   reason: reasonController.text.isEmpty ? '' : reasonController.text,
                                                //   distID: widget.beneficiaryData!.districtId!,
                                                //   upaiD: widget.beneficiaryData!.upazilaId!,
                                                //   qansJson: jsonEncode(op.getdlcAnswerForPhysicalVerif),
                                                // );
                                                op.clearPysVerifStatus();
                                                op.paginatedRefresh();
                                                op.clearDlcQuesAnswerphysver();
                                                op.clearDlcQuesAns();
                                                await op.fetchPaginatedBenfData(
                                                  distID: widget.beneficiaryData!.districtId!,
                                                  upazilaID: widget.beneficiaryData!.upazilaId!,
                                                  statusID: 1,
                                                  local: local,
                                                );
                                                // op.clearPysVerifStatus();

                                                //CustomSnackBar(message: "Please Connect to internet", isSuccess: false).show();
                                                //CustomSnackBar(message: "Your Data is Saved locally", isSuccess: true).show();
                                                if (mounted) {
                                                  Navigator.pop(context);
                                                }
                                                //ofline
                                              }
                                            } else {
                                              setState(() {
                                                isVerifLoading = false;
                                              });
                                              CustomSnackBar(
                                                      message: "Failed to Fetch Location due to low GPS signal. Please Check Location Settings or Connect to Internet or move to open space",
                                                      isSuccess: false,
                                                      seconds: 5)
                                                  .show();
                                            }
                                          }
                                          //}
                                        }

                                        //selectedValue == 2 ? print('no') : print('yes');
                                      }),
                                ),
                          // ElevatedButton(
                          //     onPressed: () async {
                          //         Geolocator.openAppSettings();
                          //       if (await Permission.location.isDenied) {
                          //         // The user opted to never again see the permission request dialog for this
                          //         // app. The only way to change the permission's status now is to let the
                          //         // user manually enables it in the system settings.
                          //         Geolocator.openAppSettings();
                          //       }
                          //       // LocationPermission permission = await Geolocator.checkPermission();
                          //       // if (permission == LocationPermission.denied) {
                          //       //   await Geolocator.requestPermission();
                          //       // } else if (permission == LocationPermission.deniedForever) {
                          //       //   await Geolocator.requestPermission();
                          //       // }
                          //       // print('location ${permission.name}');
                          //     },
                          //     child: Text('data'))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
