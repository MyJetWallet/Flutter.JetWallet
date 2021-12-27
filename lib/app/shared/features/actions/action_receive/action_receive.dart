import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../crypto_deposit/view/crypto_deposit.dart';

void showReceiveAction(BuildContext context) {
  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const SBottomSheetHeader(
      name: 'Choose asset to receive',
    ),
    children: [const _ActionReceive()],
  );
}

class _ActionReceive extends HookWidget {
  const _ActionReceive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencies = useProvider(currenciesPod);

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
