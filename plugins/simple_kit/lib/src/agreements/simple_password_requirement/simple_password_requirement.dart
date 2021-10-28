import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SPasswordRequirement extends StatelessWidget {
  const SPasswordRequirement({
    Key? key,
    required this.passed,
    required this.description,
  }) : super(key: key);

  final bool passed;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.h,
      child: Row(
        children: [
          if (passed) const STickSelectedIcon() else const STickIcon(),
          const SpaceW10(),
          Text(
            description,
            style: sCaptionTextStyle.copyWith(
              color: passed ? SColorsLight().black : SColorsLight().grey2,
            ),
          )
        ],
      ),
    );
  }
}
