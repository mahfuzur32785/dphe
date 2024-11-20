// import 'dart:convert';

// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

// PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

// class PusherServices {
//   initPusher({dynamic Function(PusherEvent)? onEvent}) async {
//     PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
//     try {
//       await pusher.init(
//         apiKey: "88d3dc924caf9db4a4f2",
//         cluster: "ap1",
//         onConnectionStateChange: onConnectionStateChange,
//         onError: onError,
//         onSubscriptionSucceeded: onSubscriptionSucceeded,
//         onEvent: onEvent,
//         onSubscriptionError: onSubscriptionError,
//         onDecryptionFailure: onDecryptionFailure,
//         onMemberAdded: onMemberAdded,
//         onMemberRemoved: onMemberRemoved,
//         // authEndpoint: "<Your Authendpoint>",
//         // onAuthorizer: onAuthorizer
//       );
//       await pusher.subscribe(channelName: 'dphe-notification-channel');
//       await pusher.connect();
//     } catch (e) {
//       print("ERROR: $e");
//     }
//   }

//   void onConnectionStateChange(dynamic currentState, dynamic previousState) {
//     print("Connection: $currentState");
//   }

//   void onError(String message, int? code, dynamic e) {
//     print("onError: $message code: $code exception: $e");
//   }

//   String notificationData = '';

//   // void onEvent(PusherEvent event) {
//   //   var eventbyChannel = PusherEvent(channelName: 'dphe-notification-channel', eventName: 'dphe-notification-event');
//   //   var pusherData = jsonDecode(eventbyChannel.data);
   
//   //   print(eventbyChannel.userId);
//   //   print(eventbyChannel.data);
//   //    print('pusher data user id ${pusherData['message']['user_id']}');
//   //   notificationData = eventbyChannel.data;
//   //   print("onEvent: $event");
//   // }

 


 

//   void onSubscriptionSucceeded(String channelName, dynamic data) {
//     print("onSubscriptionSucceeded: $channelName data: $data");
//     final me = pusher.getChannel(channelName)?.me;
//     print("Me: $me");
//   }

//   void onSubscriptionError(String message, dynamic e) {
//     print("onSubscriptionError: $message Exception: $e");
//   }

//   void onDecryptionFailure(String event, String reason) {
//     print("onDecryptionFailure: $event reason: $reason");
//   }

//   void onMemberAdded(String channelName, PusherMember member) {
//     print("onMemberAdded: $channelName user: $member");
//   }

//   void onMemberRemoved(String channelName, PusherMember member) {
//     print("onMemberRemoved: $channelName user: $member");
//   }

//   void onSubscriptionCount(String channelName, int subscriptionCount) {
//     print("onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount");
//   }
// }

// class PusherClientServices {}


// class PusherNotifModel {
//   Message? message;

//   PusherNotifModel({this.message});

//   PusherNotifModel.fromJson(Map<String, dynamic> json) {
//     message =
//         json['message'] != null ? new Message.fromJson(json['message']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.message != null) {
//       data['message'] = this.message!.toJson();
//     }
//     return data;
//   }
// }

// class Message {
//   int? id;
//   int? userId;
//   String? platform;
//   dynamic title;
//   String? appTitle;
//   dynamic message;
//  dynamic type;
//   dynamic webUrl;
//   String? appUrl;
//   dynamic status;
//  dynamic readAt;
//   int? createdBy;
//   String? createdAt;
//   String? updatedAt;
//   String? createdAtHuman;

//   Message(
//       {this.id,
//       this.userId,
//       this.platform,
//       this.title,
//       this.appTitle,
//       this.message,
//       this.type,
//       this.webUrl,
//       this.appUrl,
//       this.status,
//       this.readAt,
//       this.createdBy,
//       this.createdAt,
//       this.updatedAt,
//       this.createdAtHuman});

//   Message.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     platform = json['platform'];
//     title = json['title'];
//     appTitle = json['app_title'];
//     message = json['message'];
//     type = json['type'];
//     webUrl = json['web_url'];
//     appUrl = json['app_url'];
//     status = json['status'];
//     readAt = json['read_at'];
//     createdBy = json['created_by'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     createdAtHuman = json['created_at_human'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['platform'] = this.platform;
//     data['title'] = this.title;
//     data['app_title'] = this.appTitle;
//     data['message'] = this.message;
//     data['type'] = this.type;
//     data['web_url'] = this.webUrl;
//     data['app_url'] = this.appUrl;
//     data['status'] = this.status;
//     data['read_at'] = this.readAt;
//     data['created_by'] = this.createdBy;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['created_at_human'] = this.createdAtHuman;
//     return data;
//   }
// }