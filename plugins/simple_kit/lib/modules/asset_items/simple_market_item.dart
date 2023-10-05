import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';

class SMarketItem extends StatelessWidget {
  const SMarketItem({
    Key? key,
    this.last = false,
    this.showFavoriteIcon = false,
    this.isStarActive = false,
    this.onStarButtonTap,
    this.height = 88.0,
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
  final bool showFavoriteIcon;
  final Function()? onStarButtonTap;
  final bool isStarActive;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: SColorsLight().grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: height,
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
                          child: AutoSizeText(
                            name,
                            minFontSize: 4.0,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            strutStyle: const StrutStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              height: 1.56,
                              fontFamily: 'Gilroy',
                            ),
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              height: 1.56,
                              fontFamily: 'Gilroy',
                            ),
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
                            overflow: TextOverflow.ellipsis,
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
                                width: 138,
                                child: Text(
                                  _formatPercent(percent),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: sBodyText2Style.copyWith(
                                    color: percent == 0
                                        ? SColorsLight().grey3
                                        : percent > 0
                                            ? SColorsLight().green
                                            : SColorsLight().red,
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
                  if (showFavoriteIcon) ...[
                    const SpaceW10(),
                    SIconButton(
                      onTap: onStarButtonTap,
                      defaultIcon: isStarActive ? const SStarSelectedIcon() : const SStarIcon(),
                      pressedIcon: const SStarPressedIcon(),
                    ),
                  ],
                ],
              ),
              const Spacer(),
              if (!last)
                const SDivider(
                  width: double.infinity,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _percentIcon(double percent) {
    return percent.compareTo(0) == 0
        ? const SMinusIcon()
        : percent.isNegative
            ? const SSmallArrowNegativeIcon()
            : const SSmallArrowPositiveIcon();
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
