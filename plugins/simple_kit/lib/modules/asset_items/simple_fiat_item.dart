import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SFiatItem extends StatelessWidget {
  const SFiatItem({
    super.key,
    this.isSelected = false,
    this.description = '',
    required this.icon,
    required this.name,
    required this.amount,
    required this.onTap,
  });

  final bool isSelected;
  final Widget icon;
  final String name;
  final String amount;
  final String description;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final mainColor = isSelected ? SColorsLight().blue : SColorsLight().black;

    return InkWell(
      highlightColor: SColorsLight().grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: 88,
          child: Column(
            children: [
              const SpaceH32(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  icon,
                  const SpaceW20(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Expanded(
                              child: Baseline(
                                baseline: 18.0,
                                baselineType: TextBaseline.alphabetic,
                                child: Text(
                                  name,
                                  style: sSubtitle2Style.copyWith(
                                    color: mainColor,
                                  ),
                                ),
                              ),
                            ),
                            const SpaceW16(),
                            Baseline(
                              baseline: 18.0,
                              baselineType: TextBaseline.alphabetic,
                              child: SizedBox(
                                width: 120.0,
                                child: Text(
                                  amount,
                                  textAlign: TextAlign.end,
                                  style: sSubtitle2Style.copyWith(
                                    color: mainColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: Baseline(
                                  baseline: 14.0,
                                  baselineType: TextBaseline.alphabetic,
                                  child: Text(
                                    description,
                                    style: sCaptionTextStyle.copyWith(
                                      color: SColorsLight().grey3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SpaceW16(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const SDivider(
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
