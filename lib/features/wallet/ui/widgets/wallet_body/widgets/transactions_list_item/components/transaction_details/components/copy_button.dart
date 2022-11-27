import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyButton extends StatelessWidget {
  const CopyButton({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Clipboard.setData(
          ClipboardData(
            text: text,
          ),
        );
      },
      child: const Icon(
        Icons.copy,
        size: 18.0,
      ),
    );
  }
}
