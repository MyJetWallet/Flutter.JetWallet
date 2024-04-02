import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

import '../../../../core/l10n/i10n.dart';
import '../../../../utils/models/currency_model.dart';
import '../../helpers/percent_info.dart';

class MainInvestBlock extends StatelessObserverWidget {
  const MainInvestBlock({
    super.key,
    required this.pending,
    required this.amount,
    required this.balance,
    required this.percent,
    required this.onShare,
    required this.currency,
    required this.title,
    this.showAmount = true,
    this.showPercent = true,
    this.showShare = true,
    this.showBalance = true,
  });

  final Decimal pending;
  final Decimal amount;
  final Decimal balance;
  final Decimal percent;
  final Function() onShare;
  final CurrencyModel currency;
  final bool showAmount;
  final bool showPercent;
  final bool showShare;
  final bool showBalance;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showAmount) const SpaceH9() else const SpaceH16(),
            Row(
              children: [
                Text(
                  title,
                  style: STStyles.header2Invest.copyWith(
                    color: colors.black,
                  ),
                ),
              ],
            ),
            if (showAmount) ...[
              const SpaceH4(),
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        intl.invest_amount,
                        style: STStyles.body3InvestM.copyWith(
                          color: colors.grey1,
                        ),
                      ),
                      const SpaceW4(),
                      Row(
                        children: [
                          SvgPicture.network(
                            currency.iconUrl,
                            width: 10.0,
                            height: 10.0,
                            placeholderBuilder: (_) {
                              return const SAssetPlaceholderIcon();
                            },
                          ),
                          const SpaceW2(),
                          Text(
                            marketFormat(decimal: amount, accuracy: 2, symbol: ''),
                            style: STStyles.body3InvestSM.copyWith(
                              color: colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
            if (showAmount) const SpaceH9() else const SpaceH16(),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (showBalance)
              Row(
                children: [
                  SvgPicture.network(
                    currency.iconUrl,
                    width: 16.0,
                    height: 16.0,
                    placeholderBuilder: (_) {
                      return const SAssetPlaceholderIcon();
                    },
                  ),
                  const SpaceW4(),
                  Text(
                    marketFormat(decimal: balance, accuracy: 2, symbol: ''),
                    style: STStyles.header3Invest.copyWith(
                      color: colors.black,
                    ),
                  ),
                ],
              ),
            if (showPercent) ...[
              const SpaceH2(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    formatPercent(percent),
                    overflow: TextOverflow.ellipsis,
                    style: STStyles.body3InvestSM.copyWith(
                      color: percent == Decimal.zero
                          ? colors.grey3
                          : percent > Decimal.zero
                              ? colors.green
                              : colors.red,
                    ),
                  ),
                  percentIcon(percent),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}
