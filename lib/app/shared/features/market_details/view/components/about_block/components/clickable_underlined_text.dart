import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_kit/simple_kit.dart';

class ClickableUnderlinedText extends StatelessWidget {
  const ClickableUnderlinedText({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          bottom: 3.h,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2.h,
            ),
          ),
        ),
        child: Text(
          text,
          style: sBodyText2Style,
        ),
      ),
    );
  }
}
