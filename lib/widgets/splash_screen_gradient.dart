import 'package:flutter/material.dart';
import 'package:jetwallet/utils/gradients.dart';

/// Gradient for Onboarding/Spalsh screens
class OnboardingFullScreenGradient extends StatelessWidget {
  const OnboardingFullScreenGradient({
    super.key,
    this.backgroundColor,
    this.onTapBack,
    this.onTapNext,
    this.onLongPress,
    this.onLongPressEnd,
    this.onPanEnd,
    required this.child,
  });

  final Function()? onTapBack;
  final Function()? onTapNext;
  final Function()? onLongPress;
  final Function(DragEndDetails)? onPanEnd;
  final Function(LongPressEndDetails)? onLongPressEnd;
  final Color? backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      child: Stack(
        children: [
          Container(
            height: size.height,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            decoration: (backgroundColor != null)
                ? BoxDecoration(
                    color: backgroundColor,
                  )
                : const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: onBoardingGradientColors,
                    ),
                  ),
            child: child,
          ),
          Positioned(
            top: 0,
            bottom: 114,
            left: 0,
            right: size.width / 2,
            child: GestureDetector(
              onTap: onTapBack,
              onLongPress: onLongPress,
              onLongPressEnd: onLongPressEnd,
              onPanEnd: onPanEnd,
              child: const ColoredBox(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 114,
            right: 0,
            left: size.width / 2,
            child: GestureDetector(
              onTap: onTapNext,
              onLongPress: onLongPress,
              onLongPressEnd: onLongPressEnd,
              onPanEnd: onPanEnd,
              child: const ColoredBox(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
