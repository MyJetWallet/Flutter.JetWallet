import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SNewActionPriceField extends StatelessWidget {
  const SNewActionPriceField({
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SPaddingH24(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '100',
                  style: sTextH0Style.copyWith(
                    color: isErrorActive ? SColorsLight().red : SColorsLight().black,
                    height: 0.8,
                  ),
                ),
                const SpaceW8(),
                const Text(
                  'USDT',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    
                  ),
                ),
              ],
            ),
          ),
          const SpaceH4(),
          SPaddingH24(
            child: Baseline(
              baseline: 13,
              baselineType: TextBaseline.alphabetic,
              child: AutoSizeText(
                isErrorActive ? error : helper,
                textAlign: TextAlign.center,
                minFontSize: 4.0,
                maxLines: 1,
                strutStyle: const StrutStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                  fontFamily: 'Gilroy',
                ),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                  fontFamily: 'Gilroy',
                  color: isErrorActive ? SColorsLight().red : SColorsLight().grey1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
