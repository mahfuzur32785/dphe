// import 'package:dphe/Data/models/common_models/dlc_model/beneficiary_model.dart';
// import 'package:dphe/components/common_widgets/common_widgets.dart';
// import 'package:dphe/components/custom_appbar/custom_appbar.dart';
// import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
// import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
// import 'package:dphe/provider/operation_provider.dart';
// import 'package:dphe/screens/users/dlc/twin_pit_le_test.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../utils/custom_text_style.dart';

// class DlcVerificationPage extends StatefulWidget {
//   final BeneficiaryDetailsData beneficiaryData;

//   const DlcVerificationPage({super.key, required this.beneficiaryData});

//   @override
//   State<DlcVerificationPage> createState() => _DlcVerificationPageState();
// }

// class _DlcVerificationPageState extends State<DlcVerificationPage> {
//   int selectedValue = 0;
//   final reasonController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Consumer<OperationProvider>(builder: (context, op, child) {
//       return Scaffold(
//         resizeToAvoidBottomInset: true,
//         appBar: CustomAppbar(
//             title: 'Pending for verify', istwnpitDlcVerification: true),
//         body: Container(
//           height: size.height,
//           width: size.width,
//           child: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(color: Colors.white),
//                   child: customCard(
//                     horizontalMargin: 8,
//                     verticalMargin: 8,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                                 child: Text(
//                               widget.beneficiaryData.name ?? "Unknown name",
//                               style: MyTextStyle.primaryBold(fontSize: 15),
//                             )),
//                             Text(
//                               "Mobile : ${widget.beneficiaryData.phone ?? 000000}",
//                               style: MyTextStyle.primaryLight(fontSize: 11),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           "NID : ${widget.beneficiaryData.nid ?? 000000}",
//                           style: MyTextStyle.primaryLight(fontSize: 10),
//                         ),
//                         const SizedBox(
//                           height: 8,
//                         ),
//                         Wrap(
//                           // alignment: WrapAlignment.start,
//                           direction: Axis.horizontal,

//                           children: [
//                             AddressCardTextWidget(
//                               title: 'Address :',
//                             ),
//                             AddressCardTextWidget(
//                               title: 'District :',
//                             ),
//                             AddressCardTextWidget(
//                               title:
//                                   '${widget.beneficiaryData.district?.name},',
//                             ),
//                             AddressCardTextWidget(
//                               title: 'Upazila :',
//                             ),
//                             AddressCardTextWidget(
//                               title: '${widget.beneficiaryData.upazila?.name},',
//                             ),
//                             AddressCardTextWidget(title: 'Union :'),
//                             AddressCardTextWidget(
//                                 title:
//                                     '${widget.beneficiaryData.union?.name ?? ''}'),
//                             AddressCardTextWidget(title: 'House :'),
//                             AddressCardTextWidget(
//                                 title:
//                                     '${widget.beneficiaryData.houseName ?? ''}'),
//                                      AddressCardTextWidget(title: 'Ward No :'),
//                             AddressCardTextWidget(
//                                 title:
//                                     '${widget.beneficiaryData.wardNo ?? ''}')
//                           ],
//                         ),
//                         Text('${widget.beneficiaryData.id}')
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   color: Colors.white,
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8.0, vertical: 8),
//                           child: Text(
//                             'Is This HHs Actually HCP',//'Do you want to verify this ?',
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.w500),
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Radio(
//                               value: 1,
//                               groupValue: selectedValue,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedValue = value!;
//                                 });
//                               },
//                             ),
//                             Text('Yes'),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Radio(
//                               value: 2,
//                               groupValue: selectedValue,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedValue = value!;
//                                 });
//                               },
//                             ),
//                             Text('No'),
//                           ],
//                         ),
//                         selectedValue == 2
//                             ? Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: TextField(
//                                   controller: reasonController,
//                                   maxLines: 2,
//                                   decoration: InputDecoration(
//                                     hintText: 'Write your reasons',
//                                     border: OutlineInputBorder(),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(2),
//                                       borderSide: BorderSide(
//                                         width: 1.0,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(2),
//                                       borderSide: BorderSide(
//                                         width: 1.0,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     //enabledBorder:
//                                   ),
//                                 ),
//                               )
//                             : SizedBox.shrink(),
//                         // Padding(
//                         //   padding: const EdgeInsets.symmetric(
//                         //       horizontal: 20, vertical: 20),
//                         //   child: CustomButtonRounded(
//                         //       title: 'Submit',
//                         //       onPress: () async {
//                         //         if (selectedValue == 2 &&
//                         //             reasonController.text.isEmpty) {
//                         //           CustomSnackBar(
//                         //               message: "Please write your reasons",
//                         //               isSuccess: false);
//                         //         } else {
//                         //           op.physicalVerifyBeneficiary(
//                         //               id: widget.beneficiaryData.id!,
//                         //               status: selectedValue == 1
//                         //                   ? "Verify"
//                         //                   : "Reject",
//                         //               reason: reasonController.text);
//                         //         }

//                         //         //selectedValue == 2 ? print('no') : print('yes');
//                         //       }),
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 20),
//                           child: CustomButtonRounded(
//                               title: 'Submit',
//                               onPress: () async {
//                                 if (selectedValue == 2 &&
//                                     reasonController.text.isEmpty) {
//                                   CustomSnackBar(
//                                       message: "Please write your reasons",
//                                       isSuccess: false);
//                                 } else {
//                                   op.physicalVerifyBeneficiary(
//                                       id: widget.beneficiaryData.id!,
//                                       status: selectedValue == 1
//                                           ? "Verify"
//                                           : "Reject",
//                                       reason: reasonController.text);
//                                 }

//                                 //selectedValue == 2 ? print('no') : print('yes');
//                               }),
//                         ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
