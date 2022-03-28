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
import '../notifier/action_search_notipod.dart';

void showReceiveAction(BuildContext context) {
  final notifier = context.read(actionSearchNotipod.notifier);
  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: ActionBottomSheetHeader(
      name: 'Choose asset to receive',
      onChange: (String value) {
        notifier.search(value);
      },
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [const _ActionReceive()],
  );
}

class _ActionReceive extends HookWidget {
  const _ActionReceive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useProvider(currenciesPod);
    final state = useProvider(actionSearchNotipod);

    return Column(
      children: [
        for (final currency in state.filteredCurrencies)
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
