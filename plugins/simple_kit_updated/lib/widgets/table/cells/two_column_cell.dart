import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

enum TwoColumnCellType { def, loading }

class TwoColumnCell extends StatelessWidget {
  const TwoColumnCell({
    super.key,
    required this.label,
    this.type = TwoColumnCellType.def,
    this.value,
    this.leftValueIcon,
    this.rightValueIcon,
    this.needHorizontalPadding = true,
    this.needVerticalPadding = true,
    this.haveInfoIcon = false,
    this.customRightIcon,
    this.valueMaxLines = 1,
    this.onTab,
    this.customValueStyle,
  });

  final TwoColumnCellType type;

  final String label;
  final String? value;
  final int? valueMaxLines;
  final Widget? leftValueIcon;
  final TextStyle? customValueStyle;
  final Widget? rightValueIcon;

  final bool needHorizontalPadding;
  final bool needVerticalPadding;

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
            padding: EdgeInsets.symmetric(
              horizontal: needHorizontalPadding ? 24 : 0,
              vertical: needVerticalPadding ? 8 : 1,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width * 0.272,
                  ),
                  child: Row(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (leftValueIcon != null) ...[
                            leftValueIcon ?? const SizedBox(),
                            const Gap(8),
                          ],
                          Flexible(
                            child: Text(
                              value ?? '',
                              maxLines: valueMaxLines,
                              textAlign: TextAlign.right,
                              style: customValueStyle ?? STStyles.subtitle2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (rightValueIcon != null) ...[
                            const Gap(8),
                            rightValueIcon ?? const SizedBox(),
                          ],
                        ],
                      ),
                    ),
                  ],
                ] else ...[
                  SSkeletonLoader(
                    width: 120,
                    height: 24,
                    borderRadius: BorderRadius.circular(4),
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
