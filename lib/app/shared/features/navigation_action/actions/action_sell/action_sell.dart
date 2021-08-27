import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../components/asset_tile/asset_tile.dart';
import '../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../currency_sell/view/currency_sell.dart';

class ActionSell extends HookWidget {
  const ActionSell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      header: 'Choose asset to sell',
      onBackButton: () => Navigator.pop(context),
      child: ListView(
        children: [
          for (final currency in context.read(currenciesPod))
            if (currency.isAssetBalanceNotEmpty)
              AssetTile(
                enableBalanceColumn: false,
                headerColor: Colors.black,
                currency: currency,
                onTap: () {
                  navigatorPush(
                    context,
                    CurrencySell(
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
