import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';

class SFieldDividerFrame extends HookWidget {
  const SFieldDividerFrame({
    Key? key,
    required this.child,
  }) : super(key: key);

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
          )
        ],
      ),
    );
  }
}
