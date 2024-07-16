import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/shared/safe_gesture.dart';
import 'package:simple_kit_updated/widgets/shared/simple_skeleton_loader.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

class SimpleLargeAltAppbar extends StatelessWidget {
  const SimpleLargeAltAppbar({
    super.key,
    required this.title,
    this.value,
    this.hasSecondIcon = false,
    this.secondIcon,
    this.hasRightIcon = true,
    this.rightIcon,
    required this.showLabelIcon,
    this.labelIcon,
    this.onLabelIconTap,
    this.isLoading = false,
    this.hasLeftIcon = false,
    this.leftIcon,
  });

  final String title;

  final String? value;

  final bool showLabelIcon;
  final Widget? labelIcon;
  final VoidCallback? onLabelIconTap;

  final bool hasSecondIcon;
  final Widget? secondIcon;

  final bool hasLeftIcon;
  final Widget? leftIcon;

  final bool hasRightIcon;
  final Widget? rightIcon;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 53 + 8, //отступ шторки (53) + отступ аппбара (8)
        bottom: 10,
        left: 24,
        right: 24,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasLeftIcon) ...[
                leftIcon ?? Assets.svg.medium.user.simpleSvg(),
              ],
              const Spacer(),
              if (hasSecondIcon) ...[
                const Gap(24),
                secondIcon ?? Assets.svg.medium.user.simpleSvg(),
              ],
              if (hasRightIcon) ...[
                const Gap(24),
                Padding(
                  padding: const EdgeInsets.only(top: 5.5),
                  child: rightIcon ?? Assets.svg.medium.user.simpleSvg(),
                ),
              ]
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: STStyles.header5.copyWith(
                          color: SColorsLight().black,
                        ),
                      ),
                      if (showLabelIcon) ...[
                        const Gap(8),
                        SafeGesture(
                          onTap: hasRightIcon
                              ? onLabelIconTap != null
                                  ? () => onLabelIconTap!()
                                  : null
                              : null,
                          child: labelIcon ?? Assets.svg.medium.show.simpleSvg(),
                        ),
                      ],
                    ],
                  ),
                  if (value != null) ...[
                    const Gap(4),
                    isLoading
                        ? SSkeletonLoader(
                            width: 160,
                            height: 40,
                            borderRadius: BorderRadius.circular(4),
                          )
                        : Text(
                            value ?? '',
                            style: STStyles.header3.copyWith(
                              color: SColorsLight().black,
                            ),
                          ),
                  ] else
                    const Gap(8),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
