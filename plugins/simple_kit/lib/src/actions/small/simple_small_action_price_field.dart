import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';

class SSmallActionPriceField extends StatelessWidget {
  const SSmallActionPriceField({
    Key? key,
    required this.price,
    required this.helper,
    required this.error,
    required this.isErrorActive,
  }) : super(key: key);

  final String price;
  final String helper;
  final String error;
  final bool isErrorActive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116,
      child: Column(
        children: [
          Baseline(
            baseline: 32,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              price,
              maxLines: 1,
              style: sTextH1Style.copyWith(
                color:
                    isErrorActive ? SColorsLight().red : SColorsLight().black,
              ),
            ),
          ),
          Baseline(
            baseline: 13,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              isErrorActive ? error : helper,
              maxLines: 1,
              style: sSubtitle3Style.copyWith(
                color:
                    isErrorActive ? SColorsLight().red : SColorsLight().black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
