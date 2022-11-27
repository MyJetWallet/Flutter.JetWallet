import 'package:flutter/material.dart';

class SPaddingH24 extends StatelessWidget {
  const SPaddingH24({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ),
      child: child,
    );
  }
}
