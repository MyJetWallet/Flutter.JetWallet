import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';

class WalletCardCollapsed extends StatelessObserverWidget {
  const WalletCardCollapsed({
    super.key,
    required this.currency,
  });

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;
    final isInProgress = currency.assetBalance == Decimal.zero && currency.isPendingDeposit;

    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const SpaceH120(),
          SBaselineChild(
            baseline: 40,
            child: Text(
              isInProgress
                  ? '${intl.walletCardCollapsed_balanceInProcess}...'
                  : currency.volumeBaseBalance(baseCurrency),
              style: sTextH5Style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (!isInProgress)
            SBaselineChild(
              baseline: 20,
              child: Text(
                currency.volumeAssetBalance,
                style: sBodyText2Style.copyWith(
                  color: colors.grey1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
