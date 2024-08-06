import 'dart:math';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:jetwallet/features/home/store/bottom_bar_store.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class TopMoversDashboardSection extends StatelessWidget {
  const TopMoversDashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Observer(
      builder: (context) {
        final marketItems = [...sSignalRModules.getMarketPrices];

        marketItems.sort((a, b) => b.dayPercentChange.compareTo(a.dayPercentChange));

        final topMoverslist = marketItems.sublist(0, min(4, marketItems.length));

        return Column(
          children: [
            SBasicHeader(
              title: intl.tom_mover_section_top_movers,
              buttonTitle: intl.tom_mover_section_view_all,
              onTap: () {
                getIt.get<EventBus>().fire(EndReordering());
                getIt<BottomBarStore>().setHomeTab(BottomItemType.market);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...List.generate(
                    topMoverslist.length,
                    (index) => Expanded(
                      child: _AssetItem(
                        topMoverslist[index],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                left: 24,
                right: 24,
                bottom: 8,
              ),
              child: SDivider(
                height: 2,
                color: colors.gray2,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AssetItem extends HookWidget {
  const _AssetItem(this.asset);

  final MarketItemModel asset;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final isHighlated = useState(false);

    return SafeGesture(
      highlightColor: colors.gray2,
      onHighlightChanged: (p0) {
        isHighlated.value = p0;
      },
      onTap: () {
        getIt.get<EventBus>().fire(EndReordering());
        sRouter.push(
          MarketDetailsRouter(
            marketItem: asset,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isHighlated.value ? colors.gray2 : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              SNetworkSvg(
                width: 48,
                height: 48,
                url: asset.iconUrl,
              ),
              const SizedBox(height: 11),
              Text(
                asset.symbol,
                style: STStyles.body1Semibold,
              ),
              const Gap(2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (asset.dayPercentChange.isNegative)
                    Assets.svg.medium.arrowDown.simpleSvg(
                      width: 16,
                      height: 16,
                      color: colors.red,
                    )
                  else
                    Assets.svg.medium.arrowUp.simpleSvg(
                      width: 16,
                      height: 16,
                      color: colors.green,
                    ),
                  const Gap(2),
                  Text(
                    '${asset.dayPercentChange}%',
                    style: STStyles.body2Semibold.copyWith(
                      color: asset.dayPercentChange.isNegative ? colors.red : colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
