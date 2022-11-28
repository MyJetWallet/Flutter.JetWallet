import 'package:flutter/material.dart';
import 'package:jetwallet/features/pin_screen/model/pin_box_enum.dart';
import 'package:simple_kit/simple_kit.dart';

class PinBox extends StatelessWidget {
  const PinBox({
    Key? key,
    required this.state,
  }) : super(key: key);

  final PinBoxEnum state;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

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
