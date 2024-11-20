import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class RememberMeWidget extends StatelessWidget {
  final bool isRememberMe;
  final Function(bool?)? onChanged;
  const RememberMeWidget(
      {super.key, required this.isRememberMe, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: isRememberMe,
            activeColor: MyColors.primaryColor,
            //fillColor:,
            onChanged: onChanged,
          ),
          Text(
            'Remember Me',
            style: TextStyle(color: MyColors.primaryColor),
          ),
        ],
      ),
    );
  }
}
