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
    if (sentiment == Colors.green) {
      return const SSmileGoodIcon();
    }
    if (sentiment == Colors.yellow) {
      return const SSmileNeutralIcon();
    } else {
      return const SSmileBadIcon();
    }
  }
}
