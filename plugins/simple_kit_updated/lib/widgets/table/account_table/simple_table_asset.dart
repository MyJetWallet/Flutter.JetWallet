import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/button/round/round_button.dart';
import 'package:simple_kit_updated/widgets/shared/safe_gesture.dart';

class SimpleTableAsset extends HookWidget {
  const SimpleTableAsset({
    Key? key,
    this.onTableAssetTap,
    this.isCard = false,
    this.isCardWallet = false,
    this.assetIcon,
    this.needPadding = true,
    required this.label,
    this.supplement,
    this.hasLabelIcon = false,
    this.labelIcon,
    this.hasRightValue = true,
    this.rightValue,
    this.rightMarketValue,
    this.customRightWidget,
    this.isDot = false,
    this.isRightValueMarket = false,
    this.rightValueMarketPositive = true,
    this.isLoading = false,
    this.isHighlated = false,
  }) : super(key: key);

  final VoidCallback? onTableAssetTap;

  final bool isCard;
  final bool isCardWallet;
  final Widget? assetIcon;

  final bool needPadding;

  final String label;
  final String? supplement;

  final bool hasRightValue;
  final String? rightValue;
  final String? rightMarketValue;
  final Widget? customRightWidget;
  final bool isRightValueMarket;
  final bool rightValueMarketPositive;

  final bool hasLabelIcon;
  final Widget? labelIcon;

  final bool isDot;

  final bool isLoading;
  final bool isHighlated;

  @override
  Widget build(BuildContext context) {
    final isHighlated = useState(false);

    return SafeGesture(
      onTap: onTableAssetTap,
      highlightColor: SColorsLight().gray2,
      onHighlightChanged: (p0) {
        isHighlated.value = p0;
      },
      child: ColoredBox(
        color: isHighlated.value ? SColorsLight().gray2 : Colors.transparent,
        child: SizedBox(
          height: needPadding
              ? supplement == null
                  ? 64
                  : isCardWallet
                      ? 72
                      : 80
              : 48,
          child: Padding(
            padding: needPadding
                ? EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 16,
                    bottom: isCardWallet ? 8 : 16,
                  )
                : EdgeInsets.zero,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (isLoading) ...[
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: SColorsLight().gray4,
                      shape: BoxShape.circle,
                    ),
                  ),
                ] else ...[
                  if (isCardWallet) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 4),
                      child: assetIcon,
                    ),
                  ] else if (!isCard) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: assetIcon ?? Assets.svg.medium.crypto.simpleSvg(),
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 4),
                      child: Assets.svg.paymentMethodsCards.simple.defaultCard.simpleSvg(
                        width: 24,
                      ),
                    ),
                  ],
                ],
                const Gap(12),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 28,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (!isLoading) ...[
                              Flexible(
                                child: Text(
                                  label,
                                  style: STStyles.subtitle1,
                                ),
                              ),
                            ] else ...[
                              Container(
                                width: 80,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: SColorsLight().gray4,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ],
                            const Gap(4),
                            if (hasLabelIcon)
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: labelIcon ??
                                    Assets.svg.medium.freeze.simpleSvg(
                                      color: SColorsLight().gray8,
                                    ),
                              ),
                          ],
                        ),
                      ),
                      if (isLoading) ...[
                        const Gap(4),
                        Container(
                          width: 32,
                          height: 16,
                          decoration: BoxDecoration(
                            color: SColorsLight().gray4,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ] else ...[
                        if (supplement != null)
                          Text(
                            supplement ?? '',
                            style: STStyles.body2Medium.copyWith(
                              color: SColorsLight().gray10,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
                if (hasRightValue) ...[
                  //const Spacer(),
                  if (customRightWidget != null) ...[
                    customRightWidget!,
                  ] else ...[
                    if (isRightValueMarket) ...[
                      SizedBox(
                        height: 48,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (isLoading) ...[
                              Container(
                                width: 80,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: SColorsLight().gray4,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ] else ...[
                              Text(
                                rightValue ?? '',
                                style: STStyles.subtitle1,
                              ),
                            ],
                            if (isLoading) ...[
                              const Gap(8),
                              Container(
                                width: 32,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: SColorsLight().gray4,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ] else ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    rightMarketValue ?? '',
                                    style: STStyles.body2Semibold.copyWith(
                                      color: rightValueMarketPositive ? SColorsLight().green : SColorsLight().red,
                                    ),
                                  ),
                                  const Gap(2),
                                  rightValueMarketPositive
                                      ? isDot
                                          ? Assets.svg.medium.dot.simpleSvg(
                                              width: 16,
                                              height: 16,
                                              color: SColorsLight().green,
                                            )
                                          : Assets.svg.medium.arrowUp.simpleSvg(
                                              width: 16,
                                              height: 16,
                                              color: SColorsLight().green,
                                            )
                                      : isDot
                                          ? Assets.svg.medium.dot.simpleSvg(
                                              width: 16,
                                              height: 16,
                                              color: SColorsLight().red,
                                            )
                                          : Assets.svg.medium.arrowDown.simpleSvg(
                                              width: 16,
                                              height: 16,
                                              color: SColorsLight().red,
                                            ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      )
                    ] else ...[
                      RoundButton(
                        value: rightValue ?? '',
                      )
                    ],
                  ],
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
