import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_kit/simple_kit.dart';

class EarnActiveHeader extends StatelessObserverWidget {
  const EarnActiveHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final earnProfile = sSignalRModules.earnProfile;

    final baseCurrency = sSignalRModules.baseCurrency;

    var checkSizeOfText = sTextH1Style;
    var checkSizeOfSmallText = sSubtitle2Style;

    final lengthForCheck = volumeFormat(
      prefix: baseCurrency.prefix,
      decimal: earnProfile?.earnBalance ?? Decimal.zero,
      symbol: baseCurrency.symbol,
      accuracy: baseCurrency.accuracy,
      onlyFullPart:
          (earnProfile?.earnBalance ?? Decimal.zero) > 10000.toDecimal(),
    ).length;

    final lengthForSmallCheck = '${volumeFormat(
      prefix: baseCurrency.prefix,
      decimal: earnProfile?.dayEarnProfit ?? Decimal.zero,
      symbol: baseCurrency.symbol,
      accuracy: baseCurrency.accuracy,
      onlyFullPart:
          (earnProfile?.dayEarnProfit ?? Decimal.zero) > 10000.toDecimal(),
    )} (${volumeFormat(
      prefix: baseCurrency.prefix,
      decimal: earnProfile?.yearEarnProfit ?? Decimal.zero,
      symbol: baseCurrency.symbol,
      accuracy: baseCurrency.accuracy,
      onlyFullPart:
          (earnProfile?.yearEarnProfit ?? Decimal.zero) > 10000.toDecimal(),
    )})'
        .length;

    if (lengthForCheck > 15) {
      checkSizeOfText = sTextH4Style;
    } else if (lengthForCheck > 12) {
      checkSizeOfText = sTextH3Style;
    } else if (lengthForCheck > 9) {
      checkSizeOfText = sTextH2Style;
    }

    if (lengthForSmallCheck > 24) {
      checkSizeOfSmallText = sOverlineTextStyle;
    } else if (lengthForSmallCheck > 18) {
      checkSizeOfSmallText = sSubtitle3Style;
    }

    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Stack(
        children: [
          Image.asset(
            earnBackgroundImageAsset,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SPaddingH24(
            child: Column(
              children: [
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: FixedColumnWidth(146),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                volumeFormat(
                                  prefix: baseCurrency.prefix,
                                  decimal:
                                      earnProfile?.earnBalance ?? Decimal.zero,
                                  symbol: baseCurrency.symbol,
                                  accuracy: baseCurrency.accuracy,
                                  onlyFullPart: (earnProfile?.earnBalance ??
                                          Decimal.zero) >
                                      10000.toDecimal(),
                                ),
                                style: checkSizeOfText.copyWith(
                                  color: colors.black,
                                ),
                              ),
                              Text(
                                intl.earn_total_balance,
                                style: sBodyText2Style.copyWith(
                                  color: colors.grey1,
                                ),
                              ),
                              const SpaceH14(),
                            ],
                          ),
                        ),
                        TableCell(
                          child: Row(
                            children: [
                              const SpaceW18(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${earnProfile?.averageApy ?? 0}%',
                                    style: checkSizeOfText.copyWith(
                                      color: colors.black,
                                    ),
                                  ),
                                  Text(
                                    intl.earn_avg_apy,
                                    style: sBodyText2Style.copyWith(
                                      color: colors.grey1,
                                    ),
                                  ),
                                  const SpaceH14(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${volumeFormat(
                                  prefix: baseCurrency.prefix,
                                  decimal: earnProfile?.dayEarnProfit ??
                                      Decimal.zero,
                                  symbol: baseCurrency.symbol,
                                  accuracy: baseCurrency.accuracy,
                                  onlyFullPart: (earnProfile?.dayEarnProfit ??
                                          Decimal.zero) >
                                      10000.toDecimal(),
                                )} (${volumeFormat(
                                  prefix: baseCurrency.prefix,
                                  decimal: earnProfile?.yearEarnProfit ??
                                      Decimal.zero,
                                  symbol: baseCurrency.symbol,
                                  accuracy: baseCurrency.accuracy,
                                  onlyFullPart: (earnProfile?.yearEarnProfit ??
                                          Decimal.zero) >
                                      10000.toDecimal(),
                                )})',
                                style: checkSizeOfSmallText.copyWith(
                                  color: colors.black,
                                ),
                              ),
                              Text(
                                intl.earn_day_year_profit,
                                style: sBodyText2Style.copyWith(
                                  color: colors.grey1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TableCell(
                          child: Row(
                            children: [
                              const SpaceW18(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    volumeFormat(
                                      prefix: baseCurrency.prefix,
                                      decimal:
                                          earnProfile?.totalInterestEarned ??
                                              Decimal.zero,
                                      symbol: baseCurrency.symbol,
                                      accuracy: baseCurrency.accuracy,
                                    ),
                                    style: checkSizeOfSmallText.copyWith(
                                      color: colors.green,
                                    ),
                                  ),
                                  Text(
                                    intl.earn_total_earned,
                                    style: sBodyText2Style.copyWith(
                                      color: colors.grey1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SpaceH34(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
