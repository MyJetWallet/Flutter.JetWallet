import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';
import '../../../../models/currency_model.dart';

void showDepositOptions(
  BuildContext context,
  CurrencyModel currency,
) {
  final intl = context.read(intlPod);
  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    pinned: SBottomSheetHeader(
      name: intl.depositOptions_bottomSheetHeaderText1,
    ),
    children: [
      _DepositOptions(
        currency: currency,
      ),
    ],
  );
}

class _DepositOptions extends HookWidget {
  const _DepositOptions({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return Column(
      children: [
        if (currency.supportsCardDeposit)
          SActionItem(
            icon: const SActionBuyIcon(),
            name: intl.addBankCard,
            description: intl.depositOptions_actionItemDescription1,
            helper: '${intl.fee} 3.5%',
            onTap: () {
              // TODO add Deposit with Bank
            },
          ),
        if (currency.supportsSepaDeposit)
          SActionItem(
            icon: const SActionDepositIcon(),
            name: intl.wireTransfer,
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
