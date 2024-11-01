import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../../simple_kit.dart';

class SProfileDetailsButton extends StatelessWidget {
  const SProfileDetailsButton({
    super.key,
    this.showIcon = false,
    this.isDivider = true,
    required this.onTap,
    required this.label,
    required this.value,
  });

  final bool showIcon;
  final bool isDivider;
  final String label;
  final String value;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return STransparentInkWell(
      // ignore: no-empty-block
      onTap: showIcon ? () {} : onTap,
      child: SPaddingH24(
        child: Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Stack(
            children: [
              Column(
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
                  SDivider(
                    color: isDivider ? SColorsLight().grey4 : Colors.transparent,
                  ),
                ],
              ),
              if (showIcon)
                Positioned(
                  right: 0,
                  top: 32.0,
                  child: SIconButton(
                    onTap: onTap,
                    defaultIcon: const SEditIcon(),
                    pressedIcon: SEditIcon(color: SColorsLight().grey3),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
