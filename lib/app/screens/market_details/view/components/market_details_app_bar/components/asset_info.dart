import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../shared/components/spacers.dart';
import '../../../../../../shared/components/asset_icon.dart';
import '../../../../../market/model/market_item_model.dart';
import '../../../../../market/provider/watchlist_notifier/watchlist_notipod.dart';
import '../../../../../market/view/components/header_text.dart';

class AssetInfo extends HookWidget {
  const AssetInfo({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final MarketItemModel asset;

  @override
  Widget build(BuildContext context) {
    final notifier = useProvider(watchlistNotipod.notifier);

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
            notifier.addToWatchlist(asset);
          },
          child: const Icon(
            Icons.star,
          ),
        ),
      ],
    );
  }
}
