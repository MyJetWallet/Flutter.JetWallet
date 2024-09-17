import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:jetwallet/utils/formatting/base/format_percent.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class TopMoversAssetItem extends HookWidget {
  const TopMoversAssetItem(this.asset);

  final MarketItemModel asset;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final isHighlated = useState(false);

    final baseCurrency = sSignalRModules.baseCurrency;

    return SafeGesture(
      highlightColor: colors.gray2,
      onHighlightChanged: (p0) {
        isHighlated.value = p0;
      },
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        getIt.get<EventBus>().fire(EndReordering());
        sRouter.push(
          MarketDetailsRouter(
            marketItem: asset,
          ),
        );
      },
      child: Container(
        width: 120,
        height: 140,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: colors.gray4,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          color: isHighlated.value ? colors.gray2 : Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetworkIconWidget(
              asset.iconUrl,
              height: 32,
              width: 32,
            ),
            const SizedBox(height: 8),
            Text(
              asset.symbol,
              style: STStyles.body1Semibold,
            ),
            Text(
              asset.lastPrice.toFormatPrice(
                prefix: baseCurrency.prefix,
                accuracy: asset.priceAccuracy,
              ),
              style: STStyles.body2Medium,
            ),
            Text(
              formatPercent(asset.dayPercentChange),
              style: STStyles.subtitle1.copyWith(
                color: asset.dayPercentChange.isNegative ? colors.red : colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
