import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/chart/model/chart_input.dart';
import 'package:jetwallet/features/chart/model/chart_state.dart';
import 'package:jetwallet/features/chart/store/chart_store.dart';
import 'package:jetwallet/features/home/store/bottom_bar_store.dart';
import 'package:jetwallet/features/invest/ui/widgets/small_chart.dart';
import 'package:jetwallet/features/market/market_details/helper/period_change.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class WalletPriceSection extends HookWidget {
  const WalletPriceSection({super.key, required this.currency});

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final isHighlated = useState(false);
    final markerItem = sSignalRModules.getMarketPrices.firstWhere((element) => element.symbol == currency.symbol);

    return Provider<ChartStore>(
      create: (context) => ChartStore(
        ChartInput(
          creationDate: markerItem.startMarketTime,
          instrumentId: markerItem.associateAssetPair,
        ),
      ),
      child: Observer(
        builder: (context) {
          final colors = SColorsLight();

          final store = ChartStore.of(context);

          final baseCurrency = sSignalRModules.baseCurrency;

          final candles = store.candles[store.resolution] ?? [];

          final changes = periodChange(
            chart: ChartState(
              selectedCandle: store.selectedCandle,
              candles: store.candles,
              type: store.type,
              resolution: store.resolution,
              union: store.union,
            ),
            selectedCandle: store.selectedCandle,
            baseCurrency: baseCurrency,
            marketItem: markerItem,
          );

          final periodPriceChange = changes[0];
          final periodPercentChange = changes[1];

          return SafeGesture(
            onTap: () async {
              await sRouter.replace(
                MarketDetailsRouter(
                  marketItem: markerItem,
                ),
              );
              getIt<BottomBarStore>().setHomeTab(BottomItemType.market);
            },
            highlightColor: colors.gray2,
            onHighlightChanged: (p0) {
              isHighlated.value = p0;
            },
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: colors.gray4),
                  borderRadius: BorderRadius.circular(12),
                ),
                color: isHighlated.value ? colors.gray2 : Colors.transparent,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        intl.wallet_price(currency.description),
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
                        '$periodPriceChange $periodPercentChange',
                        style: STStyles.body2Semibold.copyWith(
                          color: (periodPriceChange.contains('-')) ? colors.red : colors.green,
                        ),
                      ),
                    ],
                  ),
                  SmallChart(
                    candles: candles.reversed.toList(),
                    width: 120,
                    height: 40,
                    lineWith: 2,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
