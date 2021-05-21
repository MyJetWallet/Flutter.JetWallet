import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/components/loader.dart';
import '../../../../shared/components/spacers.dart';
import '../providers/assets_with_balances_pod.dart';
import '../providers/server_time_spod.dart';
import 'components/currencies_header.dart';
import 'components/currency_button/currency_button.dart';
import 'components/wallet_balance.dart';

class Wallet extends HookWidget {
  const Wallet();

  @override
  Widget build(BuildContext context) {
    final serverTimeStream = useProvider(serverTimeSpod);
    final assetsWithBalances = useProvider(assetsWithBalancesPod);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        children: [
          WalletBalance(),
          const SpaceH20(),
          serverTimeStream.when(
            data: (data) {
              return Text('Server time: ${data.now}');
            },
            loading: () => Loader(),
            error: (e, st) => Text('$e'),
          ),
          const CurrenciesHeader(),
          for (final asset in assetsWithBalances)
            CurrencyButton(currency: asset)
        ],
      ),
    );
  }
}
