import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../screens/market/model/market_item_model.dart';
import '../../../../../helpers/format_currency_amount.dart';
import '../../../../../providers/base_currency_pod/base_currency_pod.dart';
import 'components/balance_action_buttons.dart';

class BalanceBlock extends HookWidget {
  const BalanceBlock({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);

    return SizedBox(
      height: 160.h,
      child: Column(
        children: [
          const SDivider(),
          SWalletItem(
            decline: marketItem.dayPercentChange.isNegative,
            icon: SNetworkSvg24(
              url: marketItem.iconUrl,
            ),
            primaryText: '${marketItem.name} wallet',
            amount: formatCurrencyAmount(
              prefix: baseCurrency.prefix,
              value: marketItem.baseBalance,
              symbol: baseCurrency.symbol,
              accuracy: baseCurrency.accuracy,
            ),
            secondaryText: '${marketItem.assetBalance} ${marketItem.id}',
            onTap: () {},
            removeDivider: true,
          ),
          BalanceActionButtons(
            marketItem: marketItem,
          ),
        ],
      ),
    );
  }
}
