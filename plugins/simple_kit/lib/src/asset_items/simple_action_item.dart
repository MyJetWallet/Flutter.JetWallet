import 'package:flutter/material.dart';

import '../../simple_kit.dart';
import '../colors/view/simple_colors_light.dart';

class SActionItem extends StatelessWidget {
  const SActionItem({
    Key? key,
    this.helper = '',
    this.withDivider = false,
    this.isSelected = false,
    required this.icon,
    required this.name,
    required this.onTap,
    required this.description,
  }) : super(key: key);

  final String helper;
  final bool withDivider;
  final bool isSelected;
  final Widget icon;
  final String name;
  final Function() onTap;
  final String description;

  @override
  Widget build(BuildContext context) {
    final mainColor = isSelected ? SColorsLight().blue : SColorsLight().black;

    return InkWell(
      highlightColor: SColorsLight().grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: 64.0,
          child: Column(
            children: [
              const SpaceH10(),
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
                        Baseline(
                          baseline: 14.0,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            description,
                            style: sCaptionTextStyle.copyWith(
                              color: SColorsLight().grey3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (withDivider) const SDivider(),
            ],
          ),
        ),
      ),
    );
  }
}
