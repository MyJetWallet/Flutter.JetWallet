import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FrameActionButton extends StatelessWidget {
  const FrameActionButton({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          top: 6.h,
          bottom: 6.h,
          right: 10.w,
        ),
        child: Icon(
          icon,
          size: 22.r,
        ),
      ),
    );
  }
}
