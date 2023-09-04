import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/indices_model.dart';

import '../index_overview_block/components/index_allocation_item.dart';

class IndexAllocationBlock extends StatelessObserverWidget {
  const IndexAllocationBlock({
    super.key,
    required this.marketItem,
  });

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final indicesDetails = sSignalRModules.indicesDetails;
    final indexDetails = _indexDetailsFrom(indicesDetails);

    return indexDetails != null
        ? SPaddingH24(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SBaselineChild(
                  baseline: 56,
                  child: Text(
                    intl.indexAllocationBlock_indexAllocation,
                    style: sTextH4Style,
                  ),
                ),
                const SpaceH24(),
                for (final basketAsset in indexDetails.basketAssets) ...[
                  IndexAllocationItem(basketAssetModel: basketAsset),
                ],
                const SpaceH32(),
                const SDivider(),
                const SpaceH25(),
              ],
            ),
          )
        : const SpaceH25();
  }

  IndexModel? _indexDetailsFrom(List<IndexModel> indicesDetails) {
    if (indicesDetails.isNotEmpty) {
      return indicesDetails
          .firstWhere((element) => element.symbol == marketItem.symbol);
    }

    return null;
  }
}
