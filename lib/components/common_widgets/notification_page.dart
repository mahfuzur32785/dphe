// import 'package:dphe/provider/operation_provider.dart';
// import 'package:dphe/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class NotificationPage extends StatelessWidget {
//   const NotificationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Consumer<OperationProvider>(builder: (context, op, child) {
//         return Scaffold(
//           backgroundColor: MyColors.backgroundColor,
//           body: Column(
//             children: [
//               op.eventMessage.isEmpty
//                   ? Expanded(child: Center(child: Text('No Notification Found')))
//                   : Expanded(
//                       child: ListView.builder(
//                       itemCount: op.eventMessage.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text('${ op.eventMessage[index].appTitle}'),
//                         );
//                       },
//                     ))
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
