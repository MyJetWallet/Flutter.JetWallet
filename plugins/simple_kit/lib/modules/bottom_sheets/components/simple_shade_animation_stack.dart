import 'package:flutter/material.dart';

/// Used to animate background of BottomSheet,
/// can be triggered by [showBasicBottomSheet()]
@Deprecated('This is a widget from the old ui kit, please use the widget from the new ui kit')
class SShadeAnimationStack extends StatelessWidget {
  const SShadeAnimationStack({
    super.key,
    required this.child,
    //required this.controller,
    required this.showShade,
  });

  final Widget child;
  //final AnimationController controller;
  final bool showShade;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (showShade)
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: showShade ? 1.0 : 0.0,
            child: Container(
              color: Colors.black54,
            ),
          ),
        /*
        if (showShade)
          Container(
            /// black54 is default system color for shading
            //color: Colors.black54.withOpacity(
            //  (100 * 100).round() * 0.0054,
            //),
            color: Colors.black54,
          ),
        */
      ],
    );
  }
}
