// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SimpleStandardFieldExample extends StatelessWidget {
  const SimpleStandardFieldExample({Key? key}) : super(key: key);

  static const routeName = '/simple_standard_field_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
          ),
          child: Container(
            color: Colors.grey[50],
            height: 88.h,
            child: Center(
              child: TextField(
                cursorWidth: 3.w,
                cursorColor: SColorsLight().blue,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: SColorsLight().black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Email address',
                  labelStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: SColorsLight().grey2,
                  ),
                  suffixIconConstraints: BoxConstraints(
                    maxWidth: 24.w,
                    maxHeight: 24.w,
                    minWidth: 24.w,
                    minHeight: 24.w,
                  ),
                  suffixIcon: SLightMailIcon(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
