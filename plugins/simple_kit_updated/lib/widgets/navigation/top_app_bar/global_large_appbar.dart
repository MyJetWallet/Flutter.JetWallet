import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/shared/safe_gesture.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

class SimpleLargeAppbar extends StatelessWidget {
  const SimpleLargeAppbar({
    super.key,
    required this.title,
    this.titleMaxLines,
    this.hasLeftIcon = true,
    this.leftIcon,
    this.hasRightIcon = false,
    this.rightIcon,
    this.hasSubicon1 = false,
    this.subicon1,
    this.hasSubicon2 = false,
    this.subicon2,
    this.onLeftIconTap,
    this.onRightIconTap,
  });

  final String title;
  final int? titleMaxLines;

  final bool hasLeftIcon;
  final Widget? leftIcon;
  final VoidCallback? onLeftIconTap;

  final bool hasRightIcon;
  final Widget? rightIcon;
  final VoidCallback? onRightIconTap;

  final bool hasSubicon1;
  final Widget? subicon1;

  final bool hasSubicon2;
  final Widget? subicon2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top <= 24 ? 16 : 0), //отступ шторки
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            children: [
              SizedBox(
                height: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                      opacity: hasLeftIcon ? 1 : 0,
                      child: leftIcon ??
                          SafeGesture(
                            onTap: () => onLeftIconTap ?? Navigator.of(context).pop(),
                            child: Assets.svg.medium.arrowLeft.simpleSvg(),
                          ),
                    ),
                    Opacity(
                      opacity: hasRightIcon ? 1 : 0,
                      child: rightIcon ??
                          SafeGesture(
                            onTap: () => onRightIconTap ?? Navigator.of(context).pop(),
                            child: Assets.svg.medium.close.simpleSvg(),
                          ),
                    ),
                  ],
                ),
              ),
              const Gap(16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: STStyles.header4.copyWith(
                        color: SColorsLight().black,
                      ),
                      maxLines: titleMaxLines,
                    ),
                  ),
                  if (hasSubicon1 || hasSubicon2) const Gap(40),
                  if (hasSubicon1)
                    Opacity(
                      opacity: hasSubicon1 ? 1 : 0,
                      child: subicon1 ?? Assets.svg.medium.share.simpleSvg(),
                    ),
                  if (hasSubicon2) ...[
                    const Gap(24),
                    Opacity(
                      opacity: hasSubicon2 ? 1 : 0,
                      child: subicon2 ?? Assets.svg.medium.user.simpleSvg(),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
