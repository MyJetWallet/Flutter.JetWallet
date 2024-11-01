import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SPaymentSelectContact extends StatelessWidget {
  const SPaymentSelectContact({
    super.key,
    required this.name,
    required this.phone,
    required this.widgetSize,
  });

  final String name;
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
            if (widgetSize == SWidgetSize.small) const SpaceH12(),
            // + 1px border
            if (widgetSize == SWidgetSize.medium) const SpaceH23(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceW19(), // + 1px border
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: SColorsLight().blue,
                  ),
                  child: Center(
                    child: Baseline(
                      baseline: 16.0,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        initialsFrom(name),
                        style: sSubtitle3Style.copyWith(
                          color: SColorsLight().white,
                        ),
                      ),
                    ),
                  ),
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
                          name,
                          style: sSubtitle2Style,
                        ),
                      ),
                      Baseline(
                        baseline: 14.0,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          phone,
                          style: sCaptionTextStyle.copyWith(
                            color: SColorsLight().grey3,
                          ),
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
