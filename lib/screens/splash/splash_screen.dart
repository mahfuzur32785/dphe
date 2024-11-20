import 'dart:async';
import 'package:dphe/offline_database/sync_online.dart';
import 'package:dphe/screens/users/citizen/citizen_dashboard/citizen_dashboard.dart';
import 'package:dphe/screens/users/le/le_dashboard/data_sync_loader_screen.dart';

import 'package:dphe/user_checker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/custom_loader/update_dialog.dart';
import '../../components/custom_snackbar/custom_snakcbar.dart';
import '../../provider/le_providers/le_dashboard_provider.dart';
import '../../provider/network_connectivity_provider/network_connectivity_provider.dart';
import '../../provider/operation_provider.dart';
import '../../utils/api_constant.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constant.dart';
import '../../utils/asset_strings.dart';
import '../../utils/custom_text_style.dart';
import '../../utils/local_storage_manager.dart';
import '../auth/login_screen.dart';
import '../users/dlc/dlc_dashboard/dlc_dashboard_page.dart';
import '../users/le/le_dashboard/le_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String loginToken = "";
  late String userType = "";
  bool isEnglishSelected = false;
  bool isNetConnected = false;
  Future<void> checkLoginToken() async {
    loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
    userType = await LocalStorageManager.readData(AppConstant.userType) ?? "";
  }

  @override
  void initState() {
    super.initState();
    
  //  checkLoginToken();
   // getVersionNum();
    checkUser();

    
  }

  void checkNetworkConnectivity() async {
    //final res=  await Provider.of<ConnectivityProvider>(context, listen: false).checkConnectivity();
    final res = await NetworkConnectivity().checkConnectivity();
    isNetConnected = res;
    if (isNetConnected == true) {
      CustomSnackBar(message: "Connected to internet").show();
    } else {
      CustomSnackBar(message: "You are currently offline", isSuccess: false).show();
    }
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
     checkUser();
    }
    //var version = await Provider.of<OperationProvider>(context, listen: false).getStoreVersion('com.dream71.dphe');
    //print('$version');
  }

  Future<void> checkUser() async{
    loginToken = await LocalStorageManager.readData(ApiConstant.loginToken) ?? "";
    userType = await LocalStorageManager.readData(AppConstant.userType) ?? "";
    Timer(const Duration(seconds: 3), () {
      if (loginToken.isEmpty) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => const LoginScreen()));
      } else {
        if (userType == AppConstant.dlc) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => const DlcDashBoardPage()));
        } else if (userType == AppConstant.official) {
           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => const LoginScreen()));
        } else if (userType == AppConstant.le) {
          // if (isNetConnected == true) {
          //   Navigator.of(context).pushReplacement(
          //       MaterialPageRoute(builder: (builder) => const DataSyncLoader())); // if connected to internet -> first sync data then show dashboard
          // } else 
          // {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (builder) => const LeDashboard())); // if no internet then show dashboard without syncing data
        //  }
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => const LoginScreen()));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          //backgroundColor: MyColors.backgroundColor,
          body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AssetStrings.bdLogo,
              height: size.height / 7,
              // height: 70,
            ),
            // const SizedBox(height: 15,),
            Text(
              "Information  Management and Visualization System (IMVS)",
              textAlign: TextAlign.center,
              style: MyTextStyle.primaryBold(fontSize: size.height * 0.03),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "For",
                textAlign: TextAlign.center,
                style: MyTextStyle.primaryBold(fontSize: size.height * 0.03),
              ),
            ),
            // const SizedBox(height: 15,),

            // const SizedBox(height: 15,),
            Text(
              "Rural Water, Sanitation and Hygiene for Human Capital Development Project (RWSHHCDP)",
              textAlign: TextAlign.center,
              style: MyTextStyle.blueBold(
                fontSize: size.height * 0.026,
              ),
            ),
            // const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Image.asset(
                AssetStrings.dpheLogo,
                height: size.height / 7,
              ),
            ),
            // const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Text(
                "Department of Public Health Engineering (DPHE)",
                textAlign: TextAlign.center,
                style: MyTextStyle.primaryBold(fontSize: 20),
              ),
            ),
            // const SizedBox(height: 15,),
            Image.asset(
              AssetStrings.worldBankLogo,
              // height: 70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AssetStrings.dr71Logo,
                  height: 40,
                ),
              ],
            ),
            // const SizedBox(height: 10,),
          ],
        ),
      )
          // body: Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //   child: Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //        Image.asset(AssetStrings.bdLogo,height: 70,),
          //         const SizedBox(height: 15,),
          //         Text("Information  Management and Visualization System (IMVS)", textAlign: TextAlign.center,style: MyTextStyle.primaryBold(fontSize: 20),),
          //         const SizedBox(height: 15,),
          //         Text("For", textAlign: TextAlign.center,style: MyTextStyle.primaryBold(fontSize: 20),),
          //         const SizedBox(height: 15,),
          //         Text("Rural Water, Sanitation and Hygiene for Human Capital Development Project (RWSHHCDP)", textAlign: TextAlign.center,style: MyTextStyle.blueBold(fontSize: 18,),),
          //         const SizedBox(height: 15,),
          //         Image.asset(AssetStrings.dpheLogo,height: 70,),
          //         const SizedBox(height: 15,),
          //         Text("Department of Public Health Engineering (DPHE)", textAlign: TextAlign.center,style: MyTextStyle.primaryBold(fontSize: 20),),
          //         const SizedBox(height: 15,),
          //         Image.asset(AssetStrings.worldBankLogo,height: 70,),
          //         Image.asset(AssetStrings.dr71Logo,height: 70,),
          //         const SizedBox(height: 10,),
          //       ],
          //     ),
          //   ),
          // )
          ),
    );
  }
}
