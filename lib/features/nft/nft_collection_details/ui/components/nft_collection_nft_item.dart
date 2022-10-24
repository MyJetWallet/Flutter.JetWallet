import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

class NFTCollectionNftItem extends StatelessWidget {
  const NFTCollectionNftItem({
    super.key,
    this.onTap,
    this.showBuyInfo = false,
    this.showDivider = true,
    required this.nft,
  });

  final NftMarket nft;
  final Function()? onTap;
  final bool showBuyInfo;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    bool isNameGrey = nft.sellPrice == null && !showBuyInfo;

    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image(),
          const SizedBox(
            height: 7,
          ),
          Text(
            nft.name ?? '',
            style: sSubtitle3Style.copyWith(
              color: !isNameGrey ? colors.black : colors.grey1,
            ),
          ),
          if (nft.sellPrice != null && !showBuyInfo) ...[
            const SizedBox(
              height: 3,
            ),
            Row(
              children: [
                SNetworkSvg24(
                  url: iconUrlFrom(assetSymbol: nft.sellAsset ?? ''),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  nft.sellPrice.toString(),
                  style: sSubtitle2Style,
                ),
              ],
            ),
          ] else if (showBuyInfo) ...[
            const SizedBox(
              height: 3,
            ),
            Row(
              children: [
                SNetworkSvg24(
                  url: iconUrlFrom(assetSymbol: nft.tradingAsset ?? ''),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  nft.buyPrice.toString(),
                  style: sSubtitle2Style,
                ),
              ],
            ),
          ],
          const SizedBox(
            height: 8,
          ),
          if (showDivider) ...[
            const SDivider(),
          ],
        ],
      ),
    );
  }

  Widget image() {
    /*
    return Image.network(
      '$shortUrl${nft.sImage}',
      height: 154,
      width: 154,
    );
    */

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: '$shortUrl${nft.sImage}',
        /*
        imageBuilder: (context, imageProvider) => DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        */
        imageBuilder: (context, imageProvider) {
          return Container(
            width: double.infinity,
            height: 150,
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
