import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SPaymentSelectDefault extends StatelessWidget {
  const SPaymentSelectDefault({
    super.key,
    required this.icon,
    required this.name,
    required this.widgetSize,
    required this.onTap,
  });

  final Widget icon;
  final String name;
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
              // + 1 px border
              if (widgetSize == SWidgetSize.small) const SpaceH19(),
              // + 1 px border
              if (widgetSize == SWidgetSize.medium) const SpaceH31(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceW19(), // + 1 px border
                  icon,
                  const SpaceW10(),
                  Flexible(
                    child: Baseline(
                      baseline: 18.0,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        name,
                        style: sSubtitle2Style,
                      ),
                    ),
                  ),
                  const SpaceW19(), // + 1 px border
                ],
              ),
              // + 1 px border
              if (widgetSize == SWidgetSize.small) const SpaceH17(),
            ],
          ),
        ),
      ),
    );
  }
}
