import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/about_block/components/clickable_underlined_text.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/nft_detail_bottom_bar/nft_detail_bottom_bar.dart';
import 'package:jetwallet/features/nft/nft_details/store/nft_detail_store.dart';
import 'package:jetwallet/features/nft/nft_details/ui/components/nft_about_block.dart';
import 'package:jetwallet/features/nft/nft_details/ui/components/nft_detail_header.dart';
import 'package:jetwallet/features/wallet/ui/widgets/action_button/action_button.dart';
import 'package:jetwallet/features/wallet/ui/widgets/action_button/action_button_nft.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

class NFTDetailsScreen extends StatelessWidget {
  const NFTDetailsScreen({
    super.key,
    this.userNFT = false,
    required this.nft,
  });

  final bool userNFT;
  final NftMarket nft;

  @override
  Widget build(BuildContext context) {
    return Provider<NFTDetailStore>(
      create: (context) => NFTDetailStore()..init(nft),
      builder: (context, child) => _NFTDetailsScreenBody(
        nft: nft,
        userNFT: userNFT,
      ),
    );
  }
}

class _NFTDetailsScreenBody extends StatefulObserverWidget {
  const _NFTDetailsScreenBody({
    super.key,
    this.userNFT = false,
    required this.nft,
  });

  final bool userNFT;
  final NftMarket nft;

  @override
  State<_NFTDetailsScreenBody> createState() => _NFTDetailsScreenBodyState();
}

class _NFTDetailsScreenBodyState extends State<_NFTDetailsScreenBody>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;

    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      widget.nft.tradingAsset ?? '',
    );

    final store = NFTDetailStore.of(context);

    final collection = sSignalRModules.nftList.firstWhere(
      (e) => e.id == store.nft!.collectionId,
    );

    bool isUserNFT = false;

    final userCollectionInd =
        sSignalRModules.userNFTList.indexWhere((e) => e.id == collection.id);

    if (userCollectionInd != -1) {
      final userNFTInd = sSignalRModules.userNFTList[userCollectionInd].nftList
          .indexWhere((e) => e.symbol == store.nft!.symbol);

      if (userNFTInd != -1) {
        isUserNFT = true;
      }
    }

    final Decimal nftPrice = isUserNFT
        ? widget.nft.sellPrice != null
            ? widget.nft.sellPrice!
            : widget.nft.buyPrice!
        : widget.nft.sellPrice!;

    return SPageFrame(
      loading: store.loader,
      bottomNavigationBar: widget.userNFT
          ? store.nft!.onSell!
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24.0,
                  ),
                  child: SSecondaryButton1(
                    active: true,
                    name: intl.nft_detail_cancel_selling,
                    onTap: () {
                      store.cancelSellOrder();
                    },
                  ),
                )
              : ActionButtonNft(
                  transitionAnimationController: _animationController,
                  nft: widget.nft,
                )
          : NFTDetailBottomBar(
              userNFT: widget.userNFT,
              nft: widget.nft,
              onTap: () => store.clickBuy(),
            ),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: colors.white,
            pinned: true,
            elevation: 0,
            expandedHeight: 180,
            collapsedHeight: 75,
            floating: true,
            automaticallyImplyLeading: false,
            flexibleSpace: SPaddingH24(
              child: NFTDetailHeader(
                title: widget.nft.name ?? '',
                fImage: '$shortUrl${widget.nft.sImage}',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SPaddingH24(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FullScreenWidget(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        '$fullUrl${widget.nft.fImage}',
                      ),
                    ),
                  ),
                  const SpaceH19(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 7.0),
                        child: SNetworkSvg24(
                          url: iconUrlFrom(
                            assetSymbol: widget.nft.tradingAsset!,
                          ),
                        ),
                      ),
                      const SpaceW6(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            volumeFormat(
                              decimal: nftPrice,
                              symbol: widget.nft.tradingAsset!,
                              accuracy: currency.accuracy,
                            ),
                            style: sTextH2Style,
                          ),
                          Text(
                            volumeFormat(
                              prefix: baseCurrency.prefix,
                              decimal: currency.currentPrice * nftPrice,
                              symbol: baseCurrency.symbol,
                              accuracy: baseCurrency.accuracy,
                            ),
                            style: sSubtitle3Style,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (!widget.userNFT) ...[
                    const SpaceH12(),
                    const SDivider(),
                    const SpaceH32(),
                  ] else ...[
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 32),
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 18,
                        bottom: 25,
                      ),
                      decoration: BoxDecoration(
                        color: colors.grey5,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SStatsIcon(),
                              const SpaceW14(),
                              Text(
                                intl.nft_collection_my_stats,
                                style: sSubtitle3Style,
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {},
                                child: const SIndexHistoryIcon(),
                              ),
                            ],
                          ),
                          const SpaceH20(),
                          Row(
                            children: [
                              Text(
                                intl.nft_collection_owned_since,
                                style: sBodyText2Style.copyWith(
                                  color: colors.grey2,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                DateFormat('yMMMd')
                                    .format(widget.nft.ownerChangedAt!),
                                style: sBodyText1Style,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  Text(
                    intl.nft_detail_nft_features,
                    style: sTextH4Style,
                  ),
                  const SpaceH20(),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            intl.nft_detail_creation_date,
                            style: sBodyText2Style.copyWith(
                              color: colors.grey2,
                            ),
                          ),
                          Text(
                            DateFormat('yMMMd').format(
                              store.nft!.mintDate!,
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
                          Text(
                            intl.nft_detail_rarity,
                            style: sBodyText2Style.copyWith(
                              color: colors.grey2,
                            ),
                          ),
                          Text(
                            '${store.nft?.rarityId ?? 1}/10 (Very rare)',
                            style: sBodyText1Style,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SpaceH12(),
                  const SDivider(),
                  const SpaceH25(),
                  Text(
                    intl.nft_detail_collection,
                    style: sBodyText2Style.copyWith(
                      color: colors.grey2,
                    ),
                  ),
                  ClickableUnderlinedText(
                    text: collection.name ?? '',
                    onTap: () {
                      sRouter.push(
                        NftCollectionDetailsRouter(nft: collection),
                      );
                    },
                  ),
                  const SpaceH32(),
                  const SDivider(),
                  const SpaceH32(),
                  NFTAboutBlock(
                    description: store.description,
                    shortDescription: store.shortDescription,
                  ),
                  const SpaceH16(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
