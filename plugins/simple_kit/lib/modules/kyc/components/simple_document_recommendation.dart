import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../simple_kit.dart';

class SDocumentRecommendation extends StatelessWidget {
  const SDocumentRecommendation({
    Key? key,
    this.primaryTextColor,
    required this.primaryText,
  }) : super(key: key);

  final Color? primaryTextColor;
  final String primaryText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (primaryTextColor != null)
          Container(
            height: 3,
            width: 6,
            margin: const EdgeInsets.only(right: 10.0),
            color: SColorsLight().grey1,
          ),
        SizedBox(
          height: 30,
          child: Text(
            primaryText,
            textAlign: TextAlign.center,
            style: sBodyText1Style.copyWith(
              color: primaryTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
