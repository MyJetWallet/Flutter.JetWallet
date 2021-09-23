import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../screens/market/model/market_item_model.dart';
import '../../../../../../../screens/market/provider/market_items_pod.dart';
import '../../../../../../helpers/format_asset_price_value.dart';
import '../../../../../../providers/base_currency_pod/base_currency_model.dart';
import '../../../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../../chart/notifier/chart_notipod.dart';
import '../../../../../chart/notifier/chart_state.dart';
import '../../../../../wallet/helper/market_item_from.dart';

class AssetPrice extends HookWidget {
  const AssetPrice({
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
    final baseCurrency = useProvider(baseCurrencyPod);

    return Text(
      _price(
        marketItem,
        chart,
        baseCurrency,
      ),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 35.sp,
        color: Colors.grey[800],
      ),
    );
  }

  String _price(
    MarketItemModel marketItem,
    ChartState chart,
      BaseCurrencyModel baseCurrency,
  ) {
    if (chart.selectedCandle != null) {
      return formatPriceValue(
        prefix: baseCurrency.prefix,
        value: chart.selectedCandle!.close,
        accuracy: baseCurrency.accuracy,
      );
    } else {
      return formatPriceValue(
        prefix: baseCurrency.prefix,
        value: marketItem.lastPrice,
        accuracy: baseCurrency.accuracy,
      );
    }
  }
}
