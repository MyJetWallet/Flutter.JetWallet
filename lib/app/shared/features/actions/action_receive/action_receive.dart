import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../crypto_deposit/view/crypto_deposit.dart';
import '../helper/action_bottom_sheet_header.dart';
import '../provider/action_buy_filtered_stpod.dart';

void showReceiveAction(BuildContext context) {
  final actionBuyFiltered = context.read(actionBuyFilteredStpod);
  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const ActionBottomSheetHeader(
      name: 'Choose asset to receive',
    ),
    horizontalPinnedPadding: 0.0,
    onDissmis: () => actionBuyFiltered.state = '',
    removePinnedPadding: true,
    children: [const _ActionReceive()],
  );
}

class _ActionReceive extends HookWidget {
  const _ActionReceive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencies = useProvider(currenciesPod);
    final actionBuyFiltered = useProvider(actionBuyFilteredStpod);

    if (actionBuyFiltered.state.isNotEmpty) {
      final search = actionBuyFiltered.state.toLowerCase();

      currencies.removeWhere(
        (element) =>
            !(element.description.toLowerCase()).contains(search) &&
            !(element.symbol.toLowerCase()).contains(search),
      );
    }

    return Column(
      children: [
        for (final currency in currencies)
          if (currency.type == AssetType.crypto)
            if (currency.supportsCryptoDeposit)
              SWalletItem(
                icon: SNetworkSvg24(
                  url: currency.iconUrl,
                ),
                primaryText: currency.description,
                secondaryText: currency.symbol,
                onTap: () {
                  sAnalytics.depositCryptoView(currency.description);

                  actionBuyFiltered.state = '';

                  navigatorPushReplacement(
                    context,
                    CryptoDeposit(
                      header: 'Receive',
                      currency: currency,
                    ),
                  );
                },
              ),
      ],
    );
  }
}
