import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class CountryProfileName extends StatelessWidget {
  const CountryProfileName({
    super.key,
    required this.countryName,
    required this.isBlocked,
  });

  final String countryName;
  final bool isBlocked;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Flexible(
      child: Row(
        children: [
          const SpaceW10(),
          Flexible(
            child: Text(
              countryName,
              style: STStyles.subtitle1.copyWith(
                color: isBlocked ? colors.gray6 : colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
