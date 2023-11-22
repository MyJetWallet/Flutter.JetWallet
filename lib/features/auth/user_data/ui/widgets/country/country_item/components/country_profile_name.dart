import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class CountryProfileName extends StatelessWidget {
  const CountryProfileName({
    super.key,
    required this.countryName,
    required this.isBlocked,
    this.needBaseline = true,
  });

  final String countryName;
  final bool isBlocked;
  final bool needBaseline;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final size = MediaQuery.of(context).size;

    return needBaseline
        ? Baseline(
            baseline: 38.0,
            baselineType: TextBaseline.alphabetic,
            child: Row(
              children: [
                const SpaceW10(),
                SizedBox(
                  width: size.width - 140.0,
                  child: Text(
                    countryName,
                    style: sSubtitle2Style.copyWith(
                      color: isBlocked ? colors.grey3 : colors.black,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Row(
            children: [
              const SpaceW10(),
              Text(
                countryName,
                style: sSubtitle2Style.copyWith(
                  color: isBlocked ? colors.grey3 : colors.black,
                ),
              ),
            ],
          );
  }
}
