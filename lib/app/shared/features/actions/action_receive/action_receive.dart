import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../components/asset_tile/asset_tile.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../currency_deposit/view/currency_deposit.dart';

class ActionReceive extends StatelessWidget {
  const ActionReceive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      header: 'Choose asset to receive',
      onBackButton: () => Navigator.pop(context),
      child: ListView(
        children: [
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
                        header: 'Receive',
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
