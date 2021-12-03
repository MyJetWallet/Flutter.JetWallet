import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SRequirement extends StatelessWidget {
  const SRequirement({
    Key? key,
    this.isError = false,
    this.loading = false,
    required this.passed,
    required this.description,
  }) : super(key: key);

  final bool isError;
  final bool loading;
  final bool passed;
  final String description;

  @override
  Widget build(BuildContext context) {
    var color = SColorsLight().black;
    late Widget icon;

    if (isError) {
      icon = const SCrossIcon();
    } else if (loading) {
      icon = const _RequirementLoading();
    } else if (passed) {
      icon = const STickSelectedIcon();
    } else {
      icon = const STickIcon();
      color = SColorsLight().grey2;
    }

    return SizedBox(
      height: 24.h,
      child: Row(
        children: [
          icon,
          const SpaceW10(),
          Text(
            description,
            style: sCaptionTextStyle.copyWith(
              color: color,
            ),
          )
        ],
      ),
    );
  }
}

class _RequirementLoading extends StatelessWidget {
  const _RequirementLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16.r,
      height: 16.r,
      child: CircularProgressIndicator(
        color: SColorsLight().black,
        strokeWidth: 2.w,
      ),
    );
  }
}
