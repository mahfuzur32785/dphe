import 'package:dphe/components/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';

class UnderConstructionScreen extends StatelessWidget {
  const UnderConstructionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppbar(title: 'Under construction',),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('This Page is under construction',textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}