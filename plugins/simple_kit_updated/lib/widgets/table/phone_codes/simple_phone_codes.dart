import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SPhoneCodes extends StatelessWidget {
  const SPhoneCodes({
    super.key,
    required this.iconFlag,
    this.code,
    required this.country,
    required this.onTap,
  });

  final Widget iconFlag;
  final String? code;
  final String country;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return SafeGesture(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          children: [
            iconFlag,
            if (code != null) ...[
              const SizedBox(width: 12),
              Text(
                code ?? '',
                style: STStyles.subtitle1.copyWith(
                  color: colors.gray6,
                ),
              ),
            ],
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                country,
                style: STStyles.subtitle1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
