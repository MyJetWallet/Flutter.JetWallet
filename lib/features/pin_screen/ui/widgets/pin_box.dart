import 'package:flutter/material.dart';
import 'package:jetwallet/features/pin_screen/model/pin_box_enum.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class PinBox extends StatelessWidget {
  const PinBox({
    super.key,
    this.margin = const EdgeInsets.symmetric(horizontal: 15.0),
    required this.state,
  });

  final PinBoxEnum state;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

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
      margin: margin,
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
