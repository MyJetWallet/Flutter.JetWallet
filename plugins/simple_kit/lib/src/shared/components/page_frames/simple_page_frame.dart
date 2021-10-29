import 'package:flutter/material.dart';

class SPageFrame extends StatelessWidget {
  const SPageFrame({
    Key? key,
    this.header,
    required this.child,
  }) : super(key: key);

  final Widget? header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (header != null) header!,
          child,
        ],
      ),
    );
  }
}
