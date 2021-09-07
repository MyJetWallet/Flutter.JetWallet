import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../components/asset_tile/asset_tile.dart';
import '../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../currency_withdraw/view/currency_withdraw.dart';

class ActionWithdraw extends HookWidget {
  const ActionWithdraw({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      header: 'Choose asset to withdraw',
      onBackButton: () => Navigator.pop(context),
      child: ListView(
        children: [
          for (final currency in context.read(currenciesPod))
            if (currency.isAssetBalanceNotEmpty)
              AssetTile(
                headerColor: Colors.black,
                currency: currency,
                onTap: () {
                  navigatorPush(
                    context,
                    CurrencyWithdraw(
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
