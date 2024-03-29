import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/button/round/round_button.dart';
import 'package:simple_kit_updated/widgets/shared/safe_gesture.dart';

class SimpleTableAsset extends StatelessWidget {
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
    this.isRightValueMarket = false,
    this.rightValueMarketPositive = true,
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

  @override
  Widget build(BuildContext context) {
    return SafeGesture(
      onTap: onTableAssetTap,
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
                          Flexible(
                            child: Text(
                              label,
                              style: STStyles.subtitle1,
                            ),
                          ),
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
                    if (supplement != null)
                      Text(
                        supplement ?? '',
                        style: STStyles.body2Medium.copyWith(
                          color: SColorsLight().gray10,
                        ),
                      ),
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
                          Text(
                            rightValue ?? '',
                            style: STStyles.subtitle1,
                          ),
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
                                  ? Assets.svg.medium.arrowUp.simpleSvg(
                                      width: 16,
                                      height: 16,
                                      color: SColorsLight().green,
                                    )
                                  : Assets.svg.medium.arrowDown.simpleSvg(
                                      width: 16,
                                      height: 16,
                                      color: SColorsLight().red,
                                    ),
                            ],
                          ),
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
    );
  }
}
