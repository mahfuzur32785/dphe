import 'dart:convert';

import 'package:dphe/components/custom_appbar/custom_appbar.dart';
import 'package:dphe/components/custom_buttons/custom_button_rounded.dart';
import 'package:dphe/components/custom_card/dashboard_card.dart';
import 'package:dphe/components/custom_snackbar/custom_snakcbar.dart';
import 'package:dphe/offline_database/sync_online.dart';
import 'package:dphe/provider/network_connectivity_provider/network_connectivity_provider.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/pusher_services.dart';
import 'package:dphe/screens/users/le/le_dashboard/data_sync_loader_screen.dart';
import 'package:dphe/screens/users/le/le_dashboard/le_dashboard_details.dart';
import 'package:dphe/utils/app_constant.dart';
import 'package:dphe/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../../../../components/custom_loader/update_dialog.dart';
import '../../../../provider/le_providers/le_dashboard_provider.dart';
import '../../../../utils/api_constant.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/local_storage_manager.dart';

class LeDashboard extends StatefulWidget {
  const LeDashboard({super.key});

  @override
  State<LeDashboard> createState() => _LeDashboardState();
}

class _LeDashboardState extends State<LeDashboard> {
  String userName = "";
  String loginToken = "";
  int userID = -1;
  int leDashboardUnderSelectionCount = 0;
  int leDashboardApprovedSelectionCount = 0;
  int leDashboardOngoingCount = 0;
  int leDashboardUnderVerificationCount = 0;
  int leDashboardVerifiedCount = 0;
  int leDashboardBillPaid = 0;
  bool isSync = false;

  @override
  void initState() {
    // TODO: implement initState
    checkUserInfo();
    //WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    //});
    dashboardCount();
    super.initState();
    getVersionNum();
    getUserID();
    checkSync();
    // PusherServices().initPusher(
    //   //onEvent: onEvent
    //   onEvent: Provider.of<OperationProvider>(context, listen: false).onEvent,
    // );
  }

  List<dynamic> eventMessages = [];

  getUserID() async {
    await Provider.of<OperationProvider>(context, listen: false).getUserID();
  }

  getDashBoardData() async {
    await Provider.of<LeDashboardProvider>(context, listen: false).getLeDashboard();
  }

  // onEvent(PusherEvent event) {
  //   var eventbyChannel = PusherEvent(channelName: 'dphe-notification-channel', eventName: 'dphe-notification-event');
  //   print("onEvent: $event");
  //   print(eventbyChannel.userId);
  //   print(eventbyChannel.data);
  //   var pusherData = jsonDecode(eventbyChannel.data);
  //   if (pusherData['message']['user_id'] == userID) {
  //     setState(() {
  //       eventMessages.add(pusherData['message']);
  //     });
  //   }

  //   print('pusher data user id ${pusherData['message']['user_id']}');
  //   //notificationData = eventbyChannel.data;
  //   //print("onEvent: $event");
  // }

  checkSync() async {
    final syncProvider = Provider.of<SyncOnlineProvider>(context, listen: false);
    await syncProvider.isDataSync();
  }

  void checkUserInfo() async {
    //userID = await LocalStorageManager.readData(ApiConstant.userID) ?? "Unknown id";
    userName = await LocalStorageManager.readData(AppConstant.userName) ?? "Unknown Name";
    loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";

    print("loginToken: $loginToken");
    setState(() {});
  }

  getVersionNum() async {
    final op = Provider.of<OperationProvider>(context, listen: false);
    var isUpdate = await op.checkUpdateAvailable();
    if (isUpdate) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          showUpdateDialog(context: context);
        },
      );
    } else {
      return;
    }
    //var version = await Provider.of<OperationProvider>(context, listen: false).getStoreVersion('com.dream71.dphe');
    //print('$version');
  }

  Future<void> dashboardCount() async {
    leDashboardUnderSelectionCount = await LocalStorageManager.readData(AppConstant.leDashboardUnderSelectionCount) ?? 0;
    leDashboardApprovedSelectionCount = await LocalStorageManager.readData(AppConstant.leDashboardApprovedSelectionCount) ?? 0;
    leDashboardOngoingCount = await LocalStorageManager.readData(AppConstant.leDashboardOngoingCount) ?? 0;
    leDashboardUnderVerificationCount = await LocalStorageManager.readData(AppConstant.leDashboardUnderVerificationCount) ?? 0;
    leDashboardVerifiedCount = await LocalStorageManager.readData(AppConstant.leDashboardVerifiedCount) ?? 0;
    leDashboardBillPaid = await LocalStorageManager.readData(AppConstant.leDashboardCompletedApprovedCount) ?? 0;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getVersionNum();
    getDashBoardData();
    checkSync();

    return Consumer3<LeDashboardProvider, SyncOnlineProvider, OperationProvider>(builder: (context, controller, sync, op, child) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: CustomAppbar(
            title: userName,
            isLeDashBoard: true,
            userName: userName,
            //notificationmessage: op.eventMessage,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await Provider.of<LeDashboardProvider>(context, listen: false).getLeDashboard();
              await dashboardCount();
            },
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child:
                      //controller.leDashboardDataList.isNotEmpty?
                      //controller.leDashboardDataList[0].underSelection !=null?
                      controller.showLeDashboard == true
                          ? Column(
                              children: [
                                
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: CustomButtonRounded(
                                      title: AppStrings.bookKorun,
                                      onPress: () {
                                        controller.lePaginatedRefresh();
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (builder) => const DashboardDetails(
                                                  title: AppStrings.bookKorun,
                                                  statusIdList: [6],
                                                )));
                                      }),
                                ),
                                // const SizedBox(
                                //   height: 15,
                                // ),

                                /// don't delete this code, probably it will be used in future
                                // Row(
                                //   children: [
                                //     Expanded(child: DashBoardCard(title: "নির্বাচনাধীন", value: "130", bgColor: MyColors.customRed, onTap: (){})),
                                //     const SizedBox(width: 15,),
                                //     Expanded(child: DashBoardCard(title: "অনুমোদিত", value: "130", bgColor: MyColors.customGreenLight, onTap: (){})),
                                //   ],
                                // ),
                                // const SizedBox(height: 15,),
                                // Row(
                                //   children: [
                                //     Expanded(child: DashBoardCard(title: "চলমান", value: "130", bgColor: MyColors.customRed2, icon: Icons.layers,
                                //         onTap: (){
                                //           Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>const DashboardDetails(title: "চলমান")));
                                //         })
                                //     ),
                                //     const SizedBox(width: 15,),
                                //     Expanded(child: DashBoardCard(title: "বিচারাধীন", value: "130", bgColor: MyColors.customMagenta, icon: Icons.layers, onTap: (){})),
                                //   ],
                                // ),

                                ///before code
                                // DashBoardCard(title: "নির্বাচনাধীন", value: CommonFunctions().convertNumberToBangla(controller.leDashboardDataList[0].underSelection!.count??0), bgColor: MyColors.customRed, onTap: (){
                                //   Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>const DashboardDetails(title: "নির্বাচনাধীন", statusIdList: [1,2],)));
                                // }),
                                // const SizedBox(height: 15,),
                                // DashBoardCard(title: "অনুমোদিত", value: CommonFunctions().convertNumberToBangla(controller.leDashboardDataList[0].approved!.count??0), bgColor: MyColors.customGreenLight, onTap: (){
                                //   Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>const DashboardDetails(title: "অনুমোদিত", statusIdList: [3],)));
                                // }),
                                // const SizedBox(height: 15,),
                                // DashBoardCard(title: "চলমান", value: CommonFunctions().convertNumberToBangla(controller.leDashboardDataList[0].ongoing!.count??0), bgColor: MyColors.customRed2, icon: Icons.layers,
                                //     onTap: (){
                                //       Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>const DashboardDetails(title: "চলমান", statusIdList: [4],)));
                                //     }),
                                // const SizedBox(height: 15,),
                                // DashBoardCard(title: "বিচারাধীন", value: CommonFunctions().convertNumberToBangla(controller.leDashboardDataList[0].underVerification!.count??0), bgColor: MyColors.customMagenta, icon: Icons.layers, onTap: (){
                                //   Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>const DashboardDetails(title: "বিচারাধীন", statusIdList: [5,6],)));
                                // }),
                                // const SizedBox(height: 15,),
                                // DashBoardCard(title: "ভেরিফাইড", value: CommonFunctions().convertNumberToBangla(controller.leDashboardDataList[0].verified!.count??0), bgColor: MyColors.customGreen, icon: Icons.layers, onTap: (){
                                //   Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>const DashboardDetails(title: "ভেরিফাইড", statusIdList: [7],)));
                                // }),

                                /// after code
                                DashBoardCard(
                                    title: AppStrings.nirbachonadhin,
                                    value: CommonFunctions.convertNumberToBangla(
                                      controller.leDashboardDataList.isNotEmpty && controller.networkConnected == true
                                          ? controller.leDashboardDataList[0].underSelection != null
                                              ? controller.leDashboardDataList[0].underSelection!.count ?? 0
                                              : leDashboardUnderSelectionCount
                                          : leDashboardUnderSelectionCount,
                                    ),
                                    bgColor: MyColors.customRed,
                                    onTap: () {
                                      controller.lePaginatedRefresh();
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (builder) => const DashboardDetails(
                                                title: AppStrings.nirbachonadhin,
                                                statusIdList: [7, 8],
                                              )));
                                    }),
                                const SizedBox(
                                  height: 5,
                                ),
                                DashBoardCard(
                                    title: AppStrings.onumodito,
                                    value: CommonFunctions.convertNumberToBangla(
                                        controller.leDashboardDataList.isNotEmpty && controller.networkConnected == true
                                            ? controller.leDashboardDataList[0].approved != null
                                                ? controller.leDashboardDataList[0].approved!.count ?? 0
                                                : leDashboardApprovedSelectionCount
                                            : leDashboardApprovedSelectionCount),
                                    bgColor: MyColors.customGreenLight,
                                    onTap: () {
                                      controller.lePaginatedRefresh();
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (builder) => const DashboardDetails(
                                                title: AppStrings.onumodito,
                                                statusIdList: [9],
                                              )));
                                    }),
                                const SizedBox(
                                  height: 5,
                                ),
                                DashBoardCard(
                                    title: AppStrings.choloman,
                                    value: CommonFunctions.convertNumberToBangla(
                                        controller.leDashboardDataList.isNotEmpty && controller.networkConnected == true
                                            ? controller.leDashboardDataList[0].ongoing != null
                                                ? controller.leDashboardDataList[0].ongoing!.count ?? 0
                                                : leDashboardOngoingCount
                                            : leDashboardOngoingCount),
                                    bgColor: MyColors.customRed2,
                                    icon: Icons.construction,
                                    onTap: () {
                                      controller.lePaginatedRefresh();
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (builder) => const DashboardDetails(
                                                title: AppStrings.choloman,
                                                statusIdList: [10],
                                              )));
                                    }),
                                const SizedBox(
                                  height: 5,
                                ),
                                DashBoardCard(
                                    title: AppStrings.bibechonadhin,
                                    value: CommonFunctions.convertNumberToBangla(
                                        controller.leDashboardDataList.isNotEmpty && controller.networkConnected == true
                                            ? controller.leDashboardDataList[0].underVerification != null
                                                ? controller.leDashboardDataList[0].underVerification!.count ?? 0
                                                : leDashboardUnderVerificationCount
                                            : leDashboardUnderVerificationCount),
                                    bgColor: MyColors.customMagenta,
                                    icon: Icons.layers,
                                    onTap: () {
                                      controller.lePaginatedRefresh();
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (builder) => const DashboardDetails(
                                                title: AppStrings.bibechonadhin,
                                                statusIdList: [11],
                                              )));
                                    }),
                                const SizedBox(
                                  height: 5,
                                ),
                                DashBoardCard(
                                    title: AppStrings.verified,
                                    value: CommonFunctions.convertNumberToBangla(
                                        controller.leDashboardDataList.isNotEmpty && controller.networkConnected == true
                                            ? controller.leDashboardDataList[0].verified != null
                                                ? controller.leDashboardDataList[0].verified!.count ?? 0
                                                : leDashboardVerifiedCount
                                            : leDashboardVerifiedCount),
                                    bgColor: MyColors.customGreen,
                                    icon: Icons.verified,
                                    onTap: () {
                                      controller.lePaginatedRefresh();
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (builder) => const DashboardDetails(
                                                title: AppStrings.verified,
                                                statusIdList: [12, 14, 15, 16],
                                              )));
                                    }),

                                const SizedBox(
                                  height: 5,
                                ),
                                DashBoardCard(
                                    title: AppStrings.praptoBill,
                                    isBill: true,
                                    value: CommonFunctions.convertNumberToBangla(
                                        controller.leDashboardDataList.isNotEmpty && controller.networkConnected == true
                                            ? controller.leDashboardDataList[0].billPaid != null
                                                ? controller.leDashboardDataList[0].billPaid!.count ?? 0
                                                : leDashboardBillPaid
                                            : leDashboardBillPaid),
                                    bgColor: MyColors.customDeepBlue,
                                    // icon: Icons.money_off_csred,
                                    onTap: () {
                                      controller.lePaginatedRefresh();
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (builder) => const DashboardDetails(
                                                title: AppStrings.praptoBill,
                                                statusIdList: [17],
                                              )));
                                    }),

                                // const SizedBox(height: 15,),
                                // DashBoardCard(title: AppStrings.somponno, value: CommonFunctions().convertNumberToBangla(controller.leDashboardDataList.isNotEmpty && controller.networkConnected == true ?
                                // controller.leDashboardDataList[0].completedApproved!=null?controller.leDashboardDataList[0].completedApproved!.count??0:
                                // leDashboardCompletedApprovedCount:leDashboardCompletedApprovedCount), bgColor: MyColors.customDeepBlue, icon: Icons.layers, onTap: (){
                                //   Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>const DashboardDetails(title: AppStrings.somponno, statusIdList: [7],)));
                                // }),

                                // const SizedBox(height: 15,),
                                // DashBoardCard(title: AppStrings.prottakhato, value: CommonFunctions().convertNumberToBangla(controller.leDashboardDataList.isNotEmpty && controller.networkConnected == true ?
                                // controller.leDashboardDataList[0].rejected!=null?controller.leDashboardDataList[0].rejected!.count??0:
                                // leDashboardRejectedCount:leDashboardRejectedCount), bgColor: MyColors.customRed, icon: Icons.layers, onTap: (){
                                //   Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>const DashboardDetails(title: AppStrings.prottakhato, statusIdList: [8],)));
                                // }),
                                // const SizedBox(
                                //   height: 50,
                                // ),

                                const SizedBox(
                                  height: 20,
                                ),

                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  child: ElevatedButton.icon(
                                      label: Text(AppStrings.syncData),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: sync.isBackupEnabled ? Colors.red : MyColors.customGreen, foregroundColor: Colors.white),
                                      icon: !sync.isBackupEnabled ? Icon(Icons.check) : Icon(Icons.backup),
                                      onPressed: !op.isConnected
                                          ? null
                                          : () async {
                                             // final res = await NetworkConnectivity().checkConnectivity();
                                             //// if (res == true) {
                                                Navigator.of(
                                                  context,
                                                ).pushReplacement(MaterialPageRoute(builder: (builder) => const DataSyncLoader()));
                                            //  } else {
                                                // CustomSnackBar(
                                                //   message: "No internet!",
                                                //   isSuccess: false,
                                                // ).show();
                                           //   }
                                            }),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                              ],
                            )
                          : const Center(child: Text("Loading..."))
                  //:const Center(child: Text("Loading...")):const Center(child: Text("Nothing Found!")),
                  ),
            ),
          ),
        ),
      );
    });
  }
}
