import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../service/services/signal_r/model/indices_model.dart';
import '../../../../../../../screens/market/provider/market_items_pod.dart';
import '../../../../../wallet/helper/market_item_from.dart';

class IndexAllocationItem extends HookWidget {
  const IndexAllocationItem({
    Key? key,
    required this.basketAssetModel,
  }) : super(key: key);

  final BasketAssetModel basketAssetModel;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final marketItem = marketItemFrom(
      useProvider(marketItemsPod),
      basketAssetModel.symbol,
    );
    final targetRebalanceWeightPercent =
        (basketAssetModel.targetRebalanceWeight * 100).toInt();

    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: SNetworkSvg24(
              url: marketItem.iconUrl,
            ),
          ),
          const SpaceW10(),
          SBaselineChild(
            baseline: 26,
            child: Text(
              '${marketItem.name} (${marketItem.id})',
              style: sBodyText1Style.copyWith(color: colors.grey1),
            ),
          ),
          const Spacer(),
          SBaselineChild(
            baseline: 26,
            child: Text(
              '$targetRebalanceWeightPercent%',
              style: sBodyText1Style.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
