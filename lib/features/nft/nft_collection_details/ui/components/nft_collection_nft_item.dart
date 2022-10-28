import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

class NFTCollectionNftItem extends StatelessWidget {
  const NFTCollectionNftItem({
    super.key,
    required this.onTap,
    this.showBuyInfo = false,
    this.showDivider = true,
    required this.nft,
  });

  final NftMarket nft;
  final Function() onTap;
  final bool showBuyInfo;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    bool isNameGrey = nft.sellPrice == null && !showBuyInfo;

    return STransparentInkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image(),
          const SpaceH7(),
          Baseline(
            baseline: 24,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              nft.name ?? '',
              style: sSubtitle3Style.copyWith(
                color: !isNameGrey ? colors.black : colors.grey1,
              ),
            ),
          ),
          if (nft.sellPrice != null && !showBuyInfo) ...[
            const SpaceH3(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SNetworkSvg24(
                  url: iconUrlFrom(assetSymbol: nft.tradingAsset ?? ''),
                ),
                const SpaceW10(),
                Baseline(
                  baseline: 28,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    nft.sellPrice.toString(),
                    style: sSubtitle2Style,
                  ),
                ),
              ],
            ),
          ] else if (showBuyInfo) ...[
            const SpaceH3(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SNetworkSvg24(
                  url: iconUrlFrom(assetSymbol: nft.tradingAsset ?? ''),
                ),
                const SpaceW10(),
                Baseline(
                  baseline: 28,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    nft.buyPrice.toString(),
                    style: sSubtitle2Style,
                  ),
                ),
              ],
            ),
          ],
          const SpaceH20(),
          if (showDivider) ...[
            const SDivider(),
          ],
        ],
      ),
    );
  }

  Widget image() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: '$shortUrl${nft.sImage}',
        imageBuilder: (context, imageProvider) {
          return Container(
            width: 154,
            height: 154,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        placeholder: (context, url) => const SSkeletonTextLoader(
          height: 154,
          width: 154,
        ),
        errorWidget: (context, url, error) => const SSkeletonTextLoader(
          height: 154,
          width: 154,
        ),
      ),
    );
  }
}
