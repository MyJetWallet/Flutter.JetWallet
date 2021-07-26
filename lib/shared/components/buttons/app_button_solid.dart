import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_button.dart';

class AppButtonSolid extends StatelessWidget {
  const AppButtonSolid({
    Key? key,
    this.active = true,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final bool active;
  final String name;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: name,
      onTap: onTap,
      decoration: BoxDecoration(
        color: active ? Colors.grey[800] : Colors.grey[400],
        borderRadius: BorderRadius.circular(8.r),
      ),
      textColor: Colors.white,
    );
  }
}
