import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../simple_kit.dart';

class NumericKeyboardPreset extends StatelessWidget {
  const NumericKeyboardPreset({
    Key? key,
    required this.name,
    required this.onTap,
    required this.selected,
  }) : super(key: key);

  final String name;
  final Function() onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48.0,
          decoration: BoxDecoration(
            color: selected ? SColorsLight().grey5 : SColorsLight().white,
            borderRadius: BorderRadius.circular(24.0),
            border: selected
                ? Border.all(
                    width: 2.0,
                  )
                : null,
          ),
          child: Center(
            child: Baseline(
              baseline: 15.0,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                name,
                style: sBodyText1Style.copyWith(
                  color: selected ? SColorsLight().black : SColorsLight().grey1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
