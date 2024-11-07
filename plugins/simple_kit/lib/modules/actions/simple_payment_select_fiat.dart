import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SPaymentSelectFiat extends StatelessWidget {
  const SPaymentSelectFiat({
    super.key,
    required this.icon,
    required this.name,
    required this.amount,
    required this.widgetSize,
    required this.onTap,
  });

  final Widget icon;
  final String name;
  final String amount;
  final SWidgetSize widgetSize;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: InkWell(
        highlightColor: SColorsLight().grey4,
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap,
        child: Ink(
          height: widgetSize == SWidgetSize.small ? 64.0 : 88.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: SColorsLight().grey4,
            ),
          ),
          child: Column(
            children: [
              if (widgetSize == SWidgetSize.small) const SpaceH19(), // + 1px border
              if (widgetSize == SWidgetSize.medium) const SpaceH31(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceW19(), // + 1px border
                  icon,
                  const SpaceW10(),
                  Expanded(
                    child: Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Expanded(
                          child: Baseline(
                            baseline: 18.0,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              name,
                              style: sSubtitle2Style,
                            ),
                          ),
                        ),
                        const SpaceW16(),
                        Baseline(
                          baseline: 18.0,
                          baselineType: TextBaseline.alphabetic,
                          child: SizedBox(
                            width: 110.0,
                            child: Text(
                              amount,
                              textAlign: TextAlign.end,
                              style: sSubtitle2Style,
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
      ),
    );
  }
}
