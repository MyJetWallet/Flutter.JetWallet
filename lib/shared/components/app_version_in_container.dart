import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_kit/simple_kit.dart';

class AppVersionInContainer extends StatelessWidget {
  const AppVersionInContainer({
    Key? key,
    required this.version,
    required this.buildNumber,
    required this.bgColor,
    required this.textColor,
  }) : super(key: key);

  final String version;
  final String buildNumber;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      alignment: Alignment.center,
      height: 26.h,
      child: Text(
        'Version: $version ($buildNumber)',
        style: sCaptionTextStyle.copyWith(color: textColor),
      ),
    );
  }
}
