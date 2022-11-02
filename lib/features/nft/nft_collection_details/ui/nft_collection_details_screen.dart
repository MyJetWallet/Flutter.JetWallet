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
import 'package:jetwallet/widgets/silver_fixed_height.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/icons/24x24/public/sort/simple_sort_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

class NftCollectionDetails extends StatelessWidget {
  const NftCollectionDetails({
    super.key,
    //required this.nft,
    required this.collectionID,
  });

  //final NftModel nft;
  final String collectionID;

  @override
  Widget build(BuildContext context) {
    return Provider<NFTCollectionDetailStore>(
      create: (context) => NFTCollectionDetailStore()..init(collectionID),
      builder: (context, child) => const _NftCollectionDetailsBody(),
    );
  }
}

class _NftCollectionDetailsBody extends StatelessObserverWidget {
  const _NftCollectionDetailsBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final store = NFTCollectionDetailStore.of(context);

    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      store.nftModel?.bestOfferAsset ?? '',
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
            pinned: true,
            elevation: 0.0,
            backgroundColor: Colors.white,
            expandedHeight: 130.0,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final top = constraints.biggest.height;

                return FlexibleSpaceBar(
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 50),
                    opacity: top ==
                            MediaQuery.of(context).padding.top + kToolbarHeight
                        ? 1.0
                        : 0.0,
                    child: Baseline(
                      baseline: 24,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        store.nftModel!.name ?? '',
                        style: sTextH5Style.copyWith(
                          color: colors.black,
                        ),
                      ),
                    ),
                  ),
                  background: Image.network(
                    '$fullUrl${store.nftModel!.fImage}',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            actions: [
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
                  const SpaceH25(),
                  Baseline(
                    baseline: 41,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      store.nftModel!.name ?? '',
                      maxLines: 3,
                      style: sTextH2Style,
                    ),
                  ),
                  if (store.nftModel!.description != null &&
                      store.nftModel!.description!.isNotEmpty) ...[
                    const SizedBox(
                      height: 20,
                    ),
                    Baseline(
                      baseline: 24,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        store.nftModel!.description ?? '',
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
                          Baseline(
                            baseline: 24,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              '${store.nftModel!.nftList.length}',
                              style: sBodyText1Style,
                            ),
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
                          Baseline(
                            baseline: 24,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              store.nftModel!.ownerCount!.toString(),
                              style: sBodyText1Style,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SpaceH12(),
                  const SDivider(),
                  const SpaceH25(),
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
                          Baseline(
                            baseline: 24,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              //nft.totalVolumeUsd!.toString(),
                              marketFormat(
                                prefix: '\$',
                                onlyFullPart: true,
                                decimal: store.nftModel!.totalVolumeUsd!,
                                accuracy: 2,
                                symbol: '',
                              ),
                              style: sBodyText1Style,
                            ),
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
                          Baseline(
                            baseline: 24,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              volumeFormat(
                                decimal:
                                    store.nftModel!.bestOffer ?? Decimal.zero,
                                symbol: store.nftModel!.bestOfferAsset!,
                                accuracy: currency.accuracy,
                              ),
                              style: sBodyText1Style,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SpaceH12(),
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
                      const SpaceH12(),
                      const SDivider(),
                    ],
                    const SpaceH32(),
                  ],
                ],
              ),
            ),
          ),
          if (store.availableNFTFiltred.isNotEmpty &&
              !store.isAvailableHide) ...[
            SliverGrid(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                crossAxisCount: 2,
                //childAspectRatio: childAspectRatio - 0.2,
                height: 235,
                crossAxisSpacing: 19,
                mainAxisSpacing: 20,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index.isEven ? 24 : 0,
                      right: index.isEven ? 0 : 24,
                    ),
                    child: NFTCollectionNftItem(
                      nft: store.availableNFTFiltred[index],
                      onTap: () {
                        sRouter.push(
                          NFTDetailsRouter(
                            nftSymbol: store.availableNFTFiltred[index].symbol!,
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
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                  crossAxisCount: 2,
                  //childAspectRatio: childAspectRatio - 0.09,
                  height: 198,
                  crossAxisSpacing: 19,
                  mainAxisSpacing: 20,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index.isEven ? 24 : 0,
                        right: index.isEven ? 0 : 24,
                      ),
                      child: NFTCollectionNftItem(
                        nft: store.soldNFTFiltred[index],
                        onTap: () {
                          sRouter.push(
                            NFTDetailsRouter(
                              nftSymbol: store.soldNFTFiltred[index].symbol!,
                            ),
                          );
                        },
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
