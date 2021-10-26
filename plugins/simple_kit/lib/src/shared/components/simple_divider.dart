import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SDivider extends StatelessWidget {
  const SDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SColorsLight().grey4,
      height: 1.h,
    );
  }
}
