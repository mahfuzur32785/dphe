import 'package:dphe/screens/auth/tabs/citizen_login_tab_view.dart';
import 'package:dphe/screens/auth/tabs/official_login_tab_view.dart';
import 'package:dphe/utils/asset_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common_widgets/common_widgets.dart';
import '../../components/custom_loader/update_dialog.dart';
import '../../provider/operation_provider.dart';
import '../../utils/custom_text_style.dart';
import 'tabs/le_login_tab_view.dart';
import 'package:upgrader/upgrader.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int selectedIndex = 1;
  late final TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    //tabController.index=0;
    super.initState();
    // getVersionNum();
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Consumer<OperationProvider>(builder: (context, op, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          //resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white10,
                    width: double.infinity,
                    //height: MediaQuery.of(context).size.height * .3,
                    child: Image.asset(
                      fit: BoxFit.fitWidth,
                      AssetStrings.tankImage,
                      height: MediaQuery.of(context).size.height * .36,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'version: ${op.currentVersionNumber}',
                        style: TextStyle(fontSize: 7),
                      ),
                    ),
                  ),
                  //const SizedBox(height: 40,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Image.asset(
                      AssetStrings.dpheLogo,
                      height: 70,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "IMVS for RWSHHCDP",
                    textAlign: TextAlign.center,
                    style: MyTextStyle.primaryBold(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //tabs
                  Row(
                    children: [
                      Expanded(
                        child: customTab(
                            index: 0,
                            selectedIndex: selectedIndex,
                            title: "Official User",
                            onTap: () {
                              setState(() {
                                selectedIndex = 0;
                                //currentPageNo = 1;
                              });
                            }),
                      ),
                      Expanded(
                        child: customTab(
                            index: 1,
                            selectedIndex: selectedIndex,
                            title: "LE",
                            onTap: () {
                              setState(() {
                                selectedIndex = 1;
                                //currentPageNo = 1;
                              });
                            }),
                      ),
                      Expanded(
                        child: customTab(
                            index: 2,
                            selectedIndex: selectedIndex,
                            title: "Citizen User",
                            onTap: () {
                              setState(() {
                                selectedIndex = 2;
                                //currentPageNo = 1;
                              });
                            }),
                      ),
                    ],
                  ),

                  const Divider(),
                  if (selectedIndex == 0) ...[
                    const OfficialLoginTabView(),
                  ] else if (selectedIndex == 1) ...[
                    const LeLoginTabView(),
                  ] else if (selectedIndex == 2) ...[
                    const CitizenLoginTabView(),
                  ]
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
