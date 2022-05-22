import 'package:flutter/material.dart';

import '../../simple_kit.dart';
import '../colors/view/simple_colors_light.dart';

class SAssetItem extends StatelessWidget {
  const SAssetItem({
    Key? key,
    this.helper = '',
    this.isSelected = false,
    this.isCreditCard = false,
    this.divider = true,
    this.removeDivider = false,
    required this.icon,
    required this.name,
    required this.amount,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  final String helper;
  final bool isSelected;
  final bool isCreditCard;
  final bool divider;
  final bool removeDivider;
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
      child: SizedBox(
        height: (!removeDivider && !divider) ? 108.0 : 88.0,
        child: Column(
          children: [
            const SpaceH22(),
            SPaddingH24(
              child: Row(
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
                                width: isCreditCard ? 90.0 : 120.0,
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
                            if (isCreditCard)
                              Baseline(
                                baseline: 14.0,
                                baselineType: TextBaseline.alphabetic,
                                child: SizedBox(
                                  width: 90.0,
                                  child: Text(
                                    helper,
                                    textAlign: TextAlign.end,
                                    style: sCaptionTextStyle.copyWith(
                                      color: SColorsLight().grey3,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (!removeDivider)
              if (divider)
                const SPaddingH24(
                  child: SDivider(
                    width: double.infinity,
                  ),
                )
              else
                Padding(
                  //padding: const EdgeInsets.symmetric(vertical: 10.0),
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: SDivider(
                    color: SColorsLight().grey3,
                    width: double.infinity,
                  ),
                )
          ],
        ),
      ),
    );
  }
}
