import 'package:charts/main.dart';
import 'package:charts/model/candle_model.dart';
import 'package:charts/model/candle_type_enum.dart';
import 'package:charts/model/resolution_string_enum.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jetwallet/features/invest/ui/dashboard/active_invest_line.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';

import '../../../../utils/formatting/base/volume_format.dart';
import '../../../../utils/helpers/localized_chart_resolution_button.dart';
import '../../../../utils/models/currency_model.dart';
import '../../helpers/percent_info.dart';

class SymbolInfoLine extends StatelessObserverWidget {
  const SymbolInfoLine({
    super.key,
    required this.currency,
    required this.instrument,
    required this.price,
    this.profit,
    this.amount,
    this.withActiveInvest = false,
    this.withFavorites = false,
    this.isFavorite = false,
    this.onTapFavorites,
    this.onTap,
  });

  final CurrencyModel currency;
  final InvestInstrumentModel instrument;
  final String price;
  final Decimal? profit;
  final Decimal? amount;
  final bool withActiveInvest;
  final bool withFavorites;
  final bool isFavorite;
  final Function()? onTapFavorites;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {

    final colors = sKit.colors;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        width: MediaQuery.of(context).size.width - 48,
        child: Column(
          children: [
            if (withActiveInvest) ...[
              ActiveInvestLine(
                profit: profit!,
                amount: amount!,
              ),
              const SpaceH3(),
            ],
            Row(
              children: [
                Row(
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
                        Text(
                          instrument.name!,
                          style: sBody2InvestSMStyle.copyWith(
                            color: colors.black,
                          ),
                        ),
                        const SpaceH2(),
                        Text(
                          instrument.description!,
                          style: sBody3InvestMStyle.copyWith(
                            color: colors.grey2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Stack(
                  children: [
                    Chart(
                      localizedChartResolutionButton:
                      localizedChartResolutionButton(context),
                      onResolutionChanged: (resolution) {

                      },
                      onChartTypeChanged: (type) {

                      },
                      chartType: ChartType.area,
                      candleResolution: Period.month,
                      formatPrice: volumeFormat,
                      candles: [
                        CandleModel(open: 200.643026, high: 200.70921986, low: 196.4822695, close: 196.84160757, date: 1694761200000),
                        CandleModel(open: 196.6392901, high: 198.60285094, low: 197.59274993, close: 197.80043425, date: 1695654000000),
                        CandleModel(open: 198.35398732, high: 200.48245199, low: 198.59994324, close: 200.17027717, date: 1695682800000),
                        CandleModel(open: 200.06613757, high: 201.52116402, low: 199.92441421, close: 199.43310658, date: 1695711600000),
                        CandleModel(open: 199.87699877, high: 200.74746901, low: 199.8864604, close: 199.86753714, date: 1695740400000),
                        CandleModel(open: 199.98107852, high: 201.54210028, low: 200.7473983, close: 201.20151372, date: 1695769200000),
                        CandleModel(open: 202.5026168, high: 205.19554667, low: 202.45503854, close: 201.11333143, date: 1695798000000),
                        CandleModel(open: 201.39960011, high: 202.28506141, low: 201.04731981, close: 201.27582595, date: 1695826800000),
                      ],
                      onCandleSelected: (value) {},
                      chartHeight: 32,
                      chartWidgetHeight: 32,
                      isAssetChart: false,
                      isInvestChart: true,
                      isLongInvest: true,
                      loader: const LoaderSpinner(),
                      accuracy: 2,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        color: Colors.transparent,
                        width: 130,
                        height: 32,
                      ),
                    ),
                  ],
                ),
                if (withFavorites)
                  const SpaceW10()
                else
                  const SpaceW24(),
                SizedBox(
                  width: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price,
                        style: sBody2InvestBStyle.copyWith(
                          color: colors.black,
                        ),
                      ),
                      const SpaceH2(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            formatPercent(Decimal.fromJson(currency.dayPercentChange.toString())),
                            overflow: TextOverflow.ellipsis,
                            style: sBody3InvestSMStyle.copyWith(
                              color: Decimal.fromJson(currency.dayPercentChange.toString()) == Decimal.zero
                                  ? colors.grey3
                                  : Decimal.fromJson(currency.dayPercentChange.toString()) > Decimal.zero
                                  ? colors.green
                                  : colors.red,
                            ),
                          ),
                          percentIcon(Decimal.fromJson(currency.dayPercentChange.toString())),
                        ],
                      ),
                    ],
                  ),
                ),
                if (withFavorites) ...[
                  const SpaceW10(),
                  SIconButton(
                    onTap: () {
                      onTapFavorites?.call();
                    },
                    defaultIcon: isFavorite
                        ? SStarPressedIcon(color: colors.black,)
                        : const SStarPressedIcon(),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
