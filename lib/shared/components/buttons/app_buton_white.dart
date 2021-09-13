import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_button.dart';

class AppButtonWhite extends StatelessWidget {
  const AppButtonWhite({
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      textColor: Colors.black,
    );
  }
}
