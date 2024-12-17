import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

class CheckTitle<T> extends StatelessWidget {
  const CheckTitle({
    super.key,
    this.onTap,
    required this.radioValue,
    required this.radiogroupValue,
    required this.title,
    this.description,
    this.rightValue,
    this.badge,
  });

  final void Function()? onTap;
  final T radioValue;
  final T radiogroupValue;
  final String title;
  final String? description;
  final String? rightValue;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        bottom: 16,
        left: 8,
        right: 24,
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.translate(
              offset: const Offset(0, -10),
              child: Transform.scale(
                scale: 1.2,
                child: Radio(
                  value: radioValue,
                  groupValue: radiogroupValue,
                  onChanged: (_) {
                    onTap?.call();
                  },
                  activeColor: colors.black,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: STStyles.subtitle1,
                  ),
                  if (description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        description!,
                        style: STStyles.body2Medium.copyWith(color: colors.gray10),
                        maxLines: 5,
                      ),
                    ),
                  badge ?? const Offstage(),
                ],
              ),
            ),
            if (rightValue != null)
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  rightValue ?? '',
                  style: STStyles.subtitle1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
