import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SPaymentSelectCreditCard extends StatelessWidget {
  const SPaymentSelectCreditCard({
    Key? key,
    this.onTap,
    this.helper = '',
    this.amount = '',
    this.isApplePay = false,
    required this.icon,
    required this.name,
    required this.description,
    required this.widgetSize,
    required this.limit,
  }) : super(key: key);

  final bool isApplePay;
  final Function()? onTap;
  final String helper;
  final String amount;
  final Widget icon;
  final String name;
  final String description;
  final SWidgetSize widgetSize;
  final int limit;

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width - 48;
    final width = currentWidth / 100 * limit;

    return SPaddingH24(
      child: InkWell(
        highlightColor: SColorsLight().grey4,
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap,
        child: Container(
          height: widgetSize == SWidgetSize.small ? 64.0 : 88.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: SColorsLight().grey4,
            ),
          ),
          clipBehavior: Clip.hardEdge,
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
                  if (!isApplePay) ...[
                    icon,
                    const SpaceW10(),
                  ] else ...[
                    Image.asset(
                      applePayAsset,
                      width: 48,
                      height: 30.73,
                    ),
                    const SpaceW20(),
                  ],
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
                                  style: sSubtitle2Style.copyWith(
                                    color: limit == 100
                                        ? SColorsLight().grey2
                                        : SColorsLight().black,
                                  ),
                                ),
                              ),
                              const SpaceW16(),
                              if (amount.isNotEmpty)
                                SizedBox(
                                  width: 90.0,
                                  child: Text(
                                    amount,
                                    textAlign: TextAlign.end,
                                    style: sSubtitle2Style.copyWith(
                                      color: limit == 100
                                          ? SColorsLight().grey2
                                          : SColorsLight().black,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Baseline(
                          baseline: 14.0,
                          baselineType: TextBaseline.alphabetic,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: helper.isNotEmpty ? 120.0 : 180.0,
                                child: Text(
                                  description,
                                  style: sCaptionTextStyle.copyWith(
                                    color: SColorsLight().grey3,
                                  ),
                                ),
                              ),
                              const SpaceW16(),
                              Expanded(
                                child: Text(
                                  helper,
                                  textAlign: TextAlign.end,
                                  style: sCaptionTextStyle.copyWith(
                                    color: SColorsLight().grey3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpaceW19(), // 1 px border
                ],
              ),
              const Spacer(),
              Stack(
                children: [
                  Container(
                    width: currentWidth,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      color: SColorsLight().blueLight,
                    ),
                  ),
                  Positioned(
                    child: Container(
                      width: width,
                      height: 4,
                      decoration: BoxDecoration(
                        color: limit == 100
                            ? SColorsLight().red
                            : SColorsLight().blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
