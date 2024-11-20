import 'package:dphe/api/beneficiary_api/dlc_api/hcp_hhs_frwrd_api.dart';
import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/components/custom_buttons/custom_status_button.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/users/dlc/dlc_hhs_verification/twin_pit_le.dart';
import 'package:dphe/utils/app_colors.dart';
import 'package:dphe/utils/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Data/models/common_models/dlc_model/le_data_model.dart';
import '../../../../components/text_input_filed/custom_search_field.dart';
import '../../../../utils/app_constant.dart';

class HcpPendingPage extends StatefulWidget {
  final int upaID;
  final int distID;
  final StswiseLeData? stsLeData;

  const HcpPendingPage({super.key, required this.upaID, required this.distID, required this.stsLeData});

  @override
  State<HcpPendingPage> createState() => _HcpPendingPageState();
}

class _HcpPendingPageState extends State<HcpPendingPage> {
  bool isSelectAll = false;
  bool isForwardLoading = false;
   bool isSendBackLoading = false;
  final searchController = TextEditingController();
  getBenfData() {
    final op = Provider.of<OperationProvider>(context, listen: false);
    op.getBeneficiaryList(
      distID: widget.distID,
      upazilaID: widget.upaID,
      isSearch: false,
      statusID: 7,
      isLeWiseBeneficiariesPage: true,
      leid: widget.stsLeData!.le!.id,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getBenfData();
    });
    // getBenfData();
  }

  //   getBenfData() {
  //   final op = Provider.of<OperationProvider>(context, listen: false);
  //   op.getBeneficiaryList(
  //     distID: widget.distID,
  //     upazilaID: widget.upaID,
  //     isSearch: false,
  //     statusID: 7,
  //     isLeWiseBeneficiariesPage: true,
  //     leid: widget.stsLeData!.le!.id,
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   getBenfData();
    //  });
    // getBenfData();
    return Consumer<OperationProvider>(builder: (context, op, child) {
      return Column(
        children: [
          CustomSearchFieldWidget(
            searchController: searchController,
            hintText: 'Search',
            onchanged: (query) {
              op.searchLeWiseBenfListData(query);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  // backgroundColor: Colors.green,
                  foregroundColor: Colors.grey,
                  // shadowColor: Colors.greenAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: Size(20, 28), //////// HERE
                ),
                onPressed: () {
                  setState(() {
                    isSelectAll = !isSelectAll;
                  });
                  isSelectAll ? op.selectAllBen(isDeselect: false) : op.selectAllBen(isDeselect: true);
                  // op.selectAllBen();
                },
                child: isSelectAll ? Text('Deselect All') : Text('Select All'),
              ),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: isSendBackLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          // shadowColor: Colors.greenAccent,
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: Size(20, 28), //////// HERE
                        ),
                        onPressed: op.listOfSelectedForwarded.isEmpty
                            ? null
                            : () async {
                                setState(() {
                                  isSendBackLoading = true;
                                });
                                final isSuccess = await op.sendBackHHsFromDlc();
                                setState(() {
                                  isSendBackLoading = false;
                                });
                                if (isSuccess) {
                                  op.clearListForSelForward();
                                  CustomSnackBar(isSuccess: true, message: 'Successfully Sent Back').show();
                                  getBenfData();
                                } else {
                                  CustomSnackBar(isSuccess: false, message: 'Failed To Send Data').show();
                                }
                              },
                        child: Text('Send Back'),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: isForwardLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          // shadowColor: Colors.greenAccent,
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: Size(20, 28), //////// HERE
                        ),
                        onPressed: op.listOfSelectedForwarded.isEmpty
                            ? null
                            : () async {
                                setState(() {
                                  isForwardLoading = true;
                                });
                                final isSuccess = await op.requestSelectedBeneficiaries();
                                setState(() {
                                  isForwardLoading = false;
                                });
                                if (isSuccess) {
                                  op.clearListForSelForward();
                                  CustomSnackBar(isSuccess: true, message: 'Successfully forwarded').show();
                                  getBenfData();
                                } else {
                                  CustomSnackBar(isSuccess: false, message: 'Operation Failed').show();
                                }
                              },
                        child: Text('Forward'),
                      ),
              ),
            ],
          ),
          op.isBenficiaryLoading
              ? Expanded(
                  child: Center(
                  child: CircularProgressIndicator(),
                ))
              : op.chLeWiseBenfList.isEmpty
                  ? Expanded(
                      child: Center(
                      child: Text('No Data Available'),
                    ))
                  : Expanded(
                      child: ListView.builder(
                      itemCount: op.chLeWiseBenfList.length,
                      itemBuilder: (context, index) {
                        var item = op.chLeWiseBenfList[index].benfData;

                        return InkWell(
                          onTap: () {
                            //  setState(() {
                            //           widgetSelectIndex =item!.id!;
                            //         });
                            //  op.addBenficiariesID(beID: item!.id!);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
                            decoration: BoxDecoration(
                              color: MyColors.cardBackgroundColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: MyColors.customGreyLight, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     Checkbox(value: op.chLeWiseBenfList[index].isCheck, onChanged: (value) {

                                //     },),
                                //   //  Text('is Selected ${op.chLeWiseBenfList[index].isCheck}'),
                                //   ],
                                // ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      item?.name ?? "Unknown name",
                                      style: MyTextStyle.primaryBold(fontSize: 20),
                                    )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Mobile : ${item?.phone ?? 000000}",
                                  style: MyTextStyle.primaryLight(fontSize: 17),
                                ),
                                Text(
                                  "NID : ${item?.nid ?? 000000}",
                                  style: MyTextStyle.primaryLight(fontSize: 17),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: RichText(
                                      text: TextSpan(
                                          text: 'Address: ',
                                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 18),
                                          children: [
                                        TextSpan(
                                            style: TextStyle(
                                              fontFamily: AppConstant.roboto,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontSize: 17,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '${item?.houseName ?? ''},',
                                                style: TextStyle(
                                                  fontFamily: AppConstant.roboto,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ]),
                                        TextSpan(
                                            text: 'Ward: ',
                                            style: TextStyle(
                                             // fontFamily: AppConstant.roboto,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontSize: 17,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '${item?.wardNo ?? ''}, ',
                                                style: TextStyle(
                                                  fontFamily: AppConstant.roboto,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ]),
                                        TextSpan(
                                            style: TextStyle(
                                             // fontFamily: AppConstant.roboto,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontSize: 17,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '${item?.union?.name ?? ''}, ',
                                                style: TextStyle(
                                                  fontFamily: AppConstant.roboto,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ]),
                                        TextSpan(
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                            children: [
                                              TextSpan(
                                                text: '${item?.upazila?.name},',
                                                style: TextStyle(
                                                   fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                              ),
                                            ]),
                                        TextSpan(
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                          children: [
                                            TextSpan(
                                              text: '${item?.district?.name},',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400, color: Colors.black, fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ])),
                                ),
                                // Row(
                                //   children: [

                                //   ],
                                // )
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
                                //       title: '${item?.district?.name},',
                                //     ),
                                //     AddressCardTextWidget(
                                //       title: 'Upazila :',
                                //     ),
                                //     AddressCardTextWidget(
                                //       title: '${item?.upazila?.name},',
                                //     ),
                                //     AddressCardTextWidget(title: 'Union :'),
                                //     AddressCardTextWidget(
                                //         title: '${item?.union?.name ?? ''}'),
                                //     AddressCardTextWidget(title: 'House :'),
                                //     AddressCardTextWidget(
                                //         title: '${item?.houseName ?? ''}')
                                //   ],
                                // ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                                      child: CustomStatusButton(
                                        bgColor: op.chLeWiseBenfList[index].isCheck ? Colors.orange : Colors.green,
                                        title: op.chLeWiseBenfList[index].isCheck ? 'Deselect' : 'Select',
                                        onPress: () {
                                          op.addBenficiariesID(index: index);
                                          // setState(() {
                                          //   op.chLeWiseBenfList[index].isCheck = !op.chLeWiseBenfList[index].isCheck;
                                          // });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                //Divider(),
                              ],
                            ),
                          ),
                        );
                      },
                    ))
        ],
      );
    });
  }
}
