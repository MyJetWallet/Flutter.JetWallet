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
  });

  final String title;

  final String? value;

  final bool showLabelIcon;
  final Widget? labelIcon;
  final VoidCallback? onLabelIconTap;

  final bool hasSecondIcon;
  final Widget? secondIcon;

  final bool hasRightIcon;
  final Widget? rightIcon;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 53),
      child: SizedBox(
        height: 96,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 32,
                          child: Row(
                            children: [
                              Text(
                                title,
                                style: STStyles.header5.copyWith(
                                  color: SColorsLight().black,
                                ),
                              ),
                              const Gap(8),
                              Opacity(
                                opacity: showLabelIcon ? 1 : 0,
                                child: SafeGesture(
                                  onTap: hasRightIcon
                                      ? onLabelIconTap != null
                                          ? () => onLabelIconTap!()
                                          : null
                                      : null,
                                  child: labelIcon ?? Assets.svg.medium.show.simpleSvg(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(4),
                        if (isLoading)
                          SSkeletonLoader(
                            width: 160,
                            height: 40,
                            borderRadius: BorderRadius.circular(4),
                          )
                        else
                          Opacity(
                            opacity: value != null ? 1 : 0,
                            child: Text(
                              value ?? '',
                              style: STStyles.header3.copyWith(
                                color: SColorsLight().black,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Gap(24),
                  if (hasSecondIcon) ...[
                    secondIcon ?? Assets.svg.medium.user.simpleSvg(),
                    const Gap(24),
                  ],
                ],
              ),
            ),
            Positioned(
              right: 18,
              top: 3,
              child: Opacity(
                opacity: hasRightIcon ? 1 : 0,
                child: rightIcon ?? Assets.svg.medium.user.simpleSvg(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
