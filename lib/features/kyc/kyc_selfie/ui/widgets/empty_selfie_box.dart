import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:simple_kit/simple_kit.dart';

class EmptySelfieBox extends StatelessWidget {
  const EmptySelfieBox({
    super.key,
    required this.colors,
  });

  final SColorsLight colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225,
      width: 225,
      padding: const EdgeInsets.only(
        top: 76,
        left: 81,
        right: 80,
        bottom: 77,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: colors.gray4,
      ),
      child: SSelfieIcon(
        color: colors.gray2,
      ),
      // SvgPicture.asset(
      //   personaAsset,
      //   color: colors.gray2,
      // ),
    );
  }
}
