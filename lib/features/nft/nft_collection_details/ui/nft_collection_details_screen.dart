import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/helper/nft_collection_filter_modal.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/nft/nft_collection_details/store/nft_collection_store.dart';
import 'package:jetwallet/features/nft/nft_collection_details/ui/components/nft_collection_nft_item.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/nft_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/icons/24x24/public/sort/simple_sort_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

class NftCollectionDetails extends StatelessWidget {
  const NftCollectionDetails({
    super.key,
    required this.nft,
  });

  final NftModel nft;

  @override
  Widget build(BuildContext context) {
    return Provider<NFTCollectionDetailStore>(
      create: (context) => NFTCollectionDetailStore()..init(nft),
      builder: (context, child) => _NftCollectionDetailsBody(
        nft: nft,
      ),
    );
  }
}

class _NftCollectionDetailsBody extends StatelessObserverWidget {
  const _NftCollectionDetailsBody({
    super.key,
    required this.nft,
  });

  final NftModel nft;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final store = NFTCollectionDetailStore.of(context);

    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      nft.bestOfferAsset ?? '',
    );

    final childAspectRatio = 0.9;

    return Material(
      color: colors.white,
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            leading: Container(
              margin: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                color: colors.white,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8.0),
              child: SIconButton(
                onTap: () {
                  sRouter.pop();
                },
                defaultIcon: const SBackIcon(),
              ),
            ),
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                '$fullUrl${nft.fImage}',
                fit: BoxFit.cover,
              ),
            ),
            actions: <Widget>[
              /*
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: SIconButton(
                    onTap: () {},
                    defaultIcon: const SStarIcon(),
                  ),
                ),
              */
            ],
          ),
          SliverToBoxAdapter(
            child: SPaddingH24(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Baseline(
                    baseline: 40,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      nft.name ?? '',
                      maxLines: 3,
                      style: sTextH2Style,
                    ),
                  ),
                  if (nft.description != null &&
                      nft.description!.isNotEmpty) ...[
                    const SizedBox(
                      height: 20,
                    ),
                    Baseline(
                      baseline: 24,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        nft.description ?? '',
                        maxLines: 5,
                        style: sBodyText1Style,
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Baseline(
                            baseline: 21,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              intl.nft_collection_details_items,
                              style: sBodyText2Style.copyWith(
                                color: colors.grey1,
                              ),
                            ),
                          ),
                          Text(
                            '${nft.nftList.length}',
                            style: sBodyText1Style,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.37,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Baseline(
                            baseline: 21,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              intl.nft_collection_details_owners,
                              style: sBodyText2Style.copyWith(
                                color: colors.grey1,
                              ),
                            ),
                          ),
                          Text(
                            nft.ownerCount!.toString(),
                            style: sBodyText1Style,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const SDivider(),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Baseline(
                            baseline: 21,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              intl.nft_collection_details_total_volume,
                              style: sBodyText2Style.copyWith(
                                color: colors.grey1,
                              ),
                            ),
                          ),
                          Text(
                            //nft.totalVolumeUsd!.toString(),
                            marketFormat(
                              prefix: '\$',
                              onlyFullPart: true,
                              decimal: nft.totalVolumeUsd!,
                              accuracy: 2,
                              symbol: '',
                            ),
                            style: sBodyText1Style,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Baseline(
                            baseline: 21,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              intl.nft_collection_details_best_offer,
                              style: sBodyText2Style.copyWith(
                                color: colors.grey1,
                              ),
                            ),
                          ),
                          Text(
                            volumeFormat(
                              decimal: Decimal.fromInt(nft.bestOffer!),
                              symbol: nft.bestOfferAsset!,
                              accuracy: currency.accuracy,
                            ),
                            style: sBodyText1Style,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const SDivider(),
                  const SizedBox(
                    height: 25,
                  ),
                  if (store.availableNFTFiltred.isNotEmpty) ...[
                    Row(
                      children: [
                        Baseline(
                          baseline: 32,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            intl.nft_collection_details_best_available_nfts,
                            style: sTextH4Style,
                          ),
                        ),
                        const Spacer(),
                        SIconButton(
                          onTap: () {
                            showNFTCollectionFilterModalSheet(
                              context,
                              NFTCollectionDetailStore.of(context)
                                  as NFTCollectionDetailStore,
                            );
                          },
                          defaultIcon: const SSortIcon(),
                        ),
                        const SpaceW12(),
                        SIconButton(
                          onTap: () {
                            store.setSsAvailableHide();
                          },
                          defaultIcon: store.isAvailableHide
                              ? const SAngleUpIcon()
                              : const SAngleDownIcon(),
                        ),
                      ],
                    ),
                    if (store.isAvailableHide) ...[
                      const SizedBox(
                        height: 12,
                      ),
                      const SDivider(),
                    ],
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (store.availableNFTFiltred.isNotEmpty &&
              !store.isAvailableHide) ...[
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: childAspectRatio - 0.1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                    ),
                    child: NFTCollectionNftItem(
                      nft: store.availableNFTFiltred[index],
                      onTap: () {
                        sRouter.push(
                          NFTDetailsRouter(
                            nft: store.availableNFTFiltred[index],
                          ),
                        );
                      },
                    ),
                  );
                },
                childCount: store.availableNFTFiltred.length,
              ),
            ),
          ],
          if (store.soldNFTFiltred.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: SPaddingH24(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Baseline(
                          baseline: 32,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            intl.nft_collection_details_best_sold_nfts,
                            style: sTextH4Style,
                          ),
                        ),
                        const Spacer(),
                        SIconButton(
                          onTap: () {
                            showNFTCollectionFilterModalSheet(
                              context,
                              NFTCollectionDetailStore.of(context)
                                  as NFTCollectionDetailStore,
                              isAvailableNFT: false,
                            );
                          },
                          defaultIcon: const SSortIcon(),
                        ),
                        const SpaceW12(),
                        SIconButton(
                          onTap: () {
                            store.setIsSoldHide();
                          },
                          defaultIcon: store.isSoldHide
                              ? const SAngleUpIcon()
                              : const SAngleDownIcon(),
                        ),
                      ],
                    ),
                    if (store.isSoldHide) ...[
                      const SizedBox(
                        height: 12,
                      ),
                      const SDivider(),
                    ],
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ),
            if (!store.isSoldHide) ...[
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: childAspectRatio,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                      ),
                      child: NFTCollectionNftItem(
                        nft: store.soldNFTFiltred[index],
                        onTap: () {},
                      ),
                    );
                  },
                  childCount: store.soldNFTFiltred.length,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
