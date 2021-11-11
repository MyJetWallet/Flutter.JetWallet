import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class AppVersionInContainer extends HookWidget {
  const AppVersionInContainer({
    Key? key,
    required this.versionText,
  }) : super(key: key);

  final String versionText;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
        horizontal: 10.h,
      ),
      decoration: BoxDecoration(
        color: colors.grey5,
        borderRadius: BorderRadius.circular(
          16.r,
        ),
      ),
      alignment: Alignment.center,
      height: 26.h,
      child: Text(
        versionText,
        style: sCaptionTextStyle.copyWith(
          color: colors.grey1,
        ),
      ),
    );
  }
}
