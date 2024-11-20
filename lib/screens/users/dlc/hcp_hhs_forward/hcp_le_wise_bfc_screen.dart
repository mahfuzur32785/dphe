import 'package:dphe/api/beneficiary_api/dlc_api/hcp_hhs_frwrd_api.dart';
import 'package:dphe/components/custom_appbar/custom_appbar.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/users/dlc/hcp_hhs_forward/hcp_forwared_page.dart';
import 'package:dphe/screens/users/dlc/hcp_hhs_forward/hcp_pending_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Data/models/common_models/dlc_model/le_data_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/custom_text_style.dart';
import '../dlc_dashboard/dlc_dashboard_page.dart';
import '../dlc_hhs_verification/twin_pit_le.dart';

class HcpLeWiseBeneficiaryList extends StatefulWidget {
  final StswiseLeData? stsLeData;
  final int upaID;
  final int distID;

  const HcpLeWiseBeneficiaryList({super.key, this.stsLeData, required this.upaID, required this.distID});

  @override
  State<HcpLeWiseBeneficiaryList> createState() => _HcpLeWiseBeneficiaryListState();
}

class _HcpLeWiseBeneficiaryListState extends State<HcpLeWiseBeneficiaryList> with SingleTickerProviderStateMixin {
  late PageController pageController;
  late TabController tcontroller;
  int widgetSelectIndex = 0;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    // tcontroller = TabController(length: 2, vsync: this);
    super.initState();
    // getBenfData();
  }

  // getBenfData() {
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
    // getBenfData();
    final size = MediaQuery.of(context).size;
    return Consumer<OperationProvider>(builder: (context, op, child) {
      return SafeArea(
        child: WillPopScope(
          onWillPop: () async{
             // final navigator = Navigator.of(context);
                       await op.getStatusWiseLe(
                          distID: widget.distID,
                          upazilaID: widget.upaID,
                          isSearch: false,
                          statusID: 7,
                        );
                    //   navigator.pop();
            return true;
          },
          child: Scaffold(
              // appBar: CustomAppbar(
              //   title: 'Twin Pit Latrine Pending for Forward',
              //   isHcpLeWiseBeneficiaryListPage: true,
              // ),
              body: Column(
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(color: MyColors.backgroundColor),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    BackButton(
                      onPressed: () async{
                        final navigator = Navigator.of(context);
                       await op.getStatusWiseLe(
                          distID: widget.distID,
                          upazilaID: widget.upaID,
                          isSearch: false,
                          statusID: 7,
                        );
                       navigator.pop();
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Pending for Forward',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ),
                    ),
                      IconButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DlcDashBoardPage(),));
                      
                            }, icon: Icon(Icons.home))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/splash/user_image_dummy.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.stsLeData!.le!.name!,
                            style: MyTextStyle.primaryBold(fontSize: 14),
                          ),
                         widget.stsLeData?.le != null ? Text('${widget.stsLeData!.le!.phone!}') : SizedBox.shrink(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ...op.cTablist
                      .map(
                        (e) => InkWell(
                          onTap: () {
                            pageController.animateToPage(
                              op.cTablist.indexOf(e),
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                            setState(() {
                              op.setDividerTab(op.cTablist.indexOf(e));
                            });
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    e.title!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: op.selectedTabIndex == op.cTablist.indexOf(e) ? Colors.green : Colors.black),
                                  ),
                                ),
                              ),
                              //Divider(),
                              //Divider(color: op.selectedTabIndex == op.cTablist.indexOf(e) ? Colors.green : Colors.black,),
                            ],
                          ),
                        ),
                      )
                      .toList()
                ],
              ),
              Divider(
                color: Colors.black,
              ),
             
              Expanded(
                flex: 3,
                child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: pageController,
                  onPageChanged: (value) {
                    //op.setDividerTab(value);
                  },
                  children: [
                    HcpPendingPage(
                      distID: widget.distID,
                      stsLeData: widget.stsLeData,
                      upaID: widget.upaID,
                    ),
                    HcpForwardedListPage(
                      distID: widget.distID,
                      stsLeData: widget.stsLeData,
                      upaID: widget.upaID,
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
      );
    });
  }
}
