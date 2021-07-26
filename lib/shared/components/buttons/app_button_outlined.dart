import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_button.dart';

class AppButtonOutlined extends StatelessWidget {
  const AppButtonOutlined({
    Key? key,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: name,
      onTap: onTap,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(8.r),
      ),
      textColor: Colors.black,
    );
  }
}
