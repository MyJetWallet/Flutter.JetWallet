import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/shared/blue_bank_icon.dart';

class SpecificButton extends StatelessWidget {
  const SpecificButton({
    Key? key,
    this.isLoading = false,
    this.hasCardIcon = false,
    this.hasRightArrow = true,
    required this.label,
  }) : super(key: key);

  final bool isLoading;
  final bool hasCardIcon;
  final bool hasRightArrow;

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          color: SColorsLight().gray2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: isLoading ? 10 : 8,
          ),
          child: Row(
            children: [
              if (isLoading) ...[
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: SColorsLight().gray10,
                    strokeWidth: 1,
                  ),
                ),
              ] else ...[
                if (hasCardIcon) ...[
                  SizedBox(
                    width: 55,
                    height: 24,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 19,
                          child: Assets.svg.paymentMethodsCards.simple.hoverCard.simpleSvg(),
                        ),
                        const BlueBankIcon(
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const BlueBankIcon(
                    size: 24,
                  ),
                ]
              ],
              const Gap(8),
              Text(
                label,
                style: STStyles.body2Semibold.copyWith(
                  color: isLoading ? SColorsLight().gray10 : SColorsLight().black,
                ),
              ),
              if (hasRightArrow) ...[
                const Spacer(),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Assets.svg.medium.shevronRight.simpleSvg(width: 20, height: 20),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
