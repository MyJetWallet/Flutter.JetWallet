import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

class SimpleLargeAltAppbar extends StatelessWidget {
  const SimpleLargeAltAppbar({
    Key? key,
    required this.title,
    this.value,
    required this.show,
    this.hasSecondIcon = false,
    this.secondIcon,
    this.hasRightIcon = true,
    this.rightIcon,
  }) : super(key: key);

  final String title;

  final bool show;

  final String? value;

  final bool hasSecondIcon;
  final Widget? secondIcon;

  final bool hasRightIcon;
  final Widget? rightIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 53),
      child: SizedBox(
        height: 96,
        child: Padding(
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
                            opacity: show ? 1 : 0,
                            child: Assets.svg.medium.hide.simpleSvg(),
                          ),
                        ],
                      ),
                    ),
                    const Gap(4),
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
              Opacity(
                opacity: hasRightIcon ? 1 : 0,
                child: rightIcon ?? Assets.svg.medium.user.simpleSvg(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
