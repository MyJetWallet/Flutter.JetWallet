import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'auth_button.dart';

class AuthButtonOutlined extends StatelessWidget {
  const AuthButtonOutlined({
    Key? key,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return AuthButton(
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
