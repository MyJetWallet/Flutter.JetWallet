import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_kit/simple_kit.dart';

class ItemMenuWithSimpleIcon extends HookWidget {
  const ItemMenuWithSimpleIcon({
    Key? key,
    this.onTap,
    this.icon,
    required this.title,
  }) : super(key: key);

  final Widget? icon;
  final Function()? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30.h,
        margin: EdgeInsets.symmetric(
          vertical: 18.h,
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 20.w),
              child: icon,
            ),
            Text(
              title,
              style: sSubtitle1Style,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
