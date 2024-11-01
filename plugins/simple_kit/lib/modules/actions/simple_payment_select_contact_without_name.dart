import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SPaymentSelectContactWithoutName extends StatelessWidget {
  const SPaymentSelectContactWithoutName({
    super.key,
    required this.phone,
    required this.widgetSize,
  });

  final String phone;
  final SWidgetSize widgetSize;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: Container(
        height: widgetSize == SWidgetSize.small ? 64.0 : 88.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: SColorsLight().grey4,
          ),
        ),
        child: Column(
          children: [
            // + 1px border
            if (widgetSize == SWidgetSize.small) const SpaceH19(),
            // + 1px border
            if (widgetSize == SWidgetSize.medium) const SpaceH31(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceW19(), // + 1px border
                SPhoneIcon(
                  color: SColorsLight().black,
                ),
                const SpaceW10(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Baseline(
                        baseline: 18.0,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          phone,
                          style: sSubtitle2Style,
                        ),
                      ),
                    ],
                  ),
                ),
                const SpaceW19(), // + 1px border
              ],
            ),
          ],
        ),
      ),
    );
  }
}
