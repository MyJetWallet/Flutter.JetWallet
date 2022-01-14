import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/constants.dart';

class EmptySelfieBox extends StatelessWidget {
  const EmptySelfieBox({
    Key? key,
    required this.colors,
  }) : super(key: key);

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
      child: SvgPicture.asset(
        personaAsset,
        color: colors.grey5,
      ),
    );
  }
}
