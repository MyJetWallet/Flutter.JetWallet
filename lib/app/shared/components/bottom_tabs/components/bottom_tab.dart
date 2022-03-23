import 'package:flutter/material.dart';

class BottomTab extends StatelessWidget {
  const BottomTab({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        right: 10,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(24),
        ),
        border: Border.all(
          width: 1,
        ),
      ),
      child: Text(text),
    );
  }
}
