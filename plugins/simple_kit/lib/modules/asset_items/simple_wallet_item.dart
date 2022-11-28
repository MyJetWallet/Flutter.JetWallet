import 'package:flutter/material.dart';
import 'package:simple_kit/modules/asset_items/components/recurring_icon.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

/// TODO remove dependecy on Market details
/// This arguments are redundant, seperate widget for MarketDetails needed
class SWalletItem extends StatelessWidget {
  const SWalletItem({
    Key? key,
    this.currencyPrefix,
    this.currencySymbol = '',
    this.amountDecimal,
    this.amount,
    this.decline,
    this.removeDivider = false,
    this.color,
    this.onTap,
    this.leftBlockTopPadding = 22,
    this.balanceTopMargin = 22,
    this.height = 88,
    this.rightBlockTopPadding = 22,
    this.showSecondaryText = true,
    this.isRecurring = false,
    this.isPendingDeposit = false,
    required this.icon,
    required this.primaryText,
    required this.secondaryText,
  }) : super(key: key);

  final bool? decline;
  final String? currencyPrefix;
  final String currencySymbol;
  final double? amountDecimal;
  final String? amount;
  final bool removeDivider;
  final Color? color;
  final Function()? onTap;
  final Widget icon;
  final String primaryText;
  final String secondaryText;
  final double leftBlockTopPadding;
  final double balanceTopMargin;
  final double height;
  final double rightBlockTopPadding;
  final bool showSecondaryText;
  final bool isRecurring;
  final bool isPendingDeposit;

  @override
  Widget build(BuildContext context) {
    var textColor = SColorsLight().green;
    var borderColor = SColorsLight().greenLight;
    final emptyCashText = '${currencyPrefix ?? ''}0'
        '${currencyPrefix == null ? ' $currencySymbol' : ''}';
    final formattedAmount = amountDecimal == 0 ? emptyCashText : amount;
    final isSecondaryTextVisible =
        showSecondaryText &&
            !(isPendingDeposit && formattedAmount == emptyCashText);
    final isAmountVisible =
        amount != null &&
            !(isPendingDeposit && formattedAmount == emptyCashText);

    if (decline ?? false) {
      textColor = SColorsLight().red;
      borderColor = SColorsLight().redLight;
    }

    return InkWell(
      highlightColor: SColorsLight().grey5,
      splashColor: Colors.transparent,
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
                        Container(
                          constraints: const BoxConstraints(
                            maxWidth: 157.0,
                          ),
                          height: 44.0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: borderColor,
                            ),
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          child: Baseline(
                            baseline: 27.0,
                            baselineType: TextBaseline.alphabetic,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  formattedAmount!,
                                  style: sSubtitle2Style.copyWith(
                                    color: amountDecimal == 0
                                        ? color
                                        : textColor,
                                  ),
                                ),
                              ],
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
