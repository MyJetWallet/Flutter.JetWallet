import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class EmailConfirmedSuccessText extends HookWidget {
  const EmailConfirmedSuccessText({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Column(
      children: [
        Row(), // to expand Column in the cross axis
        Baseline(
          baseline: 31.4.h,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            'Your email address',
            style: sBodyText1Style.copyWith(
              color: colors.grey1,
            ),
          ),
        ),
        Text(
          email,
          style: sBodyText1Style.copyWith(
            color: colors.black,
          ),
        ),
        Text(
          'is confirmed',
          style: sBodyText1Style.copyWith(
            color: colors.grey1,
          ),
        ),
      ],
    );
  }
}
