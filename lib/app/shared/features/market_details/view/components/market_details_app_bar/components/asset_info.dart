import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../../shared/components/header_text.dart';
import '../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../screens/market/model/market_item_model.dart';
import '../../../../../../../screens/market/notifier/watchlist_notipod.dart';
import '../../../../../../components/asset_icon.dart';


class AssetInfo extends HookWidget {
  const AssetInfo({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final MarketItemModel asset;

  @override
  Widget build(BuildContext context) {
    final notifier = useProvider(watchlistIdsNotipod.notifier);
    useProvider(watchlistIdsNotipod);

    return Row(
      children: [
        AssetIcon(
          imageUrl: asset.iconUrl,
        ),
        const SpaceW8(),
        HeaderText(
          text: '${asset.name} price',
          textAlign: TextAlign.start,
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            if (notifier.isInWatchlist(asset.associateAsset)) {
              notifier.removeFromWatchlist(asset.associateAsset);
            } else {
              notifier.addToWatchlist(asset.associateAsset);
            }
          },
          child: Icon(
            notifier.isInWatchlist(asset.associateAsset)
                ? Icons.star
                : Icons.star_border,
          ),
        ),
      ],
    );
  }
}
