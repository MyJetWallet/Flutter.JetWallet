import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:jetwallet/features/home/store/bottom_bar_store.dart';
import 'package:jetwallet/features/market/helper/market_gainers.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class TopMoversDashboardSection extends StatelessWidget {
  const TopMoversDashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Observer(
      builder: (context) {
        final marketGainers = getMarketGainers();
        final topMoverslist = marketGainers.sublist(0, 4);
        topMoverslist.sort((a, b) => b.dayPriceChange.compareTo(a.dayPriceChange));

        return Column(
          children: [
            SBasicHeader(
              title: intl.tom_mover_section_top_movers,
              buttonTitle: intl.tom_mover_section_view_all,
              onTap: () {
                getIt<BottomBarStore>().setHomeTab(BottomItemType.market);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...List.generate(
                  topMoverslist.length,
                  (index) => _AssetItem(
                    topMoverslist[index],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 24,
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

class _AssetItem extends StatelessWidget {
  const _AssetItem(this.asset);

  final MarketItemModel asset;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return SafeGesture(
      onTap: () {
        sRouter.push(
          MarketDetailsRouter(
            marketItem: asset,
          ),
        );
      },
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
            children: [
              Assets.svg.medium.arrowUp.simpleSvg(
                width: 16,
                height: 16,
                color: colors.green,
              ),
              const Gap(2),
              Text(
                asset.dayPriceChange.toString(),
                style: STStyles.body2Semibold.copyWith(
                  color: colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
