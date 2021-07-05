import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailVerificationTextField extends StatelessWidget {
  const EmailVerificationTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.grey,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        fontSize: 39.sp,
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black87,
            width: 1.7.w,
          ),
        ),
        hintText: 'XXXX',
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
