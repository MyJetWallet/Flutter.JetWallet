import 'package:flutter/material.dart';
import 'package:jetwallet/utils/constants.dart';

/// Gradient for Onboarding/Spalsh screens
class PortfolioScreenGradient extends StatelessWidget {
  const PortfolioScreenGradient({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: Container(
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(portfolioGradientBG),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}
