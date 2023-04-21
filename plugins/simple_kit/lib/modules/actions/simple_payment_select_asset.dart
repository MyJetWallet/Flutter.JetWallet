import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SPaymentSelectAsset extends StatelessWidget {
  const SPaymentSelectAsset({
    Key? key,
    this.onTap,
    this.helper = '',
    this.amount = '',
    required this.icon,
    required this.name,
    this.description,
    required this.widgetSize,
  }) : super(key: key);

  final Function()? onTap;
  final String helper;
  final String amount;
  final Widget icon;
  final String name;
  final String? description;
  final SWidgetSize widgetSize;

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
              if (widgetSize == SWidgetSize.small) const SpaceH12(),
              // + 1 px border
              if (widgetSize == SWidgetSize.medium) const SpaceH23(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceW19(), // 1 px border
                  icon,
                  const SpaceW10(),
                  Expanded(
                    child: Column(
                      children: [
                        Baseline(
                          baseline:
                              widgetSize == SWidgetSize.small ? 17.0 : 18.0,
                          baselineType: TextBaseline.alphabetic,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: sSubtitle2Style,
                                ),
                              ),
                              const SpaceW16(),
                              if (amount.isNotEmpty)
                                SizedBox(
                                  width: 110.0,
                                  child: Text(
                                    amount,
                                    textAlign: TextAlign.end,
                                    style: sSubtitle2Style,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (description != null || helper.isNotEmpty) ...[
                          Baseline(
                            baseline: 14.0,
                            baselineType: TextBaseline.alphabetic,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (description != null) ...[
                                  Expanded(
                                    child: Text(
                                      description!,
                                      style: sCaptionTextStyle.copyWith(
                                        color: SColorsLight().grey3,
                                      ),
                                    ),
                                  ),
                                  const SpaceW16(),
                                ],
                                if (helper.isNotEmpty) ...[
                                  SizedBox(
                                    width: 110.0,
                                    child: Text(
                                      helper,
                                      textAlign: TextAlign.end,
                                      style: sCaptionTextStyle.copyWith(
                                        color: SColorsLight().grey3,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SpaceW19(), // 1 px border
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
