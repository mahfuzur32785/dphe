import 'package:flutter/material.dart';

class DlcVerifyDialog extends StatefulWidget {
  const DlcVerifyDialog({super.key});

  @override
  State<DlcVerifyDialog> createState() => _DlcVerifyDialogState();
}

class _DlcVerifyDialogState extends State<DlcVerifyDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('verify'),
    );
  }
}