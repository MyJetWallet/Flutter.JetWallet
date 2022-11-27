import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/shared/simple_transparent_ink_well.dart';

import '../../../../simple_kit.dart';

class SProfileDetailsButton extends StatelessWidget {
  const SProfileDetailsButton({
    Key? key,
    required this.onTap,
    required this.label,
    required this.value,
  }) : super(key: key);

  final String label;
  final String value;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return STransparentInkWell(
      onTap: onTap,
      child: SPaddingH24(
        child: Container(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Baseline(
                baseline: 38.0,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  label,
                  style: sBodyText2Style.copyWith(
                    color: SColorsLight().grey1,
                  ),
                ),
              ),
              Baseline(
                baseline: 24.0,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  value,
                  style: sBodyText1Style,
                ),
              ),
              const SpaceH20(),
              const SDivider(),
            ],
          ),
        ),
      ),
    );
  }
}
