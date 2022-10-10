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
    required this.nft,
  });

  final NftMarket nft;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SPaddingH24(
      child: InkWell(
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
                color: nft.sellPrice != null ? colors.black : colors.grey1,
              ),
            ),
            if (nft.sellPrice != null) ...[
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
            ],
            const SizedBox(
              height: 8,
            ),
            const SDivider(),
          ],
        ),
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
        /*imageBuilder: (context, imageProvider) => DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        */
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
