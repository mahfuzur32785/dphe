import 'package:dphe/provider/operation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

void showUpdateDialog({required BuildContext context}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Theme(
          data: ThemeData(dialogBackgroundColor: Colors.white,),
          
          child: AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: Text('Update Available'),
            content: Container(
              decoration: BoxDecoration(color: Colors.white),
              height: 190,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The System requires you to update your app. You cannot acces the app without Updating.',
                    maxLines: 5,
                  ),
                ],
              ),
            ),
            actions: [
              Divider(),
              Consumer<OperationProvider>(builder: (context, op, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    op.searchUriFromInternet(isSupport: false,phone: '');
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}
