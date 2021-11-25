import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../models/currency_model.dart';

void showDepositOptions(BuildContext context, CurrencyModel currency) {
  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    pinned: const SBottomSheetHeader(
      name: 'Deposit With',
    ),
    children: [
      _DepositOptions(
        currency: currency,
      ),
    ],
  );
}

class _DepositOptions extends StatelessWidget {
  const _DepositOptions({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SActionItem(
          icon: const SActionBuyIcon(),
          name: 'Add bank card',
          description: 'Visa, Mastercard',
          helper: 'Fee 3.5%',
          onTap: () {
            // TODO add Deposit with Bank
          },
        ),
        SActionItem(
          icon: const SActionDepositIcon(),
          name: 'Wire transfer',
          description: 'Sepa',
          helper: 'No fee',
          onTap: () {
            // TODO add Deposit with Bank
          },
        ),
        const SpaceH40(),
      ],
    );
  }
}
