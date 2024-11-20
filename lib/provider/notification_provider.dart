// import 'dart:convert';
// import 'dart:io';
// import 'dart:developer' as dev;
// import 'dart:math';

// import 'package:dphe/utils/local_storage_manager.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:metal_plus/firebase_options.dart';

// import 'package:provider/provider.dart';

// import '../firebase_options.dart';
// import '../utils/api_constant.dart';

// class NotificationProvider {
//   static Future<void> setupToken({
//     Function(String)? onData,
//     required BuildContext context,
//   }) async {
//     // Get the token each time the application loads
//     String? token = await FirebaseMessaging.instance.getToken();
//     debugPrint('This is Firebase Token: $token');
//     if (token == null) {
//       return;
//     }

//     // Save the initial token to the database
//     await onData!(token);

//     // Any time the token refreshes, store this in the database too.
//     FirebaseMessaging.instance.onTokenRefresh.listen(onData);
//   }

//   static Future<String?> getFirebaseToken() async {
//     String? token;
//     try {
//       token = await FirebaseMessaging.instance.getToken();
//       return token;
//     } catch (e) {
//       token = null;
//     }

//     return token;
//   }

//   Future<void> setupInteractMessage() async {
//     RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

//     if (initialMessage != null) {}
//   }

//   static Future<void> notificationPermission(
//     BuildContext context,
//   ) async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     NotificationSettings settings = await messaging.requestPermission();

//     // if (settings.authorizationStatus != AuthorizationStatus.authorized) {
//     //   if (context.mounted) {
//     //     showCustomSnackBar('You are not authorize to Use this app', context);
//     //   } else {
//     //     Navigator.of(context).pop();
//     //   }
//     // } else {
//     //   debugPrint('OK');
//     // }

//     debugPrint('User granted permission: ${settings.authorizationStatus}');
//   }
// }

// class LocalNotificationService {
// //    AndroidNotificationChannel channel = AndroidNotificationChannel(
// //   'high_importance_channel', // id
// //   'High Importance Notifications', // title
// //    description: 'This channel is used for important notifications.', // description
// //   importance: Importance.max,
// // );

//   static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   static void initialize() {
//     final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//     );
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: AndroidInitializationSettings('@mipmap/metal_launcher'), iOS: initializationSettingsDarwin);

//     _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   static void display(RemoteMessage message) async {
//     try {
//       const AndroidNotificationChannel channel = AndroidNotificationChannel(
//         'high_importance_channel', // id
//         'High Importance Notifications', // title
//         description: 'This channel is used for important notifications.', // description
//         importance: Importance.max,
//       );
//       await _flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? androidNotification = message.notification?.android;
//       Random random = Random();
//       int id = random.nextInt(1000);
//       if (notification != null && androidNotification != null) {
//         _flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 channelDescription: channel.description,
//                 icon: androidNotification.smallIcon,
//               ),
//               iOS: DarwinNotificationDetails()),
//         );
//       }
//       // final NotificationDetails notificationDetails = NotificationDetails(
//       //     android: AndroidNotificationDetails(
//       //   'channelID',
//       //   'ChannelName',
//       //   importance: Importance.max,
//       //   priority: Priority.high,
//       // ));
//       // await _flutterLocalNotificationsPlugin.show(
//       //     id, message.notification!.title, message.notification!.body, notificationDetails);
//     } on Exception catch (e) {
//       debugPrint(e.toString());
//     }
//   }
// }
// //  RemoteNotification? notification = message.notification;
// //   AndroidNotification? android = message.notification?.android;

// //   // If `onMessage` is triggered with a notification, construct our own
// //   // local notification to show to users using the created channel.
// //   if (notification != null && android != null) {
// //     flutterLocalNotificationsPlugin.show(
// //         notification.hashCode,
// //         notification.title,
// //         notification.body,
// //         NotificationDetails(
// //           android: AndroidNotificationDetails(
// //             channel.id,
// //             channel.name,
// //             channel.description,
// //             icon: android?.smallIcon,
// //             // other properties...
// //           ),
// //         ));
// //   }

// class FirebaseService {
//   static FirebaseMessaging? _firebaseMessaging;
//   static FirebaseMessaging get firebaseMessaging => FirebaseService._firebaseMessaging ?? FirebaseMessaging.instance;

//   static Future<void> initializeFirebase() async {
//     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//     FirebaseService._firebaseMessaging = FirebaseMessaging.instance;
//     var userID = await LocalStorageManager.readData(ApiConstant.userID) ?? "";
//     if (userID.toString().isNotEmpty) {
//       await firebaseMessaging.subscribeToTopic(userID.toString());
//     }
//     await FirebaseService.initializeLocalNotifications();
//     await FCMProvider.onMessage();
//     await FirebaseService.onMessage();
//     // await FCMProvider.onTrayMessage();
//     await FirebaseService.onBackgroundMsg();
//   }

//   //Future<String?> getDeviceToken() async => await FirebaseMessaging.instance.getToken();

//   static final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   static Future<void> initializeLocalNotifications() async {
//     const InitializationSettings initSettings =
//         InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'), iOS: DarwinInitializationSettings());

//     /// on did receive notification response = for when app is opened via notification while in foreground on android
//     await FirebaseService._localNotificationsPlugin.initialize(initSettings, onDidReceiveNotificationResponse: FCMProvider.onTapNotification);

//     /// need this for ios foregournd notification
//     await FirebaseService.firebaseMessaging.setForegroundNotificationPresentationOptions(
//       alert: true, // Required to display a heads up notification
//       badge: true,
//       sound: true,
//     );
//   }

//   static NotificationDetails platformChannelSpecifics = const NotificationDetails(
//     android: AndroidNotificationDetails(
//       "high_importance_channel",
//       "High Importance Notifications",
//       priority: Priority.max,
//       importance: Importance.max,
//     ),
//   );

//   // for receiving message when app is in background or foreground
//   static Future<void> onMessage() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       dev.log('notification message ${message.data.toString()}');
//       if (Platform.isAndroid) {
//         // if this is available when Platform.isIOS, you'll receive the notification twice
//         await FirebaseService._localNotificationsPlugin.show(
//           0,
//           message.notification?.title,
//           message.notification?.body,
//           FirebaseService.platformChannelSpecifics,
//           payload: message.data.toString(),
//         );
//       }
//     });
//   }
//   // static Future<void> onMessage() async {
//   //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//   //     if (Platform.isAndroid) {
//   //       // if this is available when Platform.isIOS, you'll receive the notification twice
//   //       await FirebaseService._localNotificationsPlugin.show(
//   //         0,
//   //         message.notification?.title,
//   //         message.notification?.body,
//   //         FirebaseService.platformChannelSpecifics,
//   //         payload: message.data.toString(),
//   //       );
//   //     }
//   //   });
//   // }

//   @pragma('vm:entry-point')
//   static Future<void> onBackgroundMsg() async {
//     FirebaseMessaging.onBackgroundMessage(FCMProvider.backgroundHandler);
//   }
// }

// //   static NotificationDetails platformChannelSpecifics = NotificationDetails(
// //     android: AndroidNotificationDetails(
// //       "high_importance_channel", "High Importance Notifications", priority: Priority.max, importance: Importance.max,
// //     ),
// //   );

// //   // for receiving message when app is in background or foreground
// //   static Future<void> onMessage() async {
// //     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
// //       if (Platform.isAndroid) {
// //         // if this is available when Platform.isIOS, you'll receive the notification twice
// //         await FirebaseService._localNotificationsPlugin.show(
// //           0, message.notification!.title, message.notification!.body, FirebaseService.platformChannelSpecifics,
// //           payload: message.data.toString(),
// //         );
// //       }
// //     });
// //   }

// //   static Future<void> onBackgroundMsg() async {
// //     FirebaseMessaging.onBackgroundMessage(FCMProvider.backgroundHandler);
// //   }

// // }

// class FCMProvider with ChangeNotifier {
//   static BuildContext? _context;

//   static void setContext(BuildContext context) => FCMProvider._context = context;

//   /// when app is in the foreground
//   static Future<void> onTapNotification(NotificationResponse? response) async {
//     if (FCMProvider._context == null || response?.payload == null) return;
//     //final  ayload = response!.;
//     // final Map _data = FCMProvider.convertPayload(response!.payload!);
//     // var encodedNotData = jsonEncode(_data);
//     // Map decNotData = jsonDecode(encodedNotData);
//     // dev.log('From notification $_data');
//     // final localProvider = Provider.of<LocalStoreProvider>(_context!, listen: false);

//     //await Navigator.of(FCMProvider._context!).push(),
//     // await Navigator.of(FCMProvider._context!).push(MaterialPageRoute(
//     //   // builder: (_context) => DraftScreen(notSTitle:decNotData['woID']),
//     //   builder: (_context) =>
//     //       // HomeScreen(techID: localProvider.newAutoLogin().$1, username: localProvider.newAutoLogin().$2, notifcationStringData: response!.payload),
//     // ));
//   }

//   static Future<void> onTrayMessage() async {
//     if (FCMProvider._context == null) return;
//     //final localProvider = Provider.of<LocalStoreProvider>(_context!, listen: false);
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? event) async {
//       if (event != null) {
//         // await Navigator.of(FCMProvider._context!).push(MaterialPageRoute(
//         //   builder: (_context) =>
//         //     //  HomeScreen(techID: localProvider.newAutoLogin().$1, username: localProvider.newAutoLogin().$2, notifcationMessage: event),
//         // ));
//       }
//     });
//   }

//   static Map convertPayload(String payload) {
//     final String _payload = payload.substring(1, payload.length - 1);
//     List<String> _split = [];
//     _payload.split(",")..forEach((String s) => _split.addAll(s.split(":")));
//     Map _mapped = {};
//     for (int i = 0; i < _split.length + 1; i++) {
//       if (i % 2 == 1) _mapped.addAll({_split[i - 1].trim().toString(): _split[i].trim()});
//     }
//     return _mapped;
//   }

//   static Future<void> onMessage() async {
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       //if (FCMProvider._refreshNotifications != null) await FCMProvider._refreshNotifications!(true);
//       // if this is available when Platform.isIOS, you'll receive the notification twice
//       if (Platform.isAndroid) {
//         await FirebaseService._localNotificationsPlugin.show(
//           0,
//           message.notification!.title,
//           message.notification!.body,
//           FirebaseService.platformChannelSpecifics,
//           payload: message.data.toString(),
//         );
//         //   navigatorKey.currentState?.push(MaterialPageRoute(
//         //   builder: (context) => HomeScreen(
//         //     techID:  Provider.of<LocalStoreProvider>(context, listen: false).newAutoLogin().$1,
//         //     username:  Provider.of<LocalStoreProvider>(context, listen: false).newAutoLogin().$2,
//         //     notifcationMessage: message,
//         //   ),
//         // ),);
//       }
//     });
//   }

//   static Future<void> backgroundHandler(RemoteMessage message) async {
//     //if (FCMProvider._context == null) return;
//     dev.log('notification message ${message.data.toString()}');
//     // final localProvider = Provider.of<LocalStoreProvider>(_context!, listen: false);
//     // navigatorKey.currentState?.push(MaterialPageRoute(
//     //     builder: (context) => HomeScreen(
//     //       techID:  Provider.of<LocalStoreProvider>(context, listen: false).newAutoLogin().$1,
//     //       username:  Provider.of<LocalStoreProvider>(context, listen: false).newAutoLogin().$2,
//     //       notifcationMessage: message,
//     //     ),
//     //   ),);
//     // Navigator.push(
//     //   _context!,
//     //   MaterialPageRoute(
//     //     builder: (context) => HomeScreen(
//     //       techID: localProvider.newAutoLogin().$1,
//     //       username: localProvider.newAutoLogin().$2,
//     //       notifcationMessage: message,
//     //     ),
//     //   ),
//     // );
//   }
// }
