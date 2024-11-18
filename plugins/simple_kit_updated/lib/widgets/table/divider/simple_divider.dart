import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

class SDivider extends StatelessWidget {
  const SDivider({
    super.key,
    this.withHorizontalPadding = false,
  });

  final bool withHorizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: SColorsLight().gray4,
      margin: EdgeInsets.symmetric(
        horizontal: withHorizontalPadding ? 24 : 0,
      ),
    );
  }
}
