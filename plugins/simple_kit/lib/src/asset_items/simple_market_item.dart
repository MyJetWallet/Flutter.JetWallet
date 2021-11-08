import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';

/// Requires Icon with width target
class SMarketItem extends StatelessWidget {
  const SMarketItem({
    Key? key,
    this.graph,
    required this.icon,
    required this.name,
    required this.price,
    required this.ticker,
    required this.percent,
    required this.onTap,
  }) : super(key: key);

  /// The graph must have the following size 38x14
  final Widget? graph;
  final Widget icon;
  final String name;
  final String price;
  final String ticker;
  final double percent;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: SColorsLight().grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: 88.h,
          child: Column(
            children: [
              const SpaceH22(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  icon,
                  const SpaceW10(),
                  SizedBox(
                    width: 125.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Baseline(
                          baseline: 17.8.h,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            name,
                            style: sSubtitle2Style,
                          ),
                        ),
                        Baseline(
                          baseline: 19.4.h,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            ticker,
                            style: sBodyText2Style.copyWith(
                              color: SColorsLight().grey3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpaceW10(),
                  // TODO change to SizedBox when Grpah will be added
                  Container(
                    color: Colors.red[100]!.withOpacity(0.3),
                    width: 38.w,
                    height: 30.h,
                    child: graph,
                  ),
                  const SpaceW10(),
                  SizedBox(
                    width: 110.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Baseline(
                          baseline: 17.8.h,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            price,
                            style: sSubtitle2Style,
                          ),
                        ),
                        Baseline(
                          baseline: 19.4.h,
                          baselineType: TextBaseline.alphabetic,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 94.w,
                                child: Text(
                                  '$percent%',
                                  textAlign: TextAlign.end,
                                  style: sBodyText2Style.copyWith(
                                    color: SColorsLight().grey3,
                                  ),
                                ),
                              ),
                              if (percent.isNegative)
                                const SSmallArrowNegativeIcon()
                              else
                                const SSmallArrowPositiveIcon()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SDivider(
                width: 327.w,
              )
            ],
          ),
        ),
      ),
    );
  }
}
