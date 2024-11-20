import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/pusher_services.dart';
import 'package:dphe/screens/under_construction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../components/custom_appbar/custom_appbar.dart';
import '../../../../components/custom_loader/update_dialog.dart';
import '../../../../provider/le_providers/le_dashboard_provider.dart';
import '../../../../utils/api_constant.dart';
import '../../../../utils/app_constant.dart';
import '../../../../utils/local_storage_manager.dart';

class DlcDashBoardPage extends StatefulWidget {
  const DlcDashBoardPage({super.key});

  @override
  State<DlcDashBoardPage> createState() => _DlcDashBoardPageState();
}

class _DlcDashBoardPageState extends State<DlcDashBoardPage> {
  String username = '';
  String loginToken = '';
   String mobileNo = '';
     String? userPhoto ;
    String userDesignation = '';
  void checkUserInfo() async {
    username = await LocalStorageManager.readData(AppConstant.userName) ?? "Unknown";
    loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
    mobileNo = await LocalStorageManager.readData(AppConstant.userPhone) ?? "";
    userDesignation = await LocalStorageManager.readData(AppConstant.designaton) ?? "";
    userPhoto = await LocalStorageManager.readData(AppConstant.userPhoto);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
    checkUserInfo();
    //PusherServices().initPusher(onEvent: Provider.of<OperationProvider>(context, listen: false).onEvent);
    //Provider.
    //of<LeDashboardProvider>(context, listen: false).getLeDashboard();
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

  @override
  Widget build(BuildContext context) {
     getVersionNum();
    return Consumer<OperationProvider>(builder: (context, op, child) {
      return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: Scaffold(
          appBar: CustomAppbar(
            title: username,
            isDlcDashBoardPage: true,
           // notificationmessage: op.eventMessage,
            userName: username,
            designation: userDesignation,
            mobileName: mobileNo,
            isTpActDashboard: true
           // userPhoto: userPhoto,

          ),
          body: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  itemCount: op.dlcDashBoardPageList.length,
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 100,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemBuilder: (context, index) {
                    var item = op.dlcDashBoardPageList[index];
                    return InkWell(
                      onTap: () {
                        item.routeName != null
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => item.routeName!,
                                ))
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UnderConstructionScreen(),
                                ));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: item.tileColor, borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(item.title!,
                              textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
