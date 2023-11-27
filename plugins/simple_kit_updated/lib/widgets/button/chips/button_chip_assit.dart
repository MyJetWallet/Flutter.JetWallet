import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

class ByttonChipAssist extends StatelessWidget {
  const ByttonChipAssist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Color(0xFFE0E4EA)),
            top: BorderSide(color: Color(0xFFE0E4EA)),
            right: BorderSide(color: Color(0xFFE0E4EA)),
            bottom: BorderSide(width: 1, color: Color(0xFFE0E4EA)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Assets.svg.small.info.simpleSvg(
                color: SColorsLight().gray10,
              ),
              const Gap(8),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .5,
                ),
                child: Text(
                  'Label',
                  style: STStyles.body1Semibold.copyWith(
                    color: SColorsLight().gray10,
                  ),
                ),
              ),
              const Gap(24),
              Text(
                '0',
                style: STStyles.body2Semibold,
              ),
              const Gap(8),
              Assets.svg.medium.shevronRight.simpleSvg(
                color: SColorsLight().gray10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
