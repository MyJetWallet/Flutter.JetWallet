import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

class ResultScreenDescription extends StatelessWidget {
  const ResultScreenDescription({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 10,
      textAlign: TextAlign.center,
      style: STStyles.body1Medium.copyWith(
        color: SColorsLight().gray10,
      ),
    );
  }
}
