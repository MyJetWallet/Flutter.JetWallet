import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

import '../../../../core/l10n/i10n.dart';
import '../../../../utils/formatting/base/market_format.dart';
import '../../../../utils/models/currency_model.dart';

class MyPortfolio extends StatelessObserverWidget {
  const MyPortfolio({
    super.key,
    required this.title,
    required this.pending,
    required this.amount,
    required this.balance,
    required this.percent,
    required this.onShare,
    required this.currency,
    required this.onTap,
  });

  final String title;
  final Decimal pending;
  final Decimal amount;
  final Decimal balance;
  final Decimal percent;
  final Function() onShare;
  final Function() onTap;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {

    final colors = sKit.colors;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceH9(),
              Row(
                children: [
                  Text(
                    title,
                    style: STStyles.header2Invest.copyWith(
                      color: colors.black,
                    ),
                  ),
                  const SpaceW5(),
                  SIconButton(
                    defaultIcon: Assets.svg.invest.share.simpleSvg(width: 20, height: 20,),
                    onTap: onShare,
                  ),
                ],
              ),
              const SpaceH4(),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        intl.invest_amount,
                        style: STStyles.body3InvestM.copyWith(
                          color: colors.grey1,
                        ),
                      ),
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
                  const SpaceW12(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        intl.invest_pending,
                        style: STStyles.body3InvestM.copyWith(
                          color: colors.grey1,
                        ),
                      ),
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
                            marketFormat(decimal: pending, accuracy: 2, symbol: ''),
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
              const SpaceH9(),
            ],
          ),
          const Spacer(),
          Container(
            width: 126,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                begin: Alignment(1.0, 3.0),
                end: Alignment(-1.0, -3.0),
                colors: [
                  Color(0xFFE8F9E8),
                  Color(0xFFC0E6C6),
                  Color(0xFFDFF7B6),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                const SpaceH2(),
                Text(
                  '${marketFormat(decimal: percent, accuracy: 2, symbol: '')}%',
                  style: STStyles.body1InvestSM.copyWith(
                    color: colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
