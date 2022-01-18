import 'package:flutter/material.dart';

import '../../simple_kit.dart';

class SFloatingButtonFrame extends StatelessWidget {
  const SFloatingButtonFrame({
    Key? key,
    required this.button,
  }) : super(key: key);

  final Widget button;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Column(
        children: [
          Container(
            height: 30.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: const [0.1, 1],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.1),
                ],
              ),
            ),
          ),
          Material(
            child: Column(
              children: [
                SPaddingH24(
                  child: button,
                ),
                const SpaceH24(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
