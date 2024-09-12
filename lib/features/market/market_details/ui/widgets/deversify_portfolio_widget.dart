import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/market/widgets/top_movers_asset_item.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/table/divider/simple_divider.dart';

class DeversifyPortfolioWidget extends StatelessWidget {
  const DeversifyPortfolioWidget({super.key, required this.marketItem});

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Observer(
      builder: (context) {
        final marketItems = sSignalRModules.getMarketPrices;

        final sectorAssets = marketItems
            .where(
              (item) => item.sectorId == marketItem.sectorId && item.symbol != marketItem.symbol,
            )
            .toList();

        return sectorAssets.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SBasicHeader(
                    title: intl.market_diversify_portfolio,
                    buttonTitle: intl.tom_mover_section_view_all,
                    onTap: () {
                      sRouter.popUntilRoot();
                    },
                  ),
                  SizedBox(
                    height: 140,
                    child: CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        const SliverToBoxAdapter(
                          child: SizedBox(width: 24),
                        ),
                        SliverList.separated(
                          itemCount: sectorAssets.length,
                          itemBuilder: (context, index) {
                            return TopMoversAssetItem(
                              sectorAssets[index],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              width: 8,
                            );
                          },
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(width: 24),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 32,
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
              )
            : const Offstage();
      },
    );
  }
}
