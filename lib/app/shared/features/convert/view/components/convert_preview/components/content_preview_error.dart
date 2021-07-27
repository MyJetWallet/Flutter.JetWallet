import 'package:flutter/material.dart';

class ConvertPreviewError extends StatelessWidget {
  const ConvertPreviewError({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}
