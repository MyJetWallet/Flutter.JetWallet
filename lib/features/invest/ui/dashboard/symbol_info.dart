import 'package:auto_route/auto_route.dart';
import 'package:charts/main.dart';
import 'package:charts/model/candle_model.dart';
import 'package:charts/model/candle_type_enum.dart';
import 'package:charts/model/resolution_string_enum.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/headers/simple_small_header.dart';
import 'package:simple_kit/modules/icons/custom/public/invest/simple_invest_wallet.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';

import '../../../../core/l10n/i10n.dart';
import '../../../../utils/formatting/base/volume_format.dart';
import '../../../../utils/helpers/localized_chart_resolution_button.dart';
import '../../../../utils/models/currency_model.dart';
import '../../../chart/store/chart_store.dart';
import '../../helpers/percent_info.dart';
import '../widgets/invest_text_button.dart';
import 'my_wallet.dart';

class SymbolInfo extends StatelessObserverWidget {
  const SymbolInfo({
    super.key,
    required this.currency,
    required this.instrument,
    required this.price,
    required this.showProfit,
    this.profit,
    this.onTap,
  });

  final CurrencyModel currency;
  final InvestInstrumentModel instrument;
  final String price;
  final bool showProfit;
  final Decimal? profit;
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: showProfit ? null : Border.all(
            color: colors.grey4,
          ),
          color: colors.white,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 11,
          horizontal: 12,
        ),
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.network(
                  iconUrlFrom(assetSymbol: instrument.name ?? ''),
                  width: 16.0,
                  height: 16.0,
                  placeholderBuilder: (_) {
                    return const SIAssetPlaceholderIcon(width: 16, height: 16,);
                  },
                ),
                const SpaceW5(),
                SizedBox(
                  width: 36,
                  child: Text(
                    instrument.name ?? '',
                    style: sBody2InvestSMStyle.copyWith(
                      color: colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formatPercent(Decimal.fromJson(currency.dayPercentChange.toString())),
                      textAlign: TextAlign.end,
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
            const SpaceH4(),
            Text(
              price,
              style: sBody2InvestBStyle.copyWith(
                color: colors.black,
              ),
            ),
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
                  chartHeight: 30,
                  chartWidgetHeight: 30,
                  isAssetChart: false,
                  isInvestChart: true,
                  loader: const LoaderSpinner(),
                  accuracy: 2,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    color: Colors.transparent,
                    width: 130,
                    height: 30,
                  ),
                ),
              ],
            ),
            if (showProfit) ...[
              const SpaceH8(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'PL ',
                    style: sBody3InvestMStyle.copyWith(
                      color: colors.grey1,
                    ),
                  ),
                  Text(
                    marketFormat(
                      decimal: profit!,
                      accuracy: 2,
                      symbol: instrument.currencyQuote ?? '',
                    ),
                    style: sBody2InvestBStyle.copyWith(
                      color: colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
