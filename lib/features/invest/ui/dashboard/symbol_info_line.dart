import 'package:charts/model/candle_model.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jetwallet/features/invest/ui/dashboard/active_invest_line.dart';
import 'package:jetwallet/features/invest/ui/widgets/small_chart.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';

import '../../../../utils/helpers/icon_url_from.dart';
import '../../helpers/percent_info.dart';

class SymbolInfoLine extends StatelessObserverWidget {
  const SymbolInfoLine({
    super.key,
    required this.instrument,
    required this.price,
    required this.candles,
    required this.percent,
    this.profit,
    this.amount,
    this.withActiveInvest = false,
    this.withFavorites = false,
    this.isFavorite = false,
    this.onTapFavorites,
    this.onTap,
  });

  final InvestInstrumentModel instrument;
  final String price;
  final Decimal percent;
  final Decimal? profit;
  final Decimal? amount;
  final bool withActiveInvest;
  final bool withFavorites;
  final bool isFavorite;
  final Function()? onTapFavorites;
  final Function()? onTap;
  final List<CandleModel> candles;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      width: MediaQuery.of(context).size.width - 48,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (withActiveInvest) ...[
            ActiveInvestLine(
              profit: profit!,
              amount: amount!,
            ),
            const SpaceH3(),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  onTap?.call();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.network(
                      iconUrlFrom(assetSymbol: instrument.name ?? ''),
                      width: 20.0,
                      height: 20.0,
                      placeholderBuilder: (_) => const SAssetPlaceholderIcon(),
                    ),
                    const SpaceW4(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          instrument.name!,
                          style: STStyles.body2InvestSM.copyWith(color: colors.black),
                        ),
                        const SpaceH2(),
                        SizedBox(
                          width: 48,
                          child: Text(
                            instrument.description!,
                            style: STStyles.body3InvestM.copyWith(color: colors.grey2),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0), // Adjust padding as needed
                  child: SmallChart(
                    candles: candles,
                    height: 32,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: STStyles.body2InvestB.copyWith(
                      color: colors.black,
                    ),
                  ),
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
              ),
              const SpaceW10(),
              if (withFavorites)
                SIconButton(
                  onTap: () {
                    onTapFavorites?.call();
                  },
                  defaultIcon: isFavorite
                      ? SStarPressedIcon(
                          color: colors.black,
                        )
                      : const SStarPressedIcon(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
