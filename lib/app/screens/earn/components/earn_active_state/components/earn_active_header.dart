import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/constants.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/features/earn/notifier/earn_profile_notipod.dart';
import '../../../../../shared/helpers/formatting/formatting.dart';
import '../../../../../shared/providers/base_currency_pod/base_currency_pod.dart';

class EarnActiveHeader extends HookWidget {
  const EarnActiveHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final intl = useProvider(intlPod);
    final earnProfile = useProvider(earnProfileNotipod);
    final baseCurrency = useProvider(baseCurrencyPod);

    var checkSizeOfText = sTextH1Style;
    var checkSizeOfSmallText = sSubtitle2Style;

    final lengthForCheck = volumeFormat(
      prefix: baseCurrency.prefix,
      decimal: earnProfile
          .earnProfile
          ?.earnBalance ??
          Decimal.zero,
      symbol: baseCurrency.symbol,
      accuracy: baseCurrency.accuracy,
      onlyFullPart: (earnProfile
          .earnProfile
          ?.earnBalance ??
          Decimal.zero) > 10000.toDecimal(),
    ).length;

    final lengthForSmallCheck = '${volumeFormat(
      prefix: baseCurrency.prefix,
      decimal: earnProfile
          .earnProfile
          ?.dayEarnProfit ??
          Decimal.zero,
      symbol: baseCurrency.symbol,
      accuracy: baseCurrency.accuracy,
      onlyFullPart: (earnProfile
          .earnProfile
          ?.dayEarnProfit ??
          Decimal.zero) > 10000.toDecimal(),
    )
    } (${volumeFormat(
      prefix: baseCurrency.prefix,
      decimal: earnProfile
          .earnProfile
          ?.yearEarnProfit ??
          Decimal.zero,
      symbol: baseCurrency.symbol,
      accuracy: baseCurrency.accuracy,
      onlyFullPart: (earnProfile
          .earnProfile
          ?.yearEarnProfit ??
          Decimal.zero) > 10000.toDecimal(),
    )})'.length;

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
                    1: FixedColumnWidth(140),
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
                                  decimal: earnProfile
                                      .earnProfile
                                      ?.earnBalance ??
                                      Decimal.zero,
                                  symbol: baseCurrency.symbol,
                                  accuracy: baseCurrency.accuracy,
                                  onlyFullPart: (earnProfile
                                      .earnProfile
                                      ?.earnBalance ??
                                      Decimal.zero) > 10000.toDecimal(),
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
                                    '${earnProfile
                                        .earnProfile
                                        ?.averageApy ?? 0}%',
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
                                  decimal: earnProfile
                                      .earnProfile
                                      ?.dayEarnProfit ??
                                      Decimal.zero,
                                  symbol: baseCurrency.symbol,
                                  accuracy: baseCurrency.accuracy,
                                  onlyFullPart: (earnProfile
                                      .earnProfile
                                      ?.dayEarnProfit ??
                                      Decimal.zero) > 10000.toDecimal(),
                                )
                                } (${volumeFormat(
                                  prefix: baseCurrency.prefix,
                                  decimal: earnProfile
                                      .earnProfile
                                      ?.yearEarnProfit ??
                                      Decimal.zero,
                                  symbol: baseCurrency.symbol,
                                  accuracy: baseCurrency.accuracy,
                                  onlyFullPart: (earnProfile
                                      .earnProfile
                                      ?.yearEarnProfit ??
                                      Decimal.zero) > 10000.toDecimal(),
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
                                      decimal: earnProfile
                                          .earnProfile
                                          ?.totalInterestEarned
                                          ?? Decimal.zero,
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
