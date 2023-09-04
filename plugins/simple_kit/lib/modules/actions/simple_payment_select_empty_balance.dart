import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SPaymentSelectEmptyBalance extends StatelessWidget {
  const SPaymentSelectEmptyBalance({
    Key? key,
    required this.text,
    this.secondaryText,
    required this.widgetSize,
  }) : super(key: key);

  final String text;
  final String? secondaryText;
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
            if (widgetSize == SWidgetSize.small) ...[
              if (secondaryText != null) const SpaceH7() else const SpaceH19(),
            ],
            // + 1px border
            if (widgetSize == SWidgetSize.medium) ...[
              if (secondaryText != null) const SpaceH19() else const SpaceH31(),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const SErrorIcon(),
                const SpaceW10(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Baseline(
                      baseline: 18.0,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        text,
                        style: sSubtitle2Style,
                      ),
                    ),
                    if (secondaryText != null) ...[
                      Baseline(
                        baseline: 18.0,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          secondaryText!,
                          style: sSubtitle2Style,
                        ),
                      ),
                    ],
                  ],
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
