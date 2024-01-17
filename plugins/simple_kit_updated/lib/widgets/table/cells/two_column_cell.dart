import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

enum TwoColumnCellType { def, loading }

class TwoColumnCell extends StatelessWidget {
  const TwoColumnCell({
    Key? key,
    required this.label,
    this.type = TwoColumnCellType.def,
    this.value,
    this.rightValueIcon,
    this.needHorizontalPadding = true,
    this.haveInfoIcon = false,
    this.customRightIcon,
  }) : super(key: key);

  final TwoColumnCellType type;

  final String label;
  final String? value;
  final Widget? rightValueIcon;

  final bool needHorizontalPadding;

  final bool haveInfoIcon;
  final Widget? customRightIcon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SColorsLight().white,
      child: SizedBox(
        height: 40,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: needHorizontalPadding ? 24 : 0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .3,
                ),
                child: Row(
                  children: [
                    Text(
                      label,
                      style: STStyles.body2Medium.copyWith(color: SColorsLight().gray10),
                    ),
                    if (haveInfoIcon) ...[
                      const Gap(4),
                      Assets.svg.small.info.simpleSvg(
                        width: 16,
                        height: 16,
                        color: SColorsLight().gray10,
                      ),
                    ],
                  ],
                ),
              ),
              const Gap(10),
              const Spacer(),
              if (type != TwoColumnCellType.loading) ...[
                if (customRightIcon != null) ...[
                  customRightIcon!,
                  const Gap(8),
                ],
                if (value != null) ...[
                  Text(
                    value ?? '',
                    maxLines: 2,
                    textAlign: TextAlign.right,
                    style: STStyles.subtitle2,
                  ),
                ],
              ] else ...[
                Container(
                  width: 120,
                  height: 24,
                  decoration: BoxDecoration(
                    color: SColorsLight().gray4,
                    borderRadius: BorderRadius.circular(4),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
