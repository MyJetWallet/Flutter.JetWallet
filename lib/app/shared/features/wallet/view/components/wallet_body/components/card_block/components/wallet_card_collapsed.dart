import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../../../models/currency_model.dart';
import '../../../../../../../../providers/base_currency_pod/base_currency_pod.dart';

class WalletCardCollapsed extends HookWidget {
  const WalletCardCollapsed({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final baseCurrency = useProvider(baseCurrencyPod);
    final isInProgress = currency.assetBalance == Decimal.zero &&
        currency.isPendingDeposit;

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
              isInProgress ? '${intl.balanceInProcess_text1}...'
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
