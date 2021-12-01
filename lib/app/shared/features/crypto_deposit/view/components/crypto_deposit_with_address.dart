import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../helpers/short_address_form.dart';
import '../../../../models/currency_model.dart';
import '../../notifier/crypto_deposit_notipod.dart';
import '../../notifier/crypto_deposit_union.dart';

class CryptoDepositWithAddress extends HookWidget {
  const CryptoDepositWithAddress({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final deposit = useProvider(cryptoDepositNotipod(currency.symbol));

    return Expanded(
      child: Column(
        children: [
          const Spacer(),
          SQrCodeBox(
            loading: deposit.union is Loading,
            data: deposit.address,
          ),
          const Spacer(),
          SAddressFieldWithCopy(
            header: '${currency.symbol} Wallet address',
            value: shortAddressForm(deposit.address),
            realValue: deposit.address,
            afterCopyText: 'Address copied',
            valueLoading: deposit.union is Loading,
          ),
        ],
      ),
    );
  }
}
