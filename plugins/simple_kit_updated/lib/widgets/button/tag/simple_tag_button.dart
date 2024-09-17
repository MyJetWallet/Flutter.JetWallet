import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

enum TagButtonState { defaultt, active, disabled, selected }

class STagButton extends StatelessWidget {
  const STagButton({
    super.key,
    required this.lable,
    this.onTap,
    this.state = TagButtonState.defaultt,
  });

  final String lable;
  final void Function()? onTap;
  final TagButtonState state;

  @override
  Widget build(BuildContext context) {
    return SafeGesture(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: ShapeDecoration(
          color: getBGColorByType(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          lable,
          style: STStyles.body2Bold.copyWith(
            color: getTextColorByType(),
          ),
        ),
      ),
    );
  }

  Color getTextColorByType() {
    switch (state) {
      case TagButtonState.defaultt:
        return SColorsLight().black;
      case TagButtonState.active:
        return SColorsLight().black;
      case TagButtonState.disabled:
        return SColorsLight().gray8;
      case TagButtonState.selected:
        return SColorsLight().white;
    }
  }

  Color getBGColorByType() {
    switch (state) {
      case TagButtonState.defaultt:
        return SColorsLight().gray2;
      case TagButtonState.active:
        return SColorsLight().gray4;
      case TagButtonState.disabled:
        return SColorsLight().gray2;
      case TagButtonState.selected:
        return SColorsLight().black;
    }
  }
}
