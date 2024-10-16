import 'package:charts/model/candle_model.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';

import '../../helpers/percent_info.dart';
import '../widgets/small_chart.dart';

class SymbolInfo extends StatelessObserverWidget {
  const SymbolInfo({
    super.key,
    required this.instrument,
    required this.price,
    required this.showProfit,
    required this.candles,
    this.profit,
    required this.percent,
    this.onTap,
  });

  final InvestInstrumentModel instrument;
  final String price;
  final bool showProfit;
  final List<CandleModel> candles;
  final Decimal? profit;
  final Decimal percent;
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
          border: showProfit
              ? null
              : Border.all(
                  color: colors.grey4,
                ),
          color: colors.white,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 11,
          horizontal: 11,
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
                    return Assets.svg.invest.investAssetPlaceholder.simpleSvg(
                      width: 16,
                      height: 16,
                    );
                  },
                ),
                const SpaceW5(),
                SizedBox(
                  width: 36,
                  child: Text(
                    instrument.name ?? '',
                    style: STStyles.body2InvestSM.copyWith(
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
                      percent.toDouble().toFormatPercentPriceChange(),
                      textAlign: TextAlign.end,
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
            const SpaceH4(),
            Text(
              price,
              style: STStyles.body2InvestB.copyWith(
                color: colors.black,
              ),
            ),
            Stack(
              children: [
                SmallChart(candles: candles),
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
                    style: STStyles.body3InvestM.copyWith(
                      color: colors.grey1,
                    ),
                  ),
                  Text(
                    getIt<AppStore>().isBalanceHide
                        ? '**** ${instrument.currencyQuote ?? ''}'
                        : profit!.toFormatSum(
                            accuracy: 2,
                            symbol: instrument.currencyQuote ?? '',
                          ),
                    style: STStyles.body2InvestB.copyWith(
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
