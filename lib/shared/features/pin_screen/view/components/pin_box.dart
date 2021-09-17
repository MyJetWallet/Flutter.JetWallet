import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/pin_box_enum.dart';

class PinBox extends StatelessWidget {
  const PinBox({
    Key? key,
    required this.state,
  }) : super(key: key);

  final PinBoxEnum state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16.r,
      height: 16.r,
      decoration: BoxDecoration(
        color: state.color,
        shape: BoxShape.circle,
      ),
      padding: state == PinBoxEnum.empty ? EdgeInsets.all(3.r) : null,
      child: state == PinBoxEnum.empty
          ? Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            )
          : const SizedBox(),
    );
  }
}
