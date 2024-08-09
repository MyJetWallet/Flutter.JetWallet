import 'package:charts/model/candle_model.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/invest/stores/chart/invest_chart_store.dart';
import 'package:jetwallet/features/invest/ui/widgets/small_chart.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class WalletPriceSection extends StatefulWidget {
  const WalletPriceSection({super.key, required this.currency});

  final CurrencyModel currency;

  @override
  State<WalletPriceSection> createState() => _WalletPriceSectionState();
}

class _WalletPriceSectionState extends State<WalletPriceSection> {
  List<CandleModel> candles = [];
  @override
  void initState() {
    super.initState();

    final investChartStore = getIt.get<InvestChartStore>();
    final markerItem =
        sSignalRModules.getMarketPrices.firstWhere((element) => element.symbol == widget.currency.symbol);

    investChartStore
        .fetchAssetCandles(
      markerItem.associateAssetPair,
    )
        .then((valse) {
      setState(() {
        candles = valse;
      });
    });
  }

  var isHighlated = false;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    final baseCurrency = sSignalRModules.baseCurrency;
    final markerItem =
        sSignalRModules.getMarketPrices.firstWhere((element) => element.symbol == widget.currency.symbol);

    return SafeGesture(
      onTap: () async {
        await sRouter.push(
          MarketDetailsRouter(
            marketItem: markerItem,
          ),
        );
      },
      highlightColor: colors.gray2,
      onHighlightChanged: (p0) {
        setState(() {
          isHighlated = p0;
        });
      },
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: colors.gray4),
            borderRadius: BorderRadius.circular(12),
          ),
          color: isHighlated ? colors.gray2 : Colors.transparent,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  intl.wallet_price(widget.currency.description),
                  style: STStyles.body2Semibold.copyWith(
                    color: colors.gray10,
                  ),
                ),
                Text(
                  markerItem.lastPrice.toFormatPrice(
                    prefix: baseCurrency.prefix,
                    accuracy: markerItem.priceAccuracy,
                  ),
                  style: STStyles.subtitle1,
                ),
                Text(
                  '${markerItem.lastPrice - markerItem.dayPriceChange} (${markerItem.dayPercentChange}%)',
                  style: STStyles.body2Semibold.copyWith(
                    color:
                        (markerItem.lastPrice - markerItem.dayPriceChange) < Decimal.zero ? colors.red : colors.green,
                  ),
                ),
              ],
            ),
            SmallChart(
              candles: candles,
              width: 120,
              height: 40,
              lineWith: 2,
            ),
          ],
        ),
      ),
    );
  }
}
