import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

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
