import 'package:flutter/material.dart';

import '../../simple_kit.dart';
import '../colors/view/simple_colors_light.dart';

class SAssetItem extends StatelessWidget {
  const SAssetItem({
    Key? key,
    this.helper = '',
    this.isSelected = false,
    this.isCreditCard = false,
    required this.icon,
    required this.name,
    required this.amount,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  final String helper;
  final bool isSelected;
  final bool isCreditCard;
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
          height: 88.0,
          child: Column(
            children: [
              const SpaceH22(),
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
                            SizedBox(
                              width: isCreditCard ? 180.0 : 150.0,
                              child: Baseline(
                                baseline: 17.8,
                                baselineType: TextBaseline.alphabetic,
                                child: Text(
                                  name,
                                  style: sSubtitle2Style.copyWith(
                                    color: mainColor,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: isCreditCard ? 90.0 : 120.0,
                              child: Text(
                                amount,
                                textAlign: TextAlign.end,
                                style: sSubtitle2Style.copyWith(
                                  color: mainColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            SizedBox(
                              width: isCreditCard ? 180.0 : 150.0,
                              child: Baseline(
                                baseline: 15.4,
                                baselineType: TextBaseline.alphabetic,
                                child: Text(
                                  description,
                                  style: sCaptionTextStyle.copyWith(
                                    color: SColorsLight().grey3,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (isCreditCard)
                              SizedBox(
                                width: 90.0,
                                child: Text(
                                  helper,
                                  textAlign: TextAlign.end,
                                  style: sCaptionTextStyle.copyWith(
                                    color: SColorsLight().grey3,
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
              const Spacer(),
              const SDivider(
                width: 327.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
