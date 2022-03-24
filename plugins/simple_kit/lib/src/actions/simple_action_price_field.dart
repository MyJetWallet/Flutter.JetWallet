import 'package:flutter/material.dart';

import '../../simple_kit.dart';
import '../colors/view/simple_colors_light.dart';

class SActionPriceField extends StatelessWidget {
  const SActionPriceField({
    Key? key,
    required this.price,
    required this.helper,
    required this.error,
    required this.isErrorActive,
    required this.widgetType,
  }) : super(key: key);

  final String price;
  final String helper;
  final String error;
  final bool isErrorActive;
  final SWidgetType widgetType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widgetType == SWidgetType.small ? 116 : 152,
      child: Column(
        children: [
          Baseline(
            baseline: widgetType == SWidgetType.small ? 32 : 60,
            baselineType: TextBaseline.alphabetic,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                price,
                maxLines: 1,
                style: sTextH1Style.copyWith(
                  color:
                      isErrorActive ? SColorsLight().red : SColorsLight().black,
                ),
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
