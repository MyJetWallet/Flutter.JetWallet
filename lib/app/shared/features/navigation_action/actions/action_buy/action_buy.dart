import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../screens/market/provider/currencies_pod.dart';
import '../../../../components/asset_tile/asset_tile.dart';
import '../../../currency_buy/view/curency_buy.dart';

class ActionBuy extends HookWidget {
  const ActionBuy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      header: 'Choose a crypto to buy',
      onBackButton: () => Navigator.pop(context),
      child: ListView(
        children: [
          for (final currency in context.read(currenciesPod))
            AssetTile(
              priceColumn: false,
              headerColor: Colors.black,
              currency: currency,
              onTap: () {
                navigatorPush(
                  context,
                  CurrencyBuy(
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
