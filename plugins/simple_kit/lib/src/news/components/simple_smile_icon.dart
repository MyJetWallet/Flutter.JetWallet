import 'package:flutter/material.dart';
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
    if (sentiment == SColorsLight().yellowLight) {
      return const SSmileNeutralIcon();
    } else {
      return const SSmileBadIcon();
    }
  }
}
