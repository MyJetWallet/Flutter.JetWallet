import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class DepositCategoryDescription extends HookWidget {
  const DepositCategoryDescription({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Container(
      height: 21.h,
      padding: EdgeInsets.only(
        left: 24.w,
      ),
      child: Row(
        children: [
          Text(
            text,
            style: sCaptionTextStyle.copyWith(
              color: colors.grey3,
            ),
          ),
          const SpaceW10(),
          Expanded(
            child: SDivider(
              color: colors.grey3,
            ),
          )
        ],
      ),
    );
  }
}
