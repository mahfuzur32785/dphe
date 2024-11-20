import 'package:flutter/material.dart';
import '../../utils/global_keys.dart';

class CustomSnackBar {
  final String? message;
  bool? isSuccess;
  final int seconds;

  CustomSnackBar({
    this.message,
    this.isSuccess=true,
    this.seconds = 3
  });

  show() {
    snackBarKey.currentState?.showSnackBar(SnackBar(
      duration:  Duration(seconds: seconds),
      behavior: SnackBarBehavior.floating,
      //margin: const EdgeInsets.only(top: 100.0),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Row(
          children: [
            Container(
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSuccess! ? Colors.green : Colors.red,
              ),
              child: Icon(
                isSuccess! ? Icons.check : Icons.close,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 5,
            ),

            Expanded(
              child: Text(message != null ? message! : "Something Went Wrong",
                  style: TextStyle(
                    fontSize: 12,
                    color: isSuccess! ? Colors.green : Colors.red,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    ));
  }
}