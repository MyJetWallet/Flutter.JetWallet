import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../simple_kit.dart';

class SFieldDividerFrame extends StatelessWidget {
  const SFieldDividerFrame({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SColorsLight().white,
      child: Stack(
        children: [
          SPaddingH24(
            child: child,
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SDivider(),
          ),
        ],
      ),
    );
  }
}
