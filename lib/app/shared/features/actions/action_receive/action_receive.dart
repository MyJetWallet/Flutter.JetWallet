import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../crypto_deposit/view/crypto_deposit.dart';
import '../helper/action_bottom_sheet_header.dart';
import '../notifier/currencies_notipod.dart';

void showReceiveAction(BuildContext context) {
  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const ActionBottomSheetHeader(
      name: 'Choose asset to receive',
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
    final state = useProvider(currenciesNotipod);

    return Column(
      children: [
        for (final currency in state)
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
