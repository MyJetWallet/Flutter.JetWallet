import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../model/pin_box_enum.dart';

class PinBox extends HookWidget {
  const PinBox({
    Key? key,
    required this.state,
  }) : super(key: key);

  final PinBoxEnum state;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Container(
      width: 12.r,
      height: 12.r,
      decoration: BoxDecoration(
        color: state.color(
          colors.black,
          colors.blue,
          colors.green,
          colors.red,
        ),
        shape: BoxShape.circle,
      ),
      padding: state == PinBoxEnum.empty ? EdgeInsets.all(2.r) : null,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      child: state == PinBoxEnum.empty
          ? Container(
              decoration: BoxDecoration(
                color: colors.white,
                shape: BoxShape.circle,
              ),
            )
          : const SizedBox(),
    );
  }
}
