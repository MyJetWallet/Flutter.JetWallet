import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

@Deprecated('This is a widget from the old ui kit, please use the widget from the new ui kit')
class BottomSheetBar extends StatelessWidget {
  const BottomSheetBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 6,
      decoration: ShapeDecoration(
        color: SColorsLight().grey4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),
    );
  }
}
