import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class DepositWithTagInfo extends HookWidget {
  const DepositWithTagInfo();

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Container(
      width: double.infinity,
      color: colors.blueLight,
      height: 88.h,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 40.r,
          ),
          child: Text(
            'Tag and Address both are required to receive XRP.',
            maxLines: 3,
            textAlign: TextAlign.center,
            style: sBodyText1Style,
          ),
        ),
      ),
    );
  }
}
