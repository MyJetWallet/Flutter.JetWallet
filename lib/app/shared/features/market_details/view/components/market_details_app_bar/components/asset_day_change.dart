import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../screens/market/model/market_item_model.dart';
import '../../../../../../../screens/market/provider/market_items_pod.dart';
import '../../../../../chart/notifier/chart_notipod.dart';
import '../../../../../chart/notifier/chart_state.dart';
import '../../../../../wallet/helper/market_item_from.dart';
import '../../../../helper/period_change.dart';

class AssetDayChange extends HookWidget {
  const AssetDayChange({
    Key? key,
    required this.assetId,
  }) : super(key: key);

  final String assetId;

  @override
  Widget build(BuildContext context) {
    final marketItem = marketItemFrom(
      useProvider(marketItemsPod),
      assetId,
    );
    final chart = useProvider(chartNotipod);

    return Row(
      children: [
        Icon(
          marketItem.isGrowing ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          color: Colors.grey,
        ),
        Text(
          _dayChange(marketItem, chart),
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  String _dayChange(
    MarketItemModel marketItem,
    ChartState chart,
  ) {
    if (chart.selectedCandle != null) {
      return periodChange(
        chart: chart,
        selectedCandle: chart.selectedCandle,
        item: marketItem,
      );
    } else {
      return periodChange(
        chart: chart,
        item: marketItem,
      );
    }
  }
}
