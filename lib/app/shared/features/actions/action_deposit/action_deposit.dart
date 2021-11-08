import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../../shared/components/spacers.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../components/asset_tile/asset_tile.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../currency_deposit/view/currency_deposit.dart';
import 'components/deposit_list_text.dart';

class ActionDeposit extends HookWidget {
  const ActionDeposit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      header: 'Deposit',
      onBackButton: () => Navigator.pop(context),
      child: ListView(
        children: [
          const SpaceH10(),
          const DepositListText(
            text: 'Fiat',
          ),
          for (final currency in context.read(currenciesPod))
            if (currency.type == AssetType.fiat)
              AssetTile(
                enableBalanceColumn: false,
                headerColor: Colors.black,
                currency: currency,
                onTap: () {
                  // TODO add Deposit for fiat
                  // can be FIAT from creditCard or CRYPTO
                  // check this
                },
              ),
          const SpaceH10(),
          const DepositListText(
            text: 'Crypto',
          ),
          for (final currency in context.read(currenciesPod))
            if (currency.type == AssetType.crypto)
              if (currency.depositMethods.contains(
                DepositMethods.cryptoDeposit,
              ))
                AssetTile(
                  enableBalanceColumn: false,
                  headerColor: Colors.black,
                  currency: currency,
                  onTap: () {
                    navigatorPush(
                      context,
                      CurrencyDeposit(
                        header: 'Deposit',
                        currency: currency,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
