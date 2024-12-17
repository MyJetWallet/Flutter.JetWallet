import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

class SFloatingButtonFrame extends StatelessWidget {
  const SFloatingButtonFrame({
    super.key,
    required this.button,
    this.hidePadding = false,
  });

  final Widget button;
  final bool hidePadding;

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
            color: SColorsLight().white,
            child: Column(
              children: [
                if (hidePadding)
                  button
                else
                  SPaddingH24(
                    child: button,
                  ),
                const SpaceH42(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
