import 'package:flutter/material.dart';

import '../colors/view/simple_colors_light.dart';
import '../icons/16x16/public/minus/simple_minus_icon.dart';
import '../icons/16x16/public/small_arrow/simple_small_arrow_negative_icon.dart';
import '../icons/16x16/public/small_arrow/simple_small_arrow_positive_icon.dart';
import '../shared/components/simple_divider.dart';
import '../shared/components/simple_paddings.dart';
import '../shared/components/simple_spacers.dart';
import '../texts/simple_text_styles.dart';

class SMarketItem extends StatelessWidget {
  const SMarketItem({
    Key? key,
    this.last = false,
    required this.icon,
    required this.name,
    required this.price,
    required this.ticker,
    required this.percent,
    required this.onTap,
  }) : super(key: key);

  final Widget icon;
  final String name;
  final String price;
  final String ticker;
  final bool last;
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
          height: 88.0,
          child: Column(
            children: [
              const SpaceH22(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  icon,
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
                          baseline: 18.0,
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
                  SizedBox(
                    width: 158.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Baseline(
                          baseline: 18.0,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            price,
                            style: sSubtitle2Style,
                          ),
                        ),
                        Baseline(
                          baseline: 18.0,
                          baselineType: TextBaseline.alphabetic,
                          child: Row(
                            textBaseline: TextBaseline.alphabetic,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 142,
                                child: Text(
                                  _formatPercent(percent),
                                  textAlign: TextAlign.end,
                                  style: sBodyText2Style.copyWith(
                                    color: SColorsLight().grey3,
                                  ),
                                ),
                              ),
                              Baseline(
                                baseline: 20.0,
                                baselineType: TextBaseline.alphabetic,
                                child: _percentIcon(percent),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (!last)
                const SDivider(
                  width: double.infinity,
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _percentIcon(double percent) {
    if (percent.compareTo(0) == 0) {
      return const SMinusIcon();
    } else {
      if (percent.isNegative) {
        return const SSmallArrowNegativeIcon();
      } else {
        return const SSmallArrowPositiveIcon();
      }
    }
  }

  String _formatPercent(double percent) {
    if (percent.compareTo(0) == 0) {
      return '0.0%';
    } else if (percent.isNegative) {
      return '$percent%';
    } else {
      return '+$percent%';
    }
  }
}
