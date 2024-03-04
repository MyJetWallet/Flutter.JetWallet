import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

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
    this.valueMaxLines = 1,
    this.onTab,
  }) : super(key: key);

  final TwoColumnCellType type;

  final String label;
  final String? value;
  final int? valueMaxLines;
  final Widget? rightValueIcon;

  final bool needHorizontalPadding;

  final bool haveInfoIcon;
  final Widget? customRightIcon;
  final void Function()? onTab;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Material(
        color: SColorsLight().white,
        child: SizedBox(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: needHorizontalPadding ? 24 : 0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        style: STStyles.body2Medium.copyWith(color: SColorsLight().gray10),
                      ),
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
                const Gap(10),
                if (type != TwoColumnCellType.loading) ...[
                  if (customRightIcon != null) ...[
                    customRightIcon!,
                    const Gap(8),
                  ],
                  if (value != null) ...[
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              value ?? '',
                              maxLines: valueMaxLines,
                              textAlign: TextAlign.right,
                              style: STStyles.subtitle2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
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
      ),
    );
  }
}
