import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class NumericKeyboardPreset extends StatelessWidget {
  const NumericKeyboardPreset({
    Key? key,
    required this.name,
    required this.onTap,
    required this.selected,
  }) : super(key: key);

  final String name;
  final Function() onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 102.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: selected ? SColorsLight().grey5 : SColorsLight().white,
          borderRadius: BorderRadius.circular(24.r),
          border: selected
              ? Border.all(
                  width: 2.w,
                )
              : null,
        ),
        child: Center(
          child: Text(
            name,
            style: sBodyText1Style.copyWith(
              color: selected ? SColorsLight().black : SColorsLight().grey1,
            ),
          ),
        ),
      ),
    );
  }
}
