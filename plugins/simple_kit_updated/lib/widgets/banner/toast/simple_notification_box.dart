import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SNotificationBox extends StatelessWidget {
  const SNotificationBox({
    super.key,
    required this.text,
    this.isError = true,
  });

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isError ? SColorsLight().red : SColorsLight().black,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12,
                ),
                child: Text(
                  text,
                  maxLines: 10,
                  style: STStyles.subtitle2.copyWith(
                    color: SColorsLight().white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
