import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SPriceHeader extends StatelessWidget {
  const SPriceHeader({
    this.lable,
    this.value,
    this.baseValue,
    super.key,
    this.icon,
  });

  final String? lable;
  final String? value;
  final String? baseValue;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lable != null)
            Text(
              lable ?? '',
              style: STStyles.subtitle1.copyWith(
                color: colors.black,
              ),
            ),
          if (value != null)
            Row(
              children: [
                if (icon != null) ...[
                  icon ?? const SizedBox(),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: SizedBox(
                    child: AutoSizeText(
                      value ?? '',
                      style: STStyles.header2.copyWith(
                        color: colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          if (baseValue != null)
            Text(
              baseValue ?? '',
              style: STStyles.body2Medium.copyWith(
                color: colors.gray10,
              ),
            ),
        ],
      ),
    );
  }
}
