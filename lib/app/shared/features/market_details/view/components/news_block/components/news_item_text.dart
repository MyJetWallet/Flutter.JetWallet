import 'package:flutter/material.dart';

class NewsItemText extends StatelessWidget {
  const NewsItemText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.grey,
      ),
    );
  }
}
