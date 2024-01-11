import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../utils/models/currency_model.dart';

class MyWallet extends StatelessObserverWidget {
  const MyWallet({
    super.key,
    required this.currency,
  });

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {

    final colors = sKit.colors;

    return Container(
      padding: const EdgeInsets.only(left: 6, right: 8, bottom: 3, top: 4),
      decoration: BoxDecoration(
        color: colors.grey5,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SIWalletIcon(
            width: 15,
            height: 15,
          ),
          const SpaceW4(),
          Text(
            volumeFormat(
              decimal: sSignalRModules.investWalletData?.balance ?? Decimal.zero,
              accuracy: 2,
              symbol: currency.symbol,
            ),
            style: sBody1InvestBStyle.copyWith(
              color: colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
