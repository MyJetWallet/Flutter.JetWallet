import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
      width: 12.0,
      height: 12.0,
      decoration: BoxDecoration(
        color: state.color(
          colors.black,
          colors.blue,
          colors.green,
          colors.red,
        ),
        shape: BoxShape.circle,
      ),
      padding: state == PinBoxEnum.empty ? const EdgeInsets.all(2.0) : null,
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      child: state == PinBoxEnum.empty
          ? DecoratedBox(
              decoration: BoxDecoration(
                color: colors.white,
                shape: BoxShape.circle,
              ),
            )
          : const SizedBox(),
    );
  }
}
