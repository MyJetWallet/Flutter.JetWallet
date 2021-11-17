import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/features/market_details/view/market_details.dart';
import '../../../../../../shared/helpers/format_currency_amount.dart';
import '../../../../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import '../../../../model/market_item_model.dart';

class MarketList extends HookWidget {
  const MarketList({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<MarketItemModel> items;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);

    return ListView.builder(
      itemCount: items.length,
      padding: EdgeInsets.only(bottom: 66.h),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];

        return SMarketItem(
          icon: NetworkSvgW24(
            url: item.iconUrl,
          ),
          name: item.name,
          price: formatCurrencyAmount(
            prefix: baseCurrency.prefix,
            value: item.lastPrice,
            symbol: baseCurrency.symbol,
            accuracy: baseCurrency.accuracy,
          ),
          ticker: item.id,
          percent: item.dayPercentChange,
          onTap: () {
            navigatorPush(
              context,
              MarketDetails(
                marketItem: item,
              ),
            );
          },
        );
      },
    );
  }
}
