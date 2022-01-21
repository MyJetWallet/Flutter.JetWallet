import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../helpers/short_address_form.dart';
import '../../../../../models/currency_model.dart';
import '../../../notifier/crypto_deposit_notipod.dart';
import '../../../notifier/crypto_deposit_union.dart';
import 'components/deposit_with_tag_info.dart';

class CryptoDepositWithAddressAndTag extends HookWidget {
  const CryptoDepositWithAddressAndTag({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final deposit = useProvider(cryptoDepositNotipod(currency.symbol));
    final depositN = useProvider(
      cryptoDepositNotipod(currency.symbol).notifier,
    );

    return Expanded(
      child: Column(
        children: [
          DepositWithTagInfo(
            currencySymbol: currency.symbol,
          ),
          SAddressFieldWithCopy(
            header: '${currency.symbol} Wallet address',
            value: shortAddressForm(deposit.address),
            realValue: deposit.address,
            afterCopyText: 'Address copied',
            valueLoading: deposit.union is Loading,
            actionIcon: deposit.isAddressOpen
                ? const SAngleDownIcon()
                : const SAngleUpIcon(),
            onTap: () {
              depositN.switchAddress();
            },
          ),
          const SpaceH10(),
          if (deposit.isAddressOpen)
            SDivider(
              width: 327.w,
            ),
          const Spacer(),
          SQrCodeBox(
            loading: deposit.union is Loading,
            data: deposit.isAddressOpen ? deposit.address : deposit.tag!,
          ),
          const Spacer(),
          if (!deposit.isAddressOpen)
            SDivider(
              width: 327.w,
            ),
          const SpaceH10(),
          SAddressFieldWithCopy(
            header: 'Tag',
            value: deposit.tag!,
            realValue: deposit.tag,
            afterCopyText: 'Tag copied',
            valueLoading: deposit.union is Loading,
            actionIcon: deposit.isAddressOpen
                ? const SAngleUpIcon()
                : const SAngleDownIcon(),
            onTap: () {
              depositN.switchAddress();
            },
          ),
        ],
      ),
    );
  }
}
