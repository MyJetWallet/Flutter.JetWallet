import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../models/currency_model.dart';

void showBuyOptions(BuildContext context, CurrencyModel currency) {
  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    pinned: const SBottomSheetHeader(
      name: 'Pay from',
    ),
    children: [
      _BuyOptions(
        currency: currency,
      ),
    ],
  );
}

class _BuyOptions extends HookWidget {
  const _BuyOptions({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    debugPrint(currency.toString(), wrapWidth: 1024);

    return Column(
      children: [
        SActionItem(
          icon: const SActionDepositIcon(),
          name: 'Bank Card - Simplex',
          description: 'Visa, Mastercard, Apple Pay',
          helper: 'Fee 3.5%',
          onTap: () {},
        ),
        const SpaceH40(),
      ],
    );
  }
}
