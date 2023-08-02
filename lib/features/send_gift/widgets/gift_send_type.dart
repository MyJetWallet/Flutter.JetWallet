import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/l10n/i10n.dart';
import '../../../core/services/device_size/device_size.dart';
import '../../../utils/helpers/widget_size_from.dart';

class GiftSendType extends StatelessWidget {
  const GiftSendType({super.key});

  @override
  Widget build(BuildContext context) {
    final widgetSize = widgetSizeFrom(sDeviceSize);

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
                Container(
                  width: 32,
                  height: 32,
                  decoration: const ShapeDecoration(
                    color: Color(0xFF374CFA),
                    shape: OvalBorder(),
                  ),
                  padding: const EdgeInsets.all(7),
                  child: SGiftSendIcon(color: SColorsLight().white),
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
                          intl.send_gift_simple_gift,
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
