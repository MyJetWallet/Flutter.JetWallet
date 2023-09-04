/*
class BlockAssetInfo extends StatelessWidget {
  const BlockAssetInfo({
    super.key,
    this.onTap,
    this.height = 88,
  });

  final Function()? onTap;

  final double height;

  @override
  Widget build(BuildContext context) {
    var textColor = SColorsLight().black;
    var borderColor = SColorsLight().greenLight;
    final emptyCashText = '${currencyPrefix ?? ''}0'
        '${currencyPrefix == null ? ' $currencySymbol' : ''}';
    final formattedAmount = amountDecimal == 0 ? emptyCashText : amount;
    final isSecondaryTextVisible = showSecondaryText &&
        !(isPendingDeposit && formattedAmount == emptyCashText);
    final isAmountVisible = amount != null &&
        !(isPendingDeposit && formattedAmount == emptyCashText);

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
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16,
                            top: 8,
                            bottom: 5.75,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: SColorsLight().grey5,
                            ),
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          child: !isBalanceHide
                              ? Text(
                                  formattedAmount!,
                                  style: sSubtitle2Style.copyWith(
                                    color:
                                        amountDecimal == 0 ? color : textColor,
                                    height: 1,
                                  ),
                                  softWrap: true,
                                )
                              : Text(
                                  '$baseCurrPrefix******',
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
*/
