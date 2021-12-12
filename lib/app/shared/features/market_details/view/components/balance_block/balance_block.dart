import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
      height: 156,
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
            leftBlockTopPadding: _leftBlockTopPadding(),
            balanceTopMargin: 16,
            height: 75,
            showSecondaryText: !marketItem.isBalanceEmpty,
          ),
          BalanceActionButtons(
            marketItem: marketItem,
          ),
          const SpaceH24(),
        ],
      ),
    );
  }

  double _leftBlockTopPadding() {
    if (marketItem.isBalanceEmpty) {
      return 26;
    } else {
      return 16;
    }
  }
}
