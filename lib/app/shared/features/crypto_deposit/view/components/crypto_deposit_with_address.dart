import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/device_size/media_query_pod.dart';
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
    final mediaQuery = useProvider(mediaQueryPod);
    final deposit = useProvider(cryptoDepositNotipod(currency));

    return SizedBox(
      // Screen height minus Header, ShareButton bar, DepositInfo,
      // NetworkSelector
      height: mediaQuery.size.height - 120 - 104 - 88 - 88,
      child: Column(
        children: [
          const Spacer(),
          SQrCodeBox(
            loading: deposit.union is Loading,
            data: deposit.address,
            qrBoxSize: mediaQuery.size.width * 0.6,
            logoSize: mediaQuery.size.width * 0.24,
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
