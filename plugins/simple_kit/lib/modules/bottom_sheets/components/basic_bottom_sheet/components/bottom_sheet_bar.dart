import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

class BottomSheetBar extends StatelessWidget {
  const BottomSheetBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.0,
      height: 4.0,
      decoration: BoxDecoration(
        color: SColorsLight().grey4,
        borderRadius: const BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
    );
  }
}
