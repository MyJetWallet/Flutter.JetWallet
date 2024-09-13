import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:jetwallet/features/market/helper/sector_extensions.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/market/widgets/top_movers_asset_item.dart';
import 'package:simple_networking/modules/signal_r/models/market_sectors_message_model.dart';

class DeversifyPortfolioWidget extends StatelessWidget {
  const DeversifyPortfolioWidget({super.key, required this.marketItem});

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final mainSector = getMainSector();
        final sortedAssetsList = getSortedAssetsList();

        return sortedAssetsList.isNotEmpty && mainSector != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SBasicHeader(
                    title: intl.market_diversify_portfolio,
                    buttonTitle: intl.tom_mover_section_view_all,
                    onTap: () {
                      sRouter.push(
                        MarketSectorDetailsRouter(
                          sector: mainSector,
                        ),
                      );
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
                          itemCount: sortedAssetsList.length,
                          itemBuilder: (context, index) {
                            return TopMoversAssetItem(
                              sortedAssetsList[index],
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
                  const SizedBox(height: 16),
                ],
              )
            : const Offstage();
      },
    );
  }

  MarketSectorModel? getMainSector() {
    final sectorsForAsset =
        sSignalRModules.marketSectors.where((sectro) => marketItem.sectorIds.contains(sectro.id)).toList();
    sectorsForAsset.sort(
      (a, b) => a.weight.compareTo(
        b.weight,
      ),
    );

    return sectorsForAsset.firstOrNull;
  }

  List<MarketItemModel> getSortedAssetsList() {
    final result = <MarketItemModel>[];
    final assetSectorIds = marketItem.sectorIds;

    final assetSectors = sSignalRModules.marketSectors.where(
      (sector) {
        return assetSectorIds.contains(sector.id);
      },
    ).toList();

    for (final sector in assetSectors) {
      final marketItems = sector.marketItemsSorterByWeight
          .where(
            (item) => item.symbol != marketItem.symbol,
          )
          .toList();
      for (final marketItem in marketItems) {
        if (!result.any((a) => a.symbol == marketItem.symbol)) {
          result.add(marketItem);
        }
      }
    }

    return result;
  }
}
