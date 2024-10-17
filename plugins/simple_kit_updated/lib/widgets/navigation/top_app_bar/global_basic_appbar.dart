import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/shared/safe_gesture.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

class GlobalBasicAppBar extends StatelessWidget {
  const GlobalBasicAppBar({
    super.key,
    this.hasTitle = true,
    this.title,
    this.hasSubtitle = true,
    this.subtitle,
    this.subtitleTextColor,
    this.hasLeftIcon = true,
    this.leftIcon,
    this.hasRightIcon = true,
    this.rightIcon,
    this.onRightIconTap,
    this.onLeftIconTap,
    this.hasSecondIcon = false,
    this.secondIcon,
  });

  final bool hasTitle;
  final String? title;

  final bool hasSubtitle;
  final String? subtitle;
  final Color? subtitleTextColor;

  final bool hasLeftIcon;
  final Widget? leftIcon;

  final bool hasSecondIcon;
  final Widget? secondIcon;

  final bool hasRightIcon;
  final Widget? rightIcon;
  final VoidCallback? onRightIconTap;
  final VoidCallback? onLeftIconTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 53),
      child: SizedBox(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Opacity(
                            opacity: hasLeftIcon ? 1 : 0,
                            child: SafeGesture(
                              onTap: hasLeftIcon
                                  ? () {
                                      if (onLeftIconTap != null) {
                                        onLeftIconTap?.call();
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    }
                                  : null,
                              child: leftIcon ?? Assets.svg.medium.arrowLeft.simpleSvg(),
                            ),
                          ),
                          const Gap(24),
                          if (hasSecondIcon) const Gap(24),
                        ],
                      ),
                      Flexible(
                        child: Opacity(
                          opacity: hasTitle ? 1 : 0,
                          child: Text(
                            title ?? '',
                            style: STStyles.header6,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          if (hasSecondIcon)
                            Opacity(
                              opacity: hasSecondIcon ? 1 : 0,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: secondIcon ?? Assets.svg.medium.user.simpleSvg(),
                              ),
                            ),
                          const Gap(24),
                          Opacity(
                            opacity: hasRightIcon ? 1 : 0,
                            child: SafeGesture(
                              onTap: hasRightIcon
                                  ? onRightIconTap != null
                                      ? () => onRightIconTap!()
                                      : null
                                  : null,
                              child: rightIcon ?? Assets.svg.medium.close.simpleSvg(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Opacity(
                    opacity: hasSubtitle ? 1 : 0,
                    child: Text(
                      subtitle ?? '',
                      style: STStyles.body2Medium.copyWith(
                        color: subtitleTextColor ?? SColorsLight().gray10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
