import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

class ResultScreenTitle extends StatelessWidget {
  const ResultScreenTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 2,
      textAlign: TextAlign.center,
      style: STStyles.header3,
    );
  }
}
