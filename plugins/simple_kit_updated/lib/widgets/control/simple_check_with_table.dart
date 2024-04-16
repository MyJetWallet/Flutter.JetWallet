import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SCheckBoxItemWithTable<T> extends StatelessWidget {
  const SCheckBoxItemWithTable({
    super.key,
    required this.title,
    this.rows = const [],
    required this.radioValue,
    required this.radioGroupValue,
    this.onRadioTap,
    this.badge,
  });

  final String title;
  // in [customValueStyle] pass null if you don't need it
  final List<({String lable, String value, TextStyle? customValueStyle})> rows;
  final T radioValue;
  final T radioGroupValue;
  final void Function(T?)? onRadioTap;
  final SBadgeMedium? badge;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return SafeGesture(
      onTap: () {
        onRadioTap?.call(radioValue);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Radio(
                visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: radioValue,
                groupValue: radioGroupValue,
                onChanged: onRadioTap,
                activeColor: colors.black,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: STStyles.subtitle1,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 4),
                  ...List.generate(rows.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: TwoColumnCell(
                        needHorizontalPadding: false,
                        needVerticalPadding: false,
                        label: rows[index].lable,
                        value: rows[index].value,
                        customValueStyle: rows[index].customValueStyle,
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                  badge ?? const Offstage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
