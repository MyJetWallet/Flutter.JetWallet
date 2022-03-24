import 'package:flutter/material.dart';

import '../../simple_kit.dart';
import '../colors/view/simple_colors_light.dart';

class SPaymentSelectDefault extends StatelessWidget {
  const SPaymentSelectDefault({
    Key? key,
    required this.icon,
    required this.name,
    required this.widgetType,
    required this.onTap,
  }) : super(key: key);

  final Widget icon;
  final String name;
  final SWidgetType widgetType;
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
          height: widgetType == SWidgetType.small ? 64.0 : 88.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: SColorsLight().grey4,
            ),
          ),
          child: Column(
            children: [
              // + 1 px border
              if (widgetType == SWidgetType.small) const SpaceH19(),
              // + 1 px border
              if (widgetType == SWidgetType.medium) const SpaceH31(),
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
              if (widgetType == SWidgetType.small) const SpaceH17(),
            ],
          ),
        ),
      ),
    );
  }
}
