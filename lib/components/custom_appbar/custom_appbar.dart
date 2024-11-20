import 'package:dphe/api/auth_api/auth_api.dart';
import 'package:dphe/components/common_widgets/notification_page.dart';
import 'package:dphe/provider/network_connectivity_provider/network_connectivity_provider.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/auth/login_screen.dart';
import 'package:dphe/screens/users/dlc/leave_request/leave_history_page.dart';
import 'package:dphe/utils/api_constant.dart';
import 'package:dphe/utils/asset_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../screens/auth/change_password_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constant.dart';
import '../../utils/custom_text_style.dart';
import '../../utils/local_storage_manager.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Color bgColor;
  final Color fontColor;
 // final List<dynamic>? notificationmessage;
  final String? designation;
  final String? mobileName;
  final String? userName;
  final String? userPhoto;
  final Widget actionWidget;
  final bool isDlcDashBoardPage;
  final bool isLeDashBoard;
  final bool isTwinPitLatrinePage;
  final bool isTwinPitLatrineDetailsPage;
  final bool isTwinActivitiesDetailsDshbrd;
  final bool istwnpitDlcVerification;
  final bool isHcpLeWiseBeneficiaryListPage;
  final bool isLatrineDlcPendingForVerify;
  final bool isDlcOtherActivityScreen;
  final bool isAttendancePage;
  final bool isDistPage;
  final bool isUpazilaPage;
  final bool isTpActDashboard;
  const CustomAppbar(
      {Key? key,
      this.title = "",
      this.bgColor = MyColors.backgroundColor,
      this.fontColor = MyColors.primaryTextColor,
      this.actionWidget = const SizedBox(
        width: 30,
      ),
      this.isDlcDashBoardPage = false,
    //  this.notificationmessage,
      this.isTwinPitLatrinePage = false,
      this.isTwinPitLatrineDetailsPage = false,
      this.isDistPage = false,
      this.isAttendancePage = false,
      this.isTpActDashboard = false,
      this.userPhoto,
      this.isUpazilaPage = false,
      this.isLeDashBoard = false,
      this.isTwinActivitiesDetailsDshbrd = false,
      this.istwnpitDlcVerification = false,
      this.isDlcOtherActivityScreen = false,
      this.isHcpLeWiseBeneficiaryListPage = false,
      this.isLatrineDlcPendingForVerify = false,
      this.designation,
      this.mobileName,
      this.userName})
      : super(key: key);

  @override
  _CustomAppbarState createState() => _CustomAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppbarState extends State<CustomAppbar> {
  bool isConnected = false;
  bool isLogOutLoading = false;
  String? userPhoto;
  String? designation;
  void checkUserInfo() async {
    userPhoto = await LocalStorageManager.readData(AppConstant.userPhoto);
    designation = await LocalStorageManager.readData(AppConstant.designaton);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    checkConnectivity();
    checkUserInfo();
    super.initState();
  }

  void checkConnectivity() async {
    isConnected = await NetworkConnectivity().checkConnectivity();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OperationProvider>(builder: (context, op, child) {
      return AppBar(
        titleSpacing: -9,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: MyColors.backgroundColor,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: widget.bgColor,
        leading: widget.isTwinPitLatrinePage ||
                widget.isTwinPitLatrineDetailsPage ||
                widget.isDistPage ||
                widget.isUpazilaPage ||
                widget.isTwinActivitiesDetailsDshbrd ||
                widget.istwnpitDlcVerification ||
                widget.isHcpLeWiseBeneficiaryListPage ||
                widget.isLatrineDlcPendingForVerify ||
                widget.isAttendancePage ||
                widget.isDlcOtherActivityScreen
            ? BackButton(
                onPressed: () {
                  if (widget.isLatrineDlcPendingForVerify) {
                    Provider.of<OperationProvider>(context, listen: false).setLatrinVerfTab(val: 0);
                    Navigator.pop(context);
                  }else if(widget.istwnpitDlcVerification){
                    Provider.of<OperationProvider>(context, listen: false).clearDlcQuesAns();
                    Navigator.pop(context);

                  } else {
                    Navigator.pop(context);
                  }
                },
              )
            : Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                  AssetStrings.dpheLogo,
                ),
              ),
        title: Column(
          children: [
            Text(
              '${widget.title}',
              style: TextStyle(fontFamily: 'Roboto-Regular', fontSize: 16, fontWeight: FontWeight.w700),
              // style: MyTextStyle.primaryLight(
              //   fontColor: widget.fontColor,
              //   fontSize: 16,
              // ),
            ),
          !widget.isTpActDashboard ? SizedBox.shrink() :  designation != null ? Text(designation!, style: TextStyle(fontFamily: 'Roboto-Regular', fontSize: 14, fontWeight: FontWeight.w400),) : SizedBox.shrink()
          ],
        ),
        centerTitle: true,
        actions: [
          // widget.isDlcDashBoardPage|| widget.i
          //     ?
          // widget.isLeDashBoard || widget.isDlcDashBoardPage
          //     ? InkWell(
          //         onTap: () {
          //           // Navigator.push(context, MaterialPageRoute(builder: (context) {

          //           // },));
          //           //Test
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (context) => NotificationPage(),
          //               ));
          //         },
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 5.0),
          //           child: Badge(
          //             label: widget.notificationmessage == null ? Text('0') : Text('${widget.notificationmessage!.length}'),
          //             child: Icon(
          //               Icons.notifications,
          //               size: 30,
          //             ),
          //           ),
          //         ),
          //       )
          //     : SizedBox.shrink(),
          // : SizedBox.shrink(),
          widget.isDistPage ||
                  widget.isUpazilaPage ||
                  widget.istwnpitDlcVerification ||
                  widget.isHcpLeWiseBeneficiaryListPage ||
                  widget.isLatrineDlcPendingForVerify ||
                  widget.isDlcOtherActivityScreen
              ? SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () async {
                      showMenu(
                          context: context,
                          elevation: 4,
                          color: Colors.white,
                          shadowColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          position: RelativeRect.fromLTRB(100, 80, 0, 0),
                          items: [
                            PopupMenuItem(
                              child: Column(
                                children: [
                                  TextButton(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Call Support 1',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                          Text('${ApiConstant.supportPhone1}',style: TextStyle(fontWeight: FontWeight.w400),),
                                      ],
                                    ),
                                    onPressed: () async {
                                      await op.searchUriFromInternet(isSupport: true,phone: ApiConstant.supportPhone1);
                                      //await AuthApi().callLogoutApi();
                                    },
                                  ),
                                
                                  Divider(),
                                ],
                              ),
                            ),
                              PopupMenuItem(
                              child: Column(
                                children: [
                                  TextButton(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Call Support 2',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                           Text('${ApiConstant.supportPhone2}',style: TextStyle(fontWeight: FontWeight.w400),),
                                      ],
                                    ),
                                    onPressed: () async {
                                      await op.searchUriFromInternet(isSupport: true,phone: ApiConstant.supportPhone2);
                                      //await AuthApi().callLogoutApi();
                                    },
                                  ),
                                
                                  Divider(),
                                ],
                              ),
                            ),
                              PopupMenuItem(
                              child: Column(
                                children: [
                                  TextButton(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Call Support 3',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                         Text('${ApiConstant.supportPhone3}',style: TextStyle(fontWeight: FontWeight.w400),),
                                      ],
                                    ),
                                    onPressed: () async {
                                    await op.searchUriFromInternet(isSupport: true,phone: ApiConstant.supportPhone3);
                                      //await AuthApi().callLogoutApi();
                                    },
                                  ),
                                  
                                  Divider(),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              child: Column(
                                children: [
                                  TextButton(
                                    child: Text(
                                      'Change Password',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChangePasswordPage(
                                              userName: widget.userName ?? '',
                                              designation: widget.designation ?? '',
                                              mobileNo: widget.mobileName ?? '',
                                            ),
                                          ));
                                      //await AuthApi().callLogoutApi();
                                    },
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    isLogOutLoading = true;
                                  });
                                  final logoutRes = await AuthApi().callLogoutApi(context: context);
                                  setState(() {
                                    isLogOutLoading = false;
                                  });
                                  if ((logoutRes != null) && (logoutRes.status == 'success')) {
                                    if (mounted) {
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                                    }
                                  } else {
                                    if (mounted) {
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                                    }
                                  }
                                },
                                child: isLogOutLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.blue,
                                      )
                                    : Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        child: Center(
                                            child: Text(
                                          'Log out',
                                          style: TextStyle(color: Colors.red),
                                        )),
                                      ),
                              ),
                            ),
                          ]);
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(55),
                          color: Colors.white,
                          image: userPhoto == null
                              ? DecorationImage(image: AssetImage(AssetStrings.userIcon))
                              : DecorationImage(image: NetworkImage(userPhoto!))
                          // image: DecorationImage(
                          //     image: isConnected == true
                          //         ? NetworkImage(AssetStrings.profileImageDummyNetwork)
                          //         : AssetImage(
                          //                 'assets/images/splash/user_image_dummy.png')
                          //             as ImageProvider,
                          //     fit: BoxFit.fill),
                          ),
                      // child: Image.asset(AssetStrings.userIcon,fit: BoxFit.cover,height: 5),
                    ),
                  ),
                ),
        ],
      );
    });
  }
}
