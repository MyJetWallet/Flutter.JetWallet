import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    required this.value,
    this.isDisabled = false,
  }) : super(key: key);

  final bool isDisabled;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: SColorsLight().gray2),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Text(
            value,
            style: STStyles.subtitle1.copyWith(
              color: isDisabled ? SColorsLight().gray6 : SColorsLight().black,
            ),
          ),
        ),
      ),
    );
  }
}
