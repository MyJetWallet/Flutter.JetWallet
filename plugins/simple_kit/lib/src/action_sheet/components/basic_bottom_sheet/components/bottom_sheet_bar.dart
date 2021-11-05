import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../simple_kit.dart';

class BottomSheetBar extends StatelessWidget {
  const BottomSheetBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: SColorsLight().grey4,
        borderRadius: BorderRadius.all(
          Radius.circular(4.r),
        ),
      ),
    );
  }
}
