import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

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
          Assets.svg.invest.investWallet.simpleSvg(
            width: 15,
            height: 15,
          ),
          const SpaceW4(),
          Text(
            getIt<AppStore>().isBalanceHide
                ? '**** ${currency.symbol}'
                : (sSignalRModules.investWalletData?.balance ?? Decimal.zero).toFormatCount(
                    accuracy: 2,
                    symbol: currency.symbol,
                  ),
            style: STStyles.body1InvestB.copyWith(
              color: colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
