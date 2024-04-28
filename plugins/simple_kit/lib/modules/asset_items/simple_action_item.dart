import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/shared/simple_divider.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

class SActionItem extends StatelessWidget {
  const SActionItem({
    super.key,
    this.helper = '',
    this.withDivider = false,
    this.isSelected = false,
    this.expanded = false,
    required this.icon,
    required this.name,
    required this.onTap,
    required this.description,
  });

  final String helper;
  final bool withDivider;
  final bool isSelected;
  final bool expanded;
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
          height: expanded ? 88.0 : 64.0,
          child: Column(
            children: [
              if (expanded) ...[
                const SpaceH22(),
              ] else ...[
                const SpaceH10(),
              ],
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
                            Text(
                              helper,
                              textAlign: TextAlign.end,
                              style: sCaptionTextStyle.copyWith(
                                color: SColorsLight().grey3,
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
