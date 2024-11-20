// import 'package:dphe/Data/models/hiveDbModel/dlc_ph_verify_model.dart';
// import 'package:dphe/components/common_widgets/common_widgets.dart';
// import 'package:dphe/components/text_input_filed/custom_input_suffix.dart';
// import 'package:dphe/provider/hive_provider.dart';
// import 'package:dphe/provider/operation_provider.dart';
// import 'package:dphe/screens/users/dlc/dlc_verification_page.dart';
// import 'package:dphe/screens/users/dlc/dlc_widget/dlc_verify_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../utils/app_colors.dart';
// import '../../../utils/common_functions.dart';
// import '../../../utils/custom_text_style.dart';

// class TwinPitLatrineLePage extends StatefulWidget {
//   final String upazilaName;
//   final int upaID;
//   final int distID;
//   const TwinPitLatrineLePage({super.key, required this.upazilaName, required this.upaID, required this.distID});

//   @override
//   State<TwinPitLatrineLePage> createState() => _TwinPitLatrineLePageState();
// }

// class _TwinPitLatrineLePageState extends State<TwinPitLatrineLePage> {
//   int selectedTabIndex = 0;
//   int statusID = 1;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // getData();
//   }

//   getData() async {
//     final op = Provider.of<OperationProvider>(context, listen: false);
//     //final local = Provider.of<LocalStoreHiveProvider>(context, listen: false);
//     await op.getBeneficiaryList(distID: widget.distID, upazilaID: widget.upaID, isSearch: false, statusID: statusID);

//     // for (var element in op.beneficiaryList) {
//     //   var phvModel = PhysicalVerifyModelHive()
//     //     ..benfID = element!.id
//     //     ..benfNID = element.nid.toString()
//     //     ..benfMobileNo = element.phone
//     //     ..distID = element.district!.id
//     //     ..unionName = element.union?.name
//     //     ..upazillaID = element.upazila!.id
//     //     ..upazillaName = element.upazila?.name;
//     //   local.storeDataForPhysicalVerificatiojn(phvmodel: phvModel);
//     // }
//   }

//   final searchController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     getData();
//     return SafeArea(
//       child: Consumer<OperationProvider>(builder: (context, op, child) {
//         return Scaffold(
//           backgroundColor: Colors.white,
//           // appBar: AppBar(
//           //   backgroundColor: Color.fromARGB(255, 191, 222, 247),
//           //   elevation: 0,
//           //   title: Text('Twin Pit Latrine $upazilaName',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
//           // ),
//           body: Column(children: [
//             Container(
//               // height: size.height / 6,
//               decoration: BoxDecoration(color: Color.fromARGB(255, 230, 239, 247)),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       BackButton(
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                       Expanded(
//                         child: Text(
//                           'Twin Pit Latrine ${widget.upazilaName} Upazila',
//                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
//                     child: TextField(
//                       controller: searchController,
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                         hintText: 'Search',
//                         hintStyle: TextStyle(color: Colors.black45),
//                         filled: true,
//                         fillColor: Colors.white,
//                         suffixIcon: Icon(Icons.search),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(40),
//                           borderSide: BorderSide(
//                             width: 1.0,
//                             color: Colors.black,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(40),
//                           borderSide: BorderSide(
//                             width: 1.0,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                       onChanged: (value) {
//                         op.getBeneficiaryList(distID: widget.distID, upazilaID: widget.upaID, isSearch: true, phoneOrLe: value, statusID: statusID);
//                       },
//                     ),
//                   ),
//                   //CustomTextInputFieldSuffix(controller: searchController, textInputType: TextInputType.text, hintText: 'LE Name/Mobile No')
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 9.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   newCustomTab(
//                     index: 0,
//                     selectedIndex: selectedTabIndex,
//                     title: 'Drafted',
//                     onTap: () {
//                       setState(() {
//                         selectedTabIndex = 0;
//                         statusID = 1;
//                       });
//                     },
//                   ),
//                   newCustomTab(
//                     index: 1,
//                     selectedIndex: selectedTabIndex,
//                     title: 'Verified',
//                     onTap: () {
//                       setState(() {
//                         selectedTabIndex = 1;
//                         statusID = 2;
//                       });
//                     },
//                   ),
//                   newCustomTab(
//                     index: 2,
//                     selectedIndex: selectedTabIndex,
//                     title: 'Rejected',
//                     onTap: () {
//                       setState(() {
//                         selectedTabIndex = 2;
//                         statusID = 3;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const Divider(),
//             op.beneficiaryList.isEmpty
//                 ? Expanded(
//                     child: Center(
//                     child: Text('No Data Available'),
//                   ))
//                 : Expanded(
//                     child: ListView.builder(
//                     itemCount: op.beneficiaryList.length,
//                     itemBuilder: (context, index) {
//                       var benficiaryData = op.beneficiaryList[index];
//                       return InkWell(
//                         onTap: () {
//                           statusID == 1
//                               ? Navigator.push(context, MaterialPageRoute(
//                                   builder: (context) {
//                                     return DlcVerificationPage(
//                                       beneficiaryData: benficiaryData!,
//                                     );
//                                   },
//                                 ))
//                               : null;
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(10),
//                           margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
//                           decoration: BoxDecoration(
//                             color: MyColors.cardBackgroundColor,
//                             borderRadius: BorderRadius.circular(5),
//                             border: Border.all(color: MyColors.customGreyLight, width: 1),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                       child: Text(
//                                     benficiaryData?.name ?? "Unknown name",
//                                     style: MyTextStyle.primaryBold(fontSize: 15),
//                                   )),
//                                   Text(
//                                     "Mobile : ${benficiaryData?.phone ?? 000000}",
//                                     style: MyTextStyle.primaryLight(fontSize: 9),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               Text(
//                                 "NID : ${benficiaryData?.nid ?? 000000}",
//                                 style: MyTextStyle.primaryLight(fontSize: 10),
//                               ),
//                               const SizedBox(
//                                 height: 8,
//                               ),
//                               Wrap(
                                
//                                 // alignment: WrapAlignment.start,
//                                 direction: Axis.horizontal,

//                                 children: [
//                                   AddressCardTextWidget(
//                                     title: 'Address :',
//                                   ),
//                                   AddressCardTextWidget(
//                                     title: 'District :',
//                                   ),
//                                   AddressCardTextWidget(
//                                     title: '${benficiaryData?.district?.name},',
//                                   ),
//                                   AddressCardTextWidget(
//                                     title: 'Upazila :',
//                                   ),
//                                   AddressCardTextWidget(
//                                     title: '${benficiaryData?.upazila?.name},',
//                                   ),
//                                   AddressCardTextWidget(title: 'Union :'),
//                                   AddressCardTextWidget(title: '${benficiaryData?.union?.name},',),
//                                   AddressCardTextWidget(title: 'House :'),
//                                   AddressCardTextWidget(title: benficiaryData?.houseName ?? '')
//                                 ],
//                               )
//                               //Divider(),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ))
//           ]),
//         );
//       }),
//     );
//   }
// }

// class AddressCardTextWidget extends StatelessWidget {
//   final String title;

//   const AddressCardTextWidget({
//     super.key,
//     required this.title,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       '$title',
//       style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
//     );
//   }
// }
