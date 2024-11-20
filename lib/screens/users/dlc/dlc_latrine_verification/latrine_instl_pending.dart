import 'package:dphe/Data/models/common_models/dlc_model/le_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../../provider/operation_provider.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/custom_text_style.dart';
import '../dlc_hhs_verification/twin_pit_le.dart';
import 'dlcverified_data_screen.dart';

class LatrInstVrfyPendingPage extends StatefulWidget {
  final StswiseLeData? stsLeData;
  final int upaID;
  final int distID;
  final int statusID;
  final bool isSendBack;
  final PageController pageController;
  final bool isPending;
  final bool isVerified;

  const LatrInstVrfyPendingPage(
      {super.key,
      this.stsLeData,
      required this.upaID,
      required this.distID,
      required this.statusID,
      this.isSendBack = false,
      required this.pageController,
      this.isPending = false,
      this.isVerified = false});

  @override
  State<LatrInstVrfyPendingPage> createState() => _LatrInstVrfyPendingPageState();
}

class _LatrInstVrfyPendingPageState extends State<LatrInstVrfyPendingPage> {
  bool isLoading = false;
  getBenfData() async {
    final op = Provider.of<OperationProvider>(context, listen: false);

    if (widget.isSendBack) {
      await op.getSendBackLatr(
        distID: widget.distID,
        upazilaID: widget.upaID,
        statusID: 10,
        leid: widget.stsLeData!.le!.id,
      );
    } else {
      if (widget.isPending) {
        await op.getBeneficiaryList(
          distID: widget.distID,
          upazilaID: widget.upaID,
          isSearch: false,
          statusID: 11, //widget.statusID,
          isLeWiseBeneficiariesPage: true,
          leid: widget.stsLeData!.le!.id,
          isLatrInstlVerification: true,
        );
      } else if (widget.isVerified) {
        await op.getBeneficiaryList(
          distID: widget.distID,
          upazilaID: widget.upaID,
          isSearch: false,
          statusID: 12, //widget.statusID,
          isLeWiseBeneficiariesPage: true,
          leid: widget.stsLeData!.le!.id,
          isLatrInstlVerification: true,
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getBenfData();
    });
    super.initState();
    // getBenfData();
  }

  @override
  Widget build(BuildContext context) {
    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   getBenfData();
    // });
    //getBenfData();
    return Consumer<OperationProvider>(builder: (context, op, child) {
      return Column(
        children: [
          op.isBenficiaryLoading
              ? Expanded(
                  child: Center(
                  child: CircularProgressIndicator(),
                ))
              : op.ltrPendingDlcBenfList.isEmpty
                  ? Expanded(
                      child: Center(
                          child: widget.statusID == 12
                              ? Text('No Verified Data Available')
                              : widget.statusID == 10
                                  ? Text('No Send Back Data Available')
                                  : Text('No Pending Data Available')))
                  : Expanded(
                      child: ListView.builder(
                      itemCount: op.ltrPendingDlcBenfList.length,
                      itemBuilder: (context, index) {
                        var item = op.ltrPendingDlcBenfList[index];
                        return InkWell(
                          onTap: widget.statusID == 12 || widget.statusID == 10
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LatrineVerifyQuestionDataScreen(
                                        distID: widget.distID,
                                        upaID: widget.upaID,
                                        benfData: item,
                                        //pageController: widget.pageController,
                                      ),
                                    ),
                                  );
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item?.name ?? "Unknown name",
                                        style: MyTextStyle.primaryBold(fontSize: 15),
                                      ),
                                    ),
                                    Text(
                                      "Mobile :  ${item?.phone ?? ''}",
                                      style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w500, fontSize: 13),
                                      // style: MyTextStyle.primaryLight(fontSize: 9),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "NID :${item?.nid ?? ''}",
                                  style: MyTextStyle.robotoHeadline(fontWeight: FontWeight.w500, fontSize: 13),
                                  //style: MyTextStyle.primaryLight(fontSize: 10),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Wrap(
                                  // alignment: WrapAlignment.start,
                                  direction: Axis.horizontal,

                                  children: [
                                    AddressCardTextWidget(
                                      title: 'Address :',
                                    ),
                                    AddressCardTextWidget(
                                      title: 'District :',
                                    ),
                                    AddressCardTextWidget(
                                      title: '${item?.district?.name},',
                                    ),
                                    AddressCardTextWidget(
                                      title: 'Upazila :',
                                    ),
                                    AddressCardTextWidget(
                                      title: '${item?.upazila?.name},',
                                    ),
                                    AddressCardTextWidget(title: 'Union :'),
                                    AddressCardTextWidget(title: '${item?.union?.name ?? ''} ,'),
                                    AddressCardTextWidget(title: 'Ward :'),
                                    AddressCardTextWidget(title: '${item?.wardNo ?? ''}')
                                  ],
                                ),
                                widget.statusID == 12
                                    ? Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          'Verified',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                        ))
                                    : widget.statusID == 10
                                        ? Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              'Send Back',
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                                            ))
                                        : widget.statusID == 11
                                            ? Align(
                                                alignment: Alignment.bottomRight,
                                                child: Text(
                                                  'Pending',
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                                ))
                                            : SizedBox.shrink()

                                //Divider(),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
        ],
      );
    });
  }
}
