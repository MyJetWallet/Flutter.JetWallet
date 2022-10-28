import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/about_block/components/clickable_underlined_text.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/nft_detail_bottom_bar/nft_detail_bottom_bar.dart';
import 'package:jetwallet/features/nft/helper/get_rarity_nft.dart';
import 'package:jetwallet/features/nft/nft_details/store/nft_detail_store.dart';
import 'package:jetwallet/features/nft/nft_details/ui/components/nft_about_block.dart';
import 'package:jetwallet/features/nft/nft_details/ui/components/nft_detail_header.dart';
import 'package:jetwallet/features/nft/nft_details/ui/components/nft_full_image.dart';
import 'package:jetwallet/features/wallet/ui/widgets/action_button/action_button.dart';
import 'package:jetwallet/features/wallet/ui/widgets/action_button/action_button_nft.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../core/services/user_info/user_info_service.dart';
import '../../../../utils/constants.dart';
import 'components/nft_terms_alert.dart';

class NFTDetailsScreen extends StatelessWidget {
  const NFTDetailsScreen({
    super.key,
    this.userNFT = false,
    //required this.nft,
    required this.nftSymbol,
  });

  final bool userNFT;
  //final NftMarket nft;
  final String nftSymbol;

  @override
  Widget build(BuildContext context) {
    return Provider<NFTDetailStore>(
      create: (context) => NFTDetailStore()..init(nftSymbol),
      builder: (context, child) => _NFTDetailsScreenBody(
        userNFT: userNFT,
      ),
    );
  }
}

class _NFTDetailsScreenBody extends StatefulObserverWidget {
  const _NFTDetailsScreenBody({
    super.key,
    this.userNFT = false,
  });

  final bool userNFT;

  @override
  State<_NFTDetailsScreenBody> createState() => _NFTDetailsScreenBodyState();
}

class _NFTDetailsScreenBodyState extends State<_NFTDetailsScreenBody>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  ScrollController scrollController = ScrollController();

  bool showImage = true;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    scrollController.addListener(scrollControllerListener);

    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollControllerListener);
    super.dispose();
  }

  void scrollControllerListener() {
    setState(() {
      showImage = scrollController.offset >= 160 ? false : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;

    final store = NFTDetailStore.of(context);

    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      store.nft?.tradingAsset ?? '',
    );

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
        ? store.nft!.sellPrice != null
            ? store.nft!.sellPrice!
            : store.nft!.buyPrice!
        : store.nft!.sellPrice!;

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
                  nft: store.nft!,
                )
          : NFTDetailBottomBar(
              userNFT: widget.userNFT,
              nft: store.nft!,
              onTap: () async {
                final userInfo = getIt.get<UserInfoService>().userInfo;

                if (userInfo.hasNftDisclaimers) {
                  await store.initNftDisclaimer();
                  if (store.send) {
                    await store.clickBuy(context);
                  } else {
                    sShowNftTermsAlertPopup(
                      context,
                      store as NFTDetailStore,
                      willPopScope: false,
                      image: Image.asset(
                        disclaimerAsset,
                        width: 80,
                        height: 80,
                      ),
                      primaryText: intl.nft_disclaimer_title,
                      secondaryText: intl.nft_disclaimer_firstText,
                      secondaryText2: intl.nft_disclaimer_terms,
                      secondaryText3: intl.nft_disclaimer_secondText,
                      primaryButtonName: intl.earn_terms_continue,
                      onPrivacyPolicyTap: () {
                        sRouter.navigate(
                          HelpCenterWebViewRouter(
                            link: nftTermsLink,
                          ),
                        );
                      },
                      onPrimaryButtonTap: () {
                        store.sendAnswers(
                              () {
                            Navigator.pop(context);
                            store.clickBuy(context);
                          },
                        );
                      },
                      child: const SizedBox(),
                    );
                  }
                } else {
                  await store.clickBuy(context);
                }
              },
            ),
      child: SShadeAnimationStack(
        showShade: getIt.get<AppStore>().actionMenuActive,
        child: CustomScrollView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: colors.white,
              pinned: true,
              stretch: true,
              elevation: 0,
              expandedHeight: 180,
              collapsedHeight: 100,
              floating: true,
              automaticallyImplyLeading: false,
              flexibleSpace: SPaddingH24(
                child: NFTDetailHeader(
                  title: store.nft!.name ?? '',
                  fImage: '$shortUrl${store.nft!.sImage}',
                  showImage: showImage,
                ),
              ),
            ),

            /*
              flexibleSpace: FlexibleSpaceBar(
                title: Align(
                  child: SizedBox(
                    width: max(
                      100,
                      280 -
                          (scrollController.hasClients
                              ? scrollController.offset * 0.4
                              : 0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Image(
                          image: NetworkImage('$shortUrl${store.nft!.sImage}'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            */
            SliverToBoxAdapter(
              child: SPaddingH24(
                child: Column(
                  children: [
                    const SpaceH26(),
                    if (mounted) ...[
                      Opacity(
                        opacity: showImage ? 1 : 0,
                        child: SizedBox(
                          width: max(
                            48,
                            327 -
                                (scrollController.hasClients
                                    ? scrollController.offset * 1.3
                                    : 0),
                          ),
                          height: max(
                            48,
                            327 -
                                (scrollController.hasClients
                                    ? scrollController.offset * 1.3
                                    : 0),
                          ),
                          child: STransparentInkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  opaque: false,
                                  barrierColor: Colors.black,
                                  pageBuilder: (BuildContext context, _, __) {
                                    return FullScreenPage(
                                      dark: true,
                                      child: PhotoView(
                                        filterQuality: FilterQuality.high,
                                        initialScale:
                                            PhotoViewComputedScale.contained *
                                                1.7,
                                        imageProvider: NetworkImage(
                                          '$fullUrl${store.nft!.fImage}',

                                          //fit: BoxFit.cover,
                                          //height: double.infinity,
                                          //width: double.infinity,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CachedNetworkImage(
                                imageUrl: '$fullUrl${store.nft!.fImage}',
                                cacheManager: CacheManager(
                                  Config(
                                    '$fullUrl${store.nft!.fImage}',
                                    stalePeriod: const Duration(hours: 10),
                                    maxNrOfCacheObjects: 1,
                                  ),
                                ),
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    width: double.infinity,
                                    height: 327,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                                placeholder: (context, url) =>
                                    const SSkeletonTextLoader(
                                  height: 327,
                                  width: 327,
                                ),
                                errorWidget: (context, url, error) =>
                                    const SSkeletonTextLoader(
                                  height: 327,
                                  width: 327,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SpaceH19(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: SNetworkSvg24(
                            url: iconUrlFrom(
                              assetSymbol: store.nft!.tradingAsset!,
                            ),
                          ),
                        ),
                        const SpaceW6(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Baseline(
                              baseline: 40,
                              baselineType: TextBaseline.alphabetic,
                              child: Text(
                                volumeFormat(
                                  decimal: nftPrice,
                                  symbol: store.nft!.tradingAsset!,
                                  accuracy: currency.accuracy,
                                ),
                                style: sTextH2Style,
                              ),
                            ),
                            Baseline(
                              baseline: 24,
                              baselineType: TextBaseline.alphabetic,
                              child: Text(
                                volumeFormat(
                                  prefix: baseCurrency.prefix,
                                  decimal: currency.currentPrice * nftPrice,
                                  symbol: baseCurrency.symbol,
                                  accuracy: baseCurrency.accuracy,
                                ),
                                style: sSubtitle3Style,
                              ),
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
                                  onTap: () {
                                    sRouter.push(
                                      TransactionHistoryRouter(
                                        initialIndex: 2,
                                      ),
                                    );
                                  },
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
                                      .format(store.nft!.ownerChangedAt!),
                                  style: sBodyText1Style,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Baseline(
                        baseline: 28.84,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          intl.nft_detail_nft_features,
                          style: sTextH4Style,
                        ),
                      ),
                    ),
                    const SpaceH20(),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Baseline(
                              baseline: 21,
                              baselineType: TextBaseline.alphabetic,
                              child: Text(
                                intl.nft_detail_creation_date,
                                style: sBodyText2Style.copyWith(
                                  color: colors.grey2,
                                ),
                              ),
                            ),
                            const SpaceH1(),
                            Baseline(
                              baseline: 24,
                              baselineType: TextBaseline.alphabetic,
                              child: Text(
                                DateFormat('yMMMd').format(
                                  store.nft!.mintDate!,
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
                                intl.nft_detail_rarity,
                                style: sBodyText2Style.copyWith(
                                  color: colors.grey2,
                                ),
                              ),
                            ),
                            const SpaceH1(),
                            Baseline(
                              baseline: 24,
                              baselineType: TextBaseline.alphabetic,
                              child: Text(
                                '${store.nft?.rarityId ?? 1}/${collection.nftList.length} (${getNFTRarity(store.nft?.rarityId ?? 1)})',
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Baseline(
                        baseline: 21,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          intl.nft_detail_collection,
                          style: sBodyText2Style.copyWith(
                            color: colors.grey2,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClickableUnderlinedText(
                        text: collection.name ?? '',
                        onTap: () {
                          sRouter.push(
                            NftCollectionDetailsRouter(
                              collectionID: collection.id!,
                            ),
                          );
                        },
                      ),
                    ),
                    if (store.description.isNotEmpty) ...[
                      const SpaceH32(),
                      const SDivider(),
                      const SpaceH32(),
                      NFTAboutBlock(
                        description: store.description,
                        shortDescription: store.shortDescription,
                      ),
                    ],
                    const SpaceH16(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
