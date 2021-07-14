import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'auth_button.dart';

class AuthButtonGrey extends StatelessWidget {
  const AuthButtonGrey({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return AuthButton(
      text: text,
      onTap: onTap,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8.r),
      ),
      textColor: Colors.white,
    );
  }
}
