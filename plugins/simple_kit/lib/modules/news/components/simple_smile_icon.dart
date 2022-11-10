import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../simple_kit.dart';

class SSmileIcon extends StatelessWidget {
  const SSmileIcon({
    Key? key,
    required this.sentiment,
  }) : super(key: key);

  final Color sentiment;

  @override
  Widget build(BuildContext context) {
    if (sentiment == SColorsLight().green) {
      return const SSmileGoodIcon();
    }

    return sentiment == SColorsLight().yellowLight
        ? const SSmileNeutralIcon()
        : const SSmileBadIcon();
  }
}
