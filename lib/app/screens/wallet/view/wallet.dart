import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/components/loader.dart';
import '../../../../shared/components/spacers.dart';
import '../provider/converter_map_fpod.dart';
import '../provider/currencies_pod.dart';
import 'components/currencies_header.dart';
import 'components/currency_button/currency_button.dart';
import 'components/wallet_balance.dart';

class Wallet extends HookWidget {
  const Wallet();

  @override
  Widget build(BuildContext context) {
    final currencies = useProvider(currenciesPod);
    final converter = useProvider(converterMapFpod);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 12.h,
      ),
      child: converter.when(
        data: (data) {
          return ListView(
            children: [
              WalletBalance(currencies),
              const SpaceH15(),
              const CurrenciesHeader(),
              for (final i in currencies) CurrencyButton(currency: i)
            ],
          );
        },
        loading: () => const Loader(),
        error: (e, _) => Text('$e'),
      ),
    );
  }
}
