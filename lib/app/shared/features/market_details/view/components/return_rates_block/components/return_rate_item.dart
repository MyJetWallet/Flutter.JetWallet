import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class ReturnRateItem extends HookWidget {
  const ReturnRateItem({
    Key? key,
    required this.header,
    required this.value,
  }) : super(key: key);

  final String header;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final periodChangeColor = value.contains('-') ? colors.red : colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 44.h,
          child: Baseline(
            baseline: 41.h,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              header,
              style: sBodyText2Style.copyWith(
                color: colors.grey1,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 24.h,
          child: Baseline(
            baseline: 21.h,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              value,
              style: sBodyText1Style.copyWith(
                color: periodChangeColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
