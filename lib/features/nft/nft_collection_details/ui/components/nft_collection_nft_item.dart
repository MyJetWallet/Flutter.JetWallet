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
    required this.height,
    required this.nft,
  });

  final NftMarket nft;
  final Function() onTap;
  final bool showBuyInfo;
  final bool showDivider;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    bool isNameGrey = nft.sellPrice == null && !showBuyInfo;

    return STransparentInkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          image(height),
          const SpaceH6(),
          Text(
            nft.name ?? '',
            style: sSubtitle3Style.copyWith(
              leadingDistribution: TextLeadingDistribution.even,
              textBaseline: TextBaseline.alphabetic,
              color: !isNameGrey ? colors.black : colors.grey1,
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
                Text(
                  nft.sellPrice.toString(),
                  style: sSubtitle2Style.copyWith(
                    leadingDistribution: TextLeadingDistribution.even,
                    textBaseline: TextBaseline.alphabetic,
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
                Text(
                  nft.buyPrice.toString(),
                  style: sSubtitle2Style.copyWith(
                    leadingDistribution: TextLeadingDistribution.even,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
              ],
            ),
          ],
          if (nft.sellPrice != null && !showBuyInfo || showBuyInfo) ...[
            const SpaceH20(),
          ] else ...[
            const SpaceH13(),
          ],
          if (showDivider) ...[
            const SDivider(),
          ],
        ],
      ),
    );
  }

  Widget image(double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: '$shortUrl${nft.sImage}',
        imageBuilder: (context, imageProvider) {
          return Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,
              ),
            ),
          );
        },
        placeholder: (context, url) => SSkeletonTextLoader(
          height: height,
          width: double.infinity,
        ),
        errorWidget: (context, url, error) => SSkeletonTextLoader(
          height: height,
          width: double.infinity,
        ),
      ),
    );
  }
}
