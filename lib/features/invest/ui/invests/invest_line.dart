import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';

import '../../../../utils/formatting/base/volume_format.dart';
import '../../../../utils/models/currency_model.dart';
import '../../helpers/percent_info.dart';

class InvestLine extends StatelessObserverWidget {
  const InvestLine({
    super.key,
    required this.currency,
    required this.price,
    required this.operationType,
    required this.isPending,
    required this.amount,
    required this.leverage,
    required this.isGroup,
    required this.historyCount,
    required this.profit,
    required this.profitPercent,
    required this.accuracy,
    required this.onTap,
    this.priceAccuracy = 2,
    this.isClosedPosition = false,
  });

  final CurrencyModel currency;
  final Decimal price;
  final Decimal profit;
  final Decimal profitPercent;
  final Direction operationType;
  final bool isPending;
  final bool isGroup;
  final Decimal amount;
  final Decimal leverage;
  final int historyCount;
  final int accuracy;
  final int priceAccuracy;
  final Function() onTap;
  final bool isClosedPosition;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final isBalanceHide = getIt<AppStore>().isBalanceHide;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        width: MediaQuery.of(context).size.width - 48,
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Row(
                children: [
                  SvgPicture.network(
                    currency.iconUrl,
                    width: 20.0,
                    height: 20.0,
                    placeholderBuilder: (_) {
                      return const SAssetPlaceholderIcon();
                    },
                  ),
                  const SpaceW4(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            currency.symbol,
                            style: STStyles.body2InvestSM.copyWith(
                              color: colors.black,
                            ),
                          ),
                          if (isGroup) ...[
                            const SpaceW2(),
                            Container(
                              width: 11.5,
                              height: 11.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: colors.black,
                              ),
                              child: Center(
                                child: Text(
                                  historyCount.toString(),
                                  style: STStyles.captionInvestSM.copyWith(
                                    color: colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SpaceH2(),
                      Text(
                        currency.description,
                        style: STStyles.body2InvestM.copyWith(
                          color: colors.grey2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (!isGroup && operationType != Direction.undefined) ...[
              Container(
                padding: const EdgeInsets.only(left: 5, top: 4, bottom: 4, right: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: colors.grey5,
                ),
                child: Row(
                  children: [
                    Text(
                      operationType == Direction.buy ? intl.invest_buy : intl.invest_sell,
                      style: STStyles.body2InvestSM.copyWith(
                        color: colors.black,
                      ),
                    ),
                    const SpaceW2(),
                    if (operationType == Direction.buy)
                      Assets.svg.invest.buy.simpleSvg(
                        width: 14,
                        height: 14,
                      )
                    else
                      Assets.svg.invest.sell.simpleSvg(
                        width: 14,
                        height: 14,
                      ),
                  ],
                ),
              ),
              const SpaceW10(),
            ],
            SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isBalanceHide
                        ? '****'
                        : marketFormat(
                            decimal: amount,
                            accuracy: 0,
                            symbol: '',
                          ),
                    style: STStyles.body2InvestSM.copyWith(
                      color: colors.black,
                    ),
                  ),
                  const SpaceH2(),
                  Text(
                    'x${volumeFormat(decimal: leverage, accuracy: 2, symbol: '').replaceAll(' ', '')}',
                    style: STStyles.body3InvestM.copyWith(
                      color: colors.grey2,
                    ),
                  ),
                ],
              ),
            ),
            const SpaceW24(),
            SizedBox(
              width: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isClosedPosition)
                    Text(
                      isBalanceHide
                          ? '****'
                          : marketFormat(
                              decimal: price,
                              accuracy: priceAccuracy,
                              symbol: '',
                            ),
                      style: STStyles.body2InvestB.copyWith(
                        color: colors.black,
                      ),
                    )
                  else
                    Text(
                      isBalanceHide
                          ? '****'
                          : isPending
                              ? marketFormat(
                                  decimal: price,
                                  accuracy: priceAccuracy,
                                  symbol: '',
                                )
                              : marketFormat(
                                  decimal: profit,
                                  accuracy: priceAccuracy,
                                  symbol: '',
                                ),
                      style: STStyles.body2InvestB.copyWith(
                        color: colors.black,
                      ),
                    ),
                  if (!isPending) ...[
                    const SpaceH2(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          formatPercent(profitPercent),
                          overflow: TextOverflow.ellipsis,
                          style: STStyles.body3InvestSM.copyWith(
                            color: profitPercent == Decimal.zero
                                ? SColorsLight().grey3
                                : profitPercent > Decimal.zero
                                    ? SColorsLight().green
                                    : SColorsLight().red,
                          ),
                        ),
                        percentIcon(profitPercent),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
