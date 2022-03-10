import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SFieldDividerFrame extends StatelessWidget {
  const SFieldDividerFrame({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SPaddingH24(
          child: child,
        ),
        const Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SDivider(),
        )
      ],
    );
  }
}
