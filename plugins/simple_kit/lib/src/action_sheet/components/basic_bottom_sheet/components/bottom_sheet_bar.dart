import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../simple_kit.dart';

class BottomSheetBar extends StatelessWidget {
  const BottomSheetBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10.h,
        bottom: 15.h,
      ),
      child: Container(
        width: 130.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: SColorsLight().grey2,
          borderRadius: BorderRadius.all(
            Radius.circular(20.r),
          ),
        ),
      ),
    );
  }
}
