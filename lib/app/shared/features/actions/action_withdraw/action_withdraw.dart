import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../helper/action_bottom_sheet_header.dart';
import '../provider/action_buy_filtered_stpod.dart';
import 'components/withdraw_options.dart';

void showWithdrawAction(BuildContext context) {
  final actionBuyFiltered = context.read(actionBuyFilteredStpod);
  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const ActionBottomSheetHeader(
      name: 'Choose asset to withdraw',
    ),
    horizontalPinnedPadding: 0.0,
    onDissmis: () => actionBuyFiltered.state = '',
    removePinnedPadding: true,
    children: [const _ActionWithdraw()],
  );
}

class _ActionWithdraw extends HookWidget {
  const _ActionWithdraw({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);
    final currencies = useProvider(currenciesPod);
    final actionBuyFiltered = useProvider(actionBuyFilteredStpod);

    if (actionBuyFiltered.state.isNotEmpty) {
      final search = actionBuyFiltered.state.toLowerCase();

      currencies.removeWhere(
        (element) =>
            !(element.description.toLowerCase()).startsWith(search) &&
            !(element.symbol.toLowerCase()).startsWith(search),
      );
    }

    return Column(
      children: [
        for (final currency in currencies)
          if (currency.isAssetBalanceNotEmpty)
            if (currency.supportsAtLeastOneWithdrawalMethod)
              SWalletItem(
                decline: currency.dayPercentChange.isNegative,
                icon: SNetworkSvg24(
                  url: currency.iconUrl,
                ),
                primaryText: currency.description,
                amount: currency.volumeBaseBalance(baseCurrency),
                secondaryText: currency.volumeAssetBalance,
                onTap: () {
                  actionBuyFiltered.state = '';
                  showWithdrawOptions(context, currency);
                },
              ),
      ],
    );
  }
}
