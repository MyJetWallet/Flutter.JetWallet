import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class EmptySelfieBox extends StatelessWidget {
  const EmptySelfieBox({
    super.key,
    required this.colors,
  });

  final SimpleColors colors;

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
        color: colors.grey4,
      ),
      child: SSelfieIcon(
        color: colors.grey5,
      ),
      // SvgPicture.asset(
      //   personaAsset,
      //   color: colors.grey5,
      // ),
    );
  }
}
