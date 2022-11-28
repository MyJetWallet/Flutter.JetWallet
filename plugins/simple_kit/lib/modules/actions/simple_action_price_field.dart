import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SActionPriceField extends StatelessWidget {
  const SActionPriceField({
    Key? key,
    required this.price,
    required this.helper,
    required this.error,
    required this.isErrorActive,
    required this.widgetSize,
  }) : super(key: key);

  final String price;
  final String helper;
  final String error;
  final bool isErrorActive;
  final SWidgetSize widgetSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widgetSize == SWidgetSize.small ? 116 : null,
      child: Column(
        children: [
          SPaddingH24(
            child: Baseline(
              baseline: widgetSize == SWidgetSize.small ? 32 : 22,
              baselineType: TextBaseline.alphabetic,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  price,
                  maxLines: 1,
                  style: sTextH1Style.copyWith(
                    color: isErrorActive
                        ? SColorsLight().red
                        : SColorsLight().black,
                  ),
                ),
              ),
            ),
          ),
          SPaddingH24(
            child: Baseline(
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
          ),
        ],
      ),
    );
  }
}
