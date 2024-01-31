import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SCardRow extends StatelessWidget {
  const SCardRow({
    Key? key,
    this.height = 80,
    this.helper = '',
    this.isSelected = false,
    this.divider = true,
    this.removeDivider = true,
    this.disabled = false,
    this.lightDivider = false,
    this.rightIcon,
    this.frozenIcon,
    this.spaceBIandText = 18,
    this.needSpacer = false,
    this.isLast = false,
    this.maxWidth,
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
  final bool isLast;
  final Widget icon;
  final Widget? rightIcon;
  final Widget? frozenIcon;
  final String name;
  final String amount;
  final String description;
  final VoidCallback onTap;
  final double spaceBIandText;
  final double? maxWidth;

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
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: !removeDivider ? 0 : 16,
            bottom: !removeDivider ? 0 : isLast ? 6 : 16,
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
                crossAxisAlignment: helper.isNotEmpty ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  icon,
                  SizedBox(width: spaceBIandText),
                  SizedBox(
                    height: helper.isNotEmpty ? 44 : 26,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: maxWidth ?? double.infinity,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: maxWidth ?? double.infinity,
                                ),
                                child: Text(
                                  name,
                                  style: sSubtitle2Style.copyWith(
                                    color: mainColor,
                                    height: 1.36,
                                  ),
                                ),
                              ),
                              if (frozenIcon != null) frozenIcon!,
                            ],
                          ),
                          if (helper.isNotEmpty) ...[
                            Baseline(
                              baseline: 14.0,
                              baselineType: TextBaseline.alphabetic,
                              child: Text(
                                helper,
                                textAlign: TextAlign.start,
                                maxLines: 3,
                                style: sBodyText2Style.copyWith(
                                  color: SColorsLight().grey1,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
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
              if (!removeDivider) ...[
                const Spacer(),
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
