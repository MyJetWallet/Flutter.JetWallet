import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../helpers/short_address_form.dart';
import '../../../../../models/currency_model.dart';
import '../../../notifier/crypto_deposit_notipod.dart';
import '../../../notifier/crypto_deposit_union.dart';

class CryptoDepositWithAddressAndTag extends HookWidget {
  const CryptoDepositWithAddressAndTag({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final deposit = useProvider(cryptoDepositNotipod(currency));
    final depositN = useProvider(
      cryptoDepositNotipod(currency).notifier,
    );

    return ExpansionPanelList(
      elevation: 0,
      expansionCallback: (int index, bool isExpanded) {
        depositN.switchAddress();
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return SAddressFieldWithCopy(
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
            );
          },
          body: Column(
            children: [
              // const Spacer(),
              SQrCodeBox(
                loading: deposit.union is Loading,
                data: deposit.address,
              ),
              const SpaceH18(),
              const SDivider(
                width: double.infinity,
              ),
            ],
          ),
          isExpanded: deposit.isAddressOpen,
        ),
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return SAddressFieldWithCopy(
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
            );
          },
          body: Column(
            children: [
              // const Spacer(),
              const SpaceH10(),
              SQrCodeBox(
                loading: deposit.union is Loading,
                data: deposit.tag!,
              ),
            ],
          ),
          isExpanded: !deposit.isAddressOpen,
        )
      ],
    );
  }
}
