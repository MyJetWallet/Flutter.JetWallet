import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';

void showDepositOptions(
  BuildContext context,
  CurrencyModel currency,
) {
  Navigator.pop(context);

  sShowBasicModalBottomSheet(
    context: context,
    pinned: SBottomSheetHeader(
      name: intl.depositOptions_depositWith,
    ),
    children: [
      _DepositOptions(
        currency: currency,
      ),
    ],
  );
}

class _DepositOptions extends StatelessObserverWidget {
  const _DepositOptions({
    super.key,
    required this.currency,
  });

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (currency.supportsCardDeposit)
          SActionItem(
            icon: const SActionBuyIcon(),
            name: intl.depositOptions_addBankCard,
            description: intl.depositOptions_actionItemDescription1,
            helper: '${intl.fee} 3.5%',
            onTap: () {
              // TODO add Deposit with Bank
            },
          ),
        if (currency.supportsSepaDeposit)
          SActionItem(
            icon: const SActionDepositIcon(),
            name: intl.depositOptions_wireTransfer,
            description: intl.depositOptions_actionItemDescription2,
            helper: intl.noFee,
            onTap: () {
              // TODO add Deposit with Bank
            },
          ),
        const SpaceH40(),
      ],
    );
  }
}
