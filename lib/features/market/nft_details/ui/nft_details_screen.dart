import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/about_block/components/clickable_underlined_text.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/nft_detail_bottom_bar/nft_detail_bottom_bar.dart';
import 'package:jetwallet/features/market/nft_details/store/nft_detail_store.dart';
import 'package:jetwallet/features/market/nft_details/ui/components/nft_detail_header.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

class NFTDetailsScreen extends StatelessWidget {
  const NFTDetailsScreen({
    super.key,
    required this.nft,
  });

  final NftMarket nft;

  @override
  Widget build(BuildContext context) {
    return Provider<NFTDetailStore>(
      create: (context) => NFTDetailStore(),
      builder: (context, child) => _NFTDetailsScreenBody(
        nft: nft,
      ),
    );
  }
}

class _NFTDetailsScreenBody extends StatelessWidget {
  const _NFTDetailsScreenBody({
    super.key,
    required this.nft,
  });

  final NftMarket nft;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;

    return SPageFrame(
      bottomNavigationBar: NFTDetailBottomBar(
        nft: nft,
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
            flexibleSpace: const SPaddingH24(
              child: NFTDetailHeader(),
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
                        '$fullUrl${nft.fImage}',
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
                          url: iconUrlFrom(assetSymbol: nft.sellAsset ?? ''),
                        ),
                      ),
                      const SpaceW6(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            volumeFormat(
                              decimal: Decimal.parse('${nft.sellPrice}'),
                              symbol: nft.sellAsset!,
                              accuracy: 3,
                            ),
                            style: sTextH2Style,
                          ),
                          Text(
                            volumeFormat(
                              prefix: baseCurrency.prefix,
                              decimal: Decimal.parse('${nft.sellPrice}'),
                              symbol: baseCurrency.symbol,
                              accuracy: baseCurrency.accuracy,
                            ),
                            style: sSubtitle3Style,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SpaceH12(),
                  const SDivider(),
                  const SpaceH32(),
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
                            '01 january',
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
                            '1/10 (Very rare)',
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
                    text: 'Archetype',
                    onTap: () {},
                  ),
                  const SpaceH32(),
                  const SDivider(),
                  const SpaceH32(),
                  Text(
                    intl.nft_detail_about,
                    style: sTextH4Style,
                  ),
                  const SpaceH18(),
                  Text(
                    nft.name ?? '',
                    maxLines: 3,
                    style: sBodyText1Style,
                  ),
                  const SpaceH16(),
                  ClickableUnderlinedText(
                    text: intl.nft_detail_readMore,
                    onTap: () {},
                  ),
                  const SpaceH16(),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return SPageFrame(
      header: SPaddingH24(
        child: SMegaHeader(
          titleAlign: TextAlign.start,
          title: nft.name ?? '',
          rightIcon: SIconButton(
            defaultIcon: SShareIcon(),
          ),
        ),
      ),
      //bottomNavigationBar: NFTDetailBottomBar(
      //  nft: nft,
      //),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: SPaddingH24(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FullScreenWidget(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    '$fullUrl${nft.fImage}',
                  ),
                ),
              ),
              const SpaceH19(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: SNetworkSvg24(
                      url: iconUrlFrom(assetSymbol: nft.sellAsset ?? ''),
                    ),
                  ),
                  const SpaceW6(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        volumeFormat(
                          decimal: Decimal.parse('${nft.sellPrice}'),
                          symbol: nft.sellAsset!,
                          accuracy: 3,
                        ),
                        style: sTextH2Style,
                      ),
                      Text(
                        volumeFormat(
                          prefix: baseCurrency.prefix,
                          decimal: Decimal.parse('${nft.sellPrice}'),
                          symbol: baseCurrency.symbol,
                          accuracy: baseCurrency.accuracy,
                        ),
                        style: sSubtitle3Style,
                      ),
                    ],
                  ),
                ],
              ),
              const SpaceH12(),
              const SDivider(),
              const SpaceH32(),
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
                        '01 january',
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
                        '1/10 (Very rare)',
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
                text: 'Archetype',
                onTap: () {},
              ),
              const SpaceH32(),
              const SDivider(),
              const SpaceH32(),
              Text(
                intl.nft_detail_about,
                style: sTextH4Style,
              ),
              const SpaceH18(),
              Text(
                nft.name ?? '',
                maxLines: 3,
                style: sBodyText1Style,
              ),
              const SpaceH16(),
              ClickableUnderlinedText(
                text: intl.nft_detail_readMore,
                onTap: () {},
              ),
              const SpaceH16(),
            ],
          ),
        ),
      ),
    );
  }
}
