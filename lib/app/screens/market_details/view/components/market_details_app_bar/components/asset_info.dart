import 'package:flutter/material.dart';

import '../../../../../../../shared/components/spacers.dart';
import '../../../../../../shared/components/asset_icon.dart';
import '../../../../../market/model/market_item_model.dart';
import '../../../../../market/view/components/header_text.dart';

class AssetInfo extends StatelessWidget {
  const AssetInfo({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final MarketItemModel asset;

  @override
  Widget build(BuildContext context) {
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
        const Icon(Icons.star),
      ],
    );
  }
}
