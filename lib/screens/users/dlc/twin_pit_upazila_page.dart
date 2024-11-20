import 'package:dphe/components/custom_appbar/custom_appbar.dart';
import 'package:dphe/provider/hive_provider.dart';
import 'package:dphe/screens/users/dlc/dlc_latrine_verification/new_dlc_beneficiary_list.dart';
import 'package:dphe/screens/users/dlc/dlc_other_activity/dlc_other_activity_screen.dart';
import 'package:dphe/screens/users/dlc/dlc_report_progression/dlc_report_list.dart';
import 'package:dphe/screens/users/dlc/twin_pit_district_page.dart';
import 'package:dphe/screens/users/dlc/twin_pit_latrine_details.dart';
import 'package:dphe/screens/users/dlc/dlc_hhs_verification/twin_pit_le.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/operation_provider.dart';
import 'dlc_latrine_verification/latrine_verify_screen.dart';
import 'hcp_hhs_forward/hcp_hhs_forward.dart';

class MyUpazila extends StatefulWidget {
  final int distID;
  final String distName;
  final bool isHcpVerificationPage;
  final bool isHcpForwardPage;
  final bool isLatrineVerification;
  final bool isOtherActivity;
  final bool isReportingPage;
  const MyUpazila({
    super.key,
    required this.distID,
    required this.distName,
    required this.isHcpVerificationPage,
    required this.isHcpForwardPage,
    required this.isLatrineVerification,
    required this.isOtherActivity,
    required this.isReportingPage,
  });

  @override
  State<MyUpazila> createState() => _MyUpazilaState();
}

class _MyUpazilaState extends State<MyUpazila> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getlocalupazila();
    getUpazilla();
  }

  getlocalupazila() {
    final local = Provider.of<LocalStoreHiveProvider>(context, listen: false);
    local.retrieveUpazilla(distID: widget.distID);
  }

  getUpazilla() async {
    await Provider.of<OperationProvider>(context, listen: false)
        .getUpazila(districtID: widget.distID, local: Provider.of<LocalStoreHiveProvider>(context, listen: false));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getlocalupazila();
    });
  }

  @override
  Widget build(BuildContext context) {
    getUpazilla();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   getlocalupazila();
    // });
    print('${widget.isReportingPage}');
    return Consumer2<OperationProvider, LocalStoreHiveProvider>(builder: (context, op, local, child) {
      return Scaffold(
        appBar: CustomAppbar(
          title: 'Upazilas of ${widget.distName}',
          isUpazilaPage: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await op.getUpazila(districtID: widget.distID, local: Provider.of<LocalStoreHiveProvider>(context, listen: false));
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              getlocalupazila();
            });
          },
          child: Stack(
            children: [
              ListView(),
              Column(
                children: [
                  op.upazilaLoading
                      ? Expanded(
                          child: Center(
                          child: CircularProgressIndicator(),
                        ))
                      : local.upazillaHiveList.isEmpty //op.upazilaList.isEmpty
                          ? Expanded(
                              child: Center(
                                child: Text('No Upazilla data availble right now'),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                              itemCount:
                                  local.upazillaHiveList.length, //op.upazilaList.length ,//: local.retrieveUpazilla(distID: widget.distID).length,
                              itemBuilder: (context, index) {
                                var upazilla = local.upazillaHiveList[index];
                                //var upazilla =op.upazilaList[index] ;//: local.retrieveUpazilla(distID: widget.distID)[index];
                                return InkWell(
                                    onTap: () {
                                      // print('upa ${upazilla.id}');
                                      if (widget.isHcpVerificationPage) {
                                        op.paginatedRefresh();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TwinPitLatrineLePage(
                                                upazilaName: upazilla.name!,
                                                upaID: upazilla.id!,
                                                distID: widget.distID,
                                              ),
                                            ));
                                      } else if (widget.isHcpForwardPage) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HcpHHsForwardPage(
                                                upazilaName: upazilla.name!,
                                                upaID: upazilla.id!,
                                                distID: widget.distID,
                                              ),
                                            ));
                                      } else if (widget.isLatrineVerification) {
                                          op.paginatedRefresh();
                                          op.selectDlcStatusID(value: 11);
                                         op.setLatrinVerfTab(val: 0);
                                        
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => NewDlcBeneficiaryPage(
                                               upazilaName: upazilla.name ??'',
                                                upaID: upazilla.id!,
                                                distID: widget.distID,
                                              ),
                                            ),
                                            );
//previous
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) => PendingForVerifyLeList(
                                        //         upazilaName: upazilla.name!,
                                        //         upaID: upazilla.id!,
                                        //         distID: widget.distID,
                                        //       ),
                                        //     ),
                                        //     );
                                      } else if (widget.isOtherActivity) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DlcOtherActivityListScreen(
                                                upazilaName: upazilla.name!,
                                                upaID: upazilla.id!,
                                                distID: widget.distID,
                                              ),
                                            ),
                                            );
                                      } else if (widget.isReportingPage) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DlcReportList(
                                                upazilaName: upazilla.name!,
                                                upaID: upazilla.id!,
                                                distID: widget.distID,
                                              ),
                                            ));
                                      } else {
                                        null;
                                      }
                                    },
                                    child: DistUpazilaCard(dist: upazilla.name!));
                              },
                            ))
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
