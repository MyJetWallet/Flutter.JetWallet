import 'package:flutter/material.dart';

/// Used to animate background of BottomSheet,
/// can be triggered by [showBasicBottomSheet()]
class SShadeAnimationStack extends StatelessWidget {
  const SShadeAnimationStack({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (controller.value != 0)
          Container(
            /// black54 is default system color for shading
            color: Colors.black54.withOpacity(
              (controller.value * 100).round() * 0.0054,
            ),
          )
      ],
    );
  }
}
