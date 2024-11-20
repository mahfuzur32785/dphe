import 'package:dphe/Data/models/common_models/district_model.dart';
import 'package:dphe/Data/models/hiveDbModel/activity_form_model.dart';
import 'package:dphe/Data/models/hiveDbModel/dlc_ph_verify_model.dart';
import 'package:dphe/Data/models/hiveDbModel/dlc_que_ans.dart';
import 'package:dphe/Data/models/hiveDbModel/upazilla_hive_model.dart';
import 'package:dphe/offline_database/sync_online.dart';
import 'package:dphe/provider/dlc_reprt_provider.dart';
import 'package:dphe/provider/hive_provider.dart';
import 'package:dphe/provider/le_providers/le_dashboard_provider.dart';
import 'package:dphe/provider/leave_provider.dart';
import 'package:dphe/provider/network_connectivity_provider/network_connectivity_provider.dart';
import 'package:dphe/provider/operation_provider.dart';
import 'package:dphe/screens/auth/login_screen.dart';
import 'package:dphe/screens/splash/splash_screen.dart';
import 'package:dphe/screens/users/le/le_dashboard/le_dashboard.dart';
import 'package:dphe/screens/users/le/le_dashboard/le_dashboard_details.dart';
import 'package:dphe/utils/app_routes.dart';
import 'package:dphe/utils/app_strings.dart';
import 'package:dphe/utils/global_keys.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

RemoteMessage? notificationMessage;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FirebaseService.initializeFirebase();
  //  await FirebaseMessaging.instance.requestPermission();
  //  notificationMessage = await FirebaseService.firebaseMessaging.getInitialMessage();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Permission.location.request();
  await Hive.initFlutter();
  Hive.registerAdapter(DistrictAdapter());
  Hive.registerAdapter(PhysicalVerifyModelHiveAdapter());
  Hive.registerAdapter(UpazillaHiveModelAdapter());
  Hive.registerAdapter(ActivityFormModelAdapter());
  Hive.registerAdapter(LocalDlcQuesAnsAdapter());
  await Hive.openBox('user_permission');
  await Hive.openBox<District>('userdistrict');
  await Hive.openBox<PhysicalVerifyModelHive>('physmodel');
  await Hive.openBox<UpazillaHiveModel>('upazilahv');
  await Hive.openBox<ActivityFormModel>('dlcactivity');
  await Hive.openBox<LocalDlcQuesAns>('dlcqa');

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => LeDashboardProvider()),
    ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
    ChangeNotifierProvider(create: (context) => SyncOnlineProvider()),
    ChangeNotifierProvider(create: (context) => OperationProvider()),
    ChangeNotifierProvider(create: (context) => LeaveProvider()),
    ChangeNotifierProvider(
      create: (context) => LocalStoreHiveProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => DlcActivityReportProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getVersionNum();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Provider.of<OperationProvider>(context, listen: false).connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<OperationProvider>(context, listen: false).initConnection(
      sync: Provider.of<SyncOnlineProvider>(context, listen: false),
      local: Provider.of<LocalStoreHiveProvider>(context, listen: false),
      op: Provider.of<OperationProvider>(context, listen: false),
    );
    return MaterialApp(
      title: 'IMVS For RWSHHCDP',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: snackBarKey,
      navigatorKey: navigatorKey,
      // home: const SplashScreen(),
      initialRoute: AppRoutes.initialRoute,
      // onGenerateRoute: (settings) {
      //   switch (settings.name) {
      //     case 'login':
      //       return MaterialPageRoute(builder: (context) => LoginScreen());

      //     default:
      //       return MaterialPageRoute(
      //           builder: (context) => const SplashScreen());
      //   }
      // },
      routes: {
        AppRoutes.initialRoute: (context) => const SplashScreen(),
        AppRoutes.leDashboard: (context) => const LeDashboard(),
        AppRoutes.leApproved: (context) => const DashboardDetails(
              title: AppStrings.onumodito,
              statusIdList: [3],
            ),
        AppRoutes.loginRoute: (context) => const LoginScreen()
      },
      theme: ThemeData(
        //dialaogBackgroundColor: Colors.white,
        // dialogTheme: DialogTheme(
        //   backgroundColor: Colors.white,

        // ),
       // colorScheme:ColorScheme.light().copyWith(background: Colors.white,),
        useMaterial3: true,
      ),
      //home: const SplashScreen(),
    );
  }
}
