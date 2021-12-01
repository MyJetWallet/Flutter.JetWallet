import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../crypto_deposit/view/crypto_deposit.dart';
import 'components/deposit_category_description.dart';
import 'components/deposit_options.dart';

void showDepositAction(BuildContext context) {
  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    maxHeight: 664.h,
    pinned: const SBottomSheetHeader(
      name: 'Choose asset to deposit',
    ),
    children: [const _ActionDeposit()],
  );
}

class _ActionDeposit extends HookWidget {
  const _ActionDeposit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencies = useProvider(currenciesPod);
    final lastFiat = currencies.lastWhere((e) => e.type == AssetType.fiat);
    final lastCrypto = currencies.lastWhere((e) => e.type == AssetType.crypto);

    return Column(
      children: [
        const DepositCategoryDescription(
          text: 'Fiat',
        ),
        for (final currency in currencies)
          if (currency.type == AssetType.fiat)
            SWalletItem(
              removeDivider: lastFiat.symbol == currency.symbol,
              icon: NetworkSvgW24(
                url: currency.iconUrl,
              ),
              primaryText: currency.description,
              secondaryText: '${currency.assetBalance} ${currency.symbol}',
              onTap: () {
                showDepositOptions(context, currency);
              },
            ),
        const DepositCategoryDescription(
          text: 'Crypto',
        ),
        for (final currency in currencies)
          if (currency.type == AssetType.crypto)
            if (currency.depositMethods.contains(DepositMethods.cryptoDeposit))
              SWalletItem(
                removeDivider: lastCrypto.symbol == currency.symbol,
                icon: NetworkSvgW24(
                  url: currency.iconUrl,
                ),
                primaryText: currency.description,
                secondaryText: '${currency.assetBalance} ${currency.symbol}',
                onTap: () {
                  navigatorPushReplacement(
                    context,
                    CryptoDeposit(
                      header: 'Deposit',
                      currency: currency,
                    ),
                  );
                },
              ),
      ],
    );
  }
}
