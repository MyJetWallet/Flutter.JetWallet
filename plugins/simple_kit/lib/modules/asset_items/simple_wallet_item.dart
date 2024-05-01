import 'package:flutter/material.dart';
import 'package:simple_kit/modules/asset_items/components/recurring_icon.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/icons/24x24/public/reorder/simple_reorder_icon.dart';

import '../../simple_kit.dart';

/// TODO remove dependecy on Market details
/// This arguments are redundant, seperate widget for MarketDetails needed
class SWalletItem extends StatelessWidget {
  const SWalletItem({
    super.key,
    this.fullSizeBalance = false,
    this.currencyPrefix,
    this.currencySymbol = '',
    this.amountDecimal,
    this.amount,
    this.decline,
    this.removeDivider = false,
    this.color,
    this.onTap,
    this.baseCurrencySymbol,
    this.leftBlockTopPadding = 22,
    this.balanceTopMargin = 22,
    this.height = 88,
    this.rightBlockTopPadding = 22,
    this.showSecondaryText = true,
    this.isRecurring = false,
    this.isPendingDeposit = false,
    this.isBalanceHide = false,
    this.isRounded = false,
    this.isMoving = false,
    required this.hideBalance,
    required this.icon,
    required this.primaryText,
    required this.secondaryText,
    this.priceFieldHeight,
  });

  final bool? decline;
  final String? currencyPrefix;
  final String currencySymbol;
  final double? amountDecimal;
  final String? amount;
  final bool removeDivider;
  final bool fullSizeBalance;
  final bool isRounded;
  final Color? color;
  final Function()? onTap;
  final Widget icon;
  final String primaryText;
  final String secondaryText;
  final double leftBlockTopPadding;
  final double balanceTopMargin;
  final double height;
  final double? priceFieldHeight;
  final double rightBlockTopPadding;
  final bool showSecondaryText;
  final bool isRecurring;
  final bool isPendingDeposit;
  final bool isBalanceHide;
  final bool isMoving;
  final bool hideBalance;

  final String? baseCurrencySymbol;

  @override
  Widget build(BuildContext context) {
    var textColor = SColorsLight().black;
    final emptyCashText = hideBalance ? '**** $currencySymbol' : '${currencyPrefix ?? ''}0'
        '${currencyPrefix == null ? ' $currencySymbol' : ''}';
    final formattedAmount = amountDecimal == 0 ? emptyCashText : amount;
    final isSecondaryTextVisible = showSecondaryText &&
        !(isPendingDeposit && formattedAmount == emptyCashText);
    final isAmountVisible = amount != null &&
        !(isPendingDeposit && formattedAmount == emptyCashText);

    return InkWell(
      highlightColor: SColorsLight().grey5,
      splashColor: Colors.transparent,
      borderRadius: BorderRadius.circular(isRounded ? 16 : 0),
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: height,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: leftBlockTopPadding),
                    child: Stack(
                      children: [
                        icon,
                        if (isRecurring) ...recurringIcon(),
                      ],
                    ),
                  ),
                  const SpaceW10(),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: EdgeInsets.only(top: leftBlockTopPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Baseline(
                            baseline: 18.0,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              primaryText,
                              style: sSubtitle2Style,
                            ),
                          ),
                          if (isSecondaryTextVisible)
                            Baseline(
                              baseline: 16.0,
                              baselineType: TextBaseline.alphabetic,
                              child: Text(
                                secondaryText,
                                style: sBodyText2Style.copyWith(
                                  color: SColorsLight().grey3,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (isAmountVisible) ...[
                    const SpaceW10(),
                    Column(
                      children: [
                        SizedBox(
                          height: rightBlockTopPadding,
                        ),
                        isMoving
                            ? const SReorderIcon()
                            : Container(
                                height: priceFieldHeight,
                                padding: EdgeInsets.only(
                                  left: 16.0,
                                  right: 16,
                                  top: fullSizeBalance ? 14 : 8,
                                  bottom: fullSizeBalance ? 11.75 : 5.75,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: SColorsLight().grey5,
                                  ),
                                  borderRadius: BorderRadius.circular(22.0),
                                ),
                                alignment: Alignment.center,
                                child: !isBalanceHide
                                    ? Text(
                                        formattedAmount!,
                                        style: sSubtitle2Style.copyWith(
                                          color: amountDecimal == 0
                                              ? color
                                              : textColor,
                                          height: 1,
                                        ),
                                        softWrap: true,
                                      )
                                    : Text(
                                        '***** $baseCurrencySymbol',
                                        style: sSubtitle2Style.copyWith(
                                          height: 1,
                                        ),
                                      ),
                              ),
                      ],
                    ),
                  ],
                ],
              ),
              const Spacer(),
              if (!removeDivider)
                const SDivider(
                  width: double.infinity,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
