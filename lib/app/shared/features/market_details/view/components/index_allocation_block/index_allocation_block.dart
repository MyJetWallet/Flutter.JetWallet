import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../service/services/signal_r/model/indices_model.dart';
import '../../../../../../screens/market/model/market_item_model.dart';
import '../../../provider/indices_details_pod.dart';
import '../index_overview_block/components/index_allocation_item.dart';

class IndexAllocationBlock extends HookWidget {
  const IndexAllocationBlock({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final indicesDetails = useProvider(indicesDetailsPod);
    final indexDetails = _indexDetailsFrom(indicesDetails);

    return SPaddingH24(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 56,
            child: Baseline(
              baseline: 49,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                'Index allocation',
                style: sTextH4Style,
              ),
            ),
          ),
          const SpaceH24(),
          for (final basketAsset in indexDetails.basketAssets) ...[
            IndexAllocationItem(
              basketAssetModel: basketAsset,
            ),
          ],
          const SpaceH32(),
          const SDivider(),
        ],
      ),
    );
  }

  IndexModel _indexDetailsFrom(List<IndexModel> indicesDetails) =>
      indicesDetails.firstWhere((element) => element.symbol == marketItem.id);
}
