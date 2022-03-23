import 'package:flutter/material.dart';

import '../../simple_kit.dart';
import '../colors/view/simple_colors_light.dart';

class SPaymentSelectAsset extends StatelessWidget {
  const SPaymentSelectAsset({
    Key? key,
    this.onTap,
    this.helper = '',
    this.amount = '',
    this.isCreditCard = false,
    required this.icon,
    required this.name,
    required this.description,
    this.needOverflowVisible = false,
  }) : super(key: key);

  final Function()? onTap;
  final String helper;
  final String amount;
  final bool isCreditCard;
  final Widget icon;
  final String name;
  final String description;
  final bool needOverflowVisible;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: InkWell(
        highlightColor: SColorsLight().grey4,
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap,
        child: Ink(
          height: 88.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: SColorsLight().grey4,
            ),
          ),
          child: Column(
            children: [
              const SpaceH23(), // + 1 px border
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
                          baseline: 18.0,
                          baselineType: TextBaseline.alphabetic,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  overflow: needOverflowVisible
                                      ? TextOverflow.visible
                                      : TextOverflow.ellipsis,
                                  style: sSubtitle2Style,
                                ),
                              ),
                              const SpaceW16(),
                              if (amount.isNotEmpty)
                                SizedBox(
                                  width: isCreditCard ? 90.0 : 110.0,
                                  child: Text(
                                    amount,
                                    textAlign: TextAlign.end,
                                    style: sSubtitle2Style,
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
                              Expanded(
                                child: Text(
                                  description,
                                  style: sCaptionTextStyle.copyWith(
                                    color: SColorsLight().grey3,
                                  ),
                                ),
                              ),
                              const SpaceW16(),
                              SizedBox(
                                width: isCreditCard ? 90.0 : 110.0,
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
            ],
          ),
        ),
      ),
    );
  }
}
