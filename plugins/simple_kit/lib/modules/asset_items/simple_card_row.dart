import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SCardRow extends StatelessWidget {
  const SCardRow({
    Key? key,
    this.height = 72,
    this.helper = '',
    this.isSelected = false,
    this.divider = true,
    this.removeDivider = true,
    this.disabled = false,
    this.lightDivider = false,
    this.rightIcon,
    this.spaceBIandText = 18,
    this.needSpacer = false,
    required this.icon,
    required this.name,
    required this.amount,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  final double height;

  final String helper;
  final bool isSelected;
  final bool divider;
  final bool removeDivider;
  final bool disabled;
  final bool lightDivider;
  final bool needSpacer;
  final Widget icon;
  final Widget? rightIcon;
  final String name;
  final String amount;
  final String description;
  final Function() onTap;
  final double spaceBIandText;

  @override
  Widget build(BuildContext context) {
    final mainColor = disabled
        ? SColorsLight().grey2
        : isSelected
            ? SColorsLight().blue
            : SColorsLight().black;

    return InkWell(
      highlightColor: SColorsLight().grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: !removeDivider ? 0 : 13,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!removeDivider) ...[
                const SizedBox(height: 20),
              ],
              Row(
                crossAxisAlignment: helper.isNotEmpty
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  icon,
                  SizedBox(width: spaceBIandText),
                  SizedBox(
                    height: helper.isNotEmpty ? 46 : 28,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: sTextH5Style.copyWith(
                            color: mainColor,
                          ),
                        ),
                        if (helper.isNotEmpty) ...[
                          Baseline(
                            baseline: 14.0,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              helper,
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              style: sCaptionTextStyle.copyWith(
                                color: SColorsLight().grey3,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!needSpacer) ...[
                    const SpaceW12(),
                  ] else ...[
                    const Spacer(),
                  ],
                  if (rightIcon != null) rightIcon!,
                ],
              ),
              const Spacer(),
              if (!removeDivider) ...[
                if (divider) ...[
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: SDivider(
                      width: double.infinity,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
