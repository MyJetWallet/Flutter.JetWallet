import 'package:flutter/material.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

class BlueBankIcon extends StatelessWidget {
  const BlueBankIcon({
    Key? key,
    this.size = 40.0,
  }) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: SColorsLight().blue,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 16,
        height: 16,
        child: Assets.svg.medium.bank.simpleSvg(color: SColorsLight().white),
      ),
    );
  }
}
