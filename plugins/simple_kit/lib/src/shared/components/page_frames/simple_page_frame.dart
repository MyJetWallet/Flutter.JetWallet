import 'package:flutter/material.dart';

class SPageFrame extends StatelessWidget {
  const SPageFrame({
    Key? key,
    this.header,
    this.color = Colors.transparent,
    required this.child,
  }) : super(key: key);

  final Widget? header;
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (header != null) header!,
          Expanded(
            child: Material(
              color: color,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
