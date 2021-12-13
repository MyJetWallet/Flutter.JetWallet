import 'package:flutter/material.dart';

class PaddingL24 extends StatelessWidget {
  const PaddingL24({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
      ),
      child: child,
    );
  }
}
