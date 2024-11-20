import 'package:dphe/components/custom_appbar/custom_appbar.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Data/models/common_models/dlc_model/le_data_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/custom_text_style.dart';
import '../dlc_hhs_verification/twin_pit_le.dart';
import 'latrine_instl_pending.dart';

class LatrineInstallationPage extends StatefulWidget {
  final StswiseLeData? stsLeData;
  final int upaID;
  final int distID;

  const LatrineInstallationPage({super.key, this.stsLeData, required this.upaID, required this.distID});

  @override
  State<LatrineInstallationPage> createState() => _LatrineInstallationPageState();
}

class _LatrineInstallationPageState extends State<LatrineInstallationPage> {
  late PageController pendingForVerifyPageController;
  int selectedTabColor = 0;
  @override
  void initState() {
    pendingForVerifyPageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<OperationProvider>(builder: (context, op, child) {
      return WillPopScope(
        onWillPop: () async {
          op.setLatrinVerfTab(val: 0);

          return true;
        },
        child: Scaffold(
          // appBar: CustomAppbar(
          //   title: 'Pending for Verify',
          //   isLatrineDlcPendingForVerify: true,

          // ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 230, 239, 247),
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: Container(
                        height: 50,
                        // color: Colors.black,
                        child: Row(
                          children: [
                            BackButton(
                              onPressed: () async {
                                final navigator = Navigator.of(context);
                                await op.getLeForLatrineVerification(distID: widget.distID, upazilaID: widget.upaID, statusID: 11);
                                navigator.pop();
                                
                              },
                            ),
                          ],
                        ),
                      )),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 50,
                          //color: Colors.yellow,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Pending For Verify',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        height: 50,
                        // color: Colors.red,
                      ))
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
                              //'Le',
                              widget.stsLeData!.le!.name!,
                              style: MyTextStyle.primaryBold(fontSize: 14),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Text(
                                '${widget.stsLeData!.le!.phone!}', //${widget.stsLeData!.le!.upazilaName} Upazila'
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                            //foregroundColor: Colors.black,
                            // textStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 18)
                            ),
                        onPressed: () {
                          op.setLatrinVerfTab(val: 0);
                          // setState(() {
                          //   selectedTabColor = 0;
                          // });
                          pendingForVerifyPageController.animateToPage(
                            0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          'Pending',
                          style: TextStyle(color: op.initialLvtab == 0 ? Colors.green : Colors.black, fontSize: 17),
                        )),
                    TextButton(
                        onPressed: () {
                          op.setLatrinVerfTab(val: 1);
                          // setState(() {
                          //   selectedTabColor = 1;
                          // });
                          pendingForVerifyPageController.animateToPage(
                            1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text('Verified', style: TextStyle(color: op.initialLvtab == 1 ? Colors.green : Colors.black, fontSize: 17))),
                    TextButton(
                        onPressed: () {
                          op.setLatrinVerfTab(val: 2);
                          // setState(() {
                          //   selectedTabColor = 2;
                          // });
                          pendingForVerifyPageController.animateToPage(
                            2,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text('Send Back', style: TextStyle(color: op.initialLvtab == 2 ? Colors.green : Colors.black, fontSize: 17))),
                  ],
                ),
                //   Divider(),
                Expanded(
                  flex: 3,
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    controller: pendingForVerifyPageController,
                    onPageChanged: (value) {
                      //op.setDividerTab(value);
                    },
                    children: [
                      LatrInstVrfyPendingPage(
                        distID: widget.distID,
                        upaID: widget.upaID,
                        stsLeData: widget.stsLeData,
                        statusID: 11,
                        isSendBack: false,
                        pageController: pendingForVerifyPageController,
                        isPending: true,
                        isVerified: false,
                      ),
                      LatrInstVrfyPendingPage(
                        distID: widget.distID,
                        upaID: widget.upaID,
                        stsLeData: widget.stsLeData,
                        statusID: 12,
                        isSendBack: false,
                        pageController: pendingForVerifyPageController,
                        isVerified: true,
                        isPending: false,
                      ),
                      LatrInstVrfyPendingPage(
                        distID: widget.distID,
                        upaID: widget.upaID,
                        stsLeData: widget.stsLeData,
                        statusID: 10,
                        isSendBack: true,
                        pageController: pendingForVerifyPageController,
                        isPending: false,
                        isVerified: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
