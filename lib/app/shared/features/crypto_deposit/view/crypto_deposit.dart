import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../models/currency_model.dart';
import '../notifier/crypto_deposit_notipod.dart';
import '../provider/crypto_deposit_disclaimer_fpod.dart';
import 'components/crypto_deposit_with_address.dart';
import 'components/crypto_deposit_with_address_and_tag/crypto_deposit_with_address_and_tag.dart';
import 'components/show_deposit_disclaimer.dart';

class CryptoDeposit extends HookWidget {
  const CryptoDeposit({
    Key? key,
    required this.header,
    required this.currency,
  }) : super(key: key);

  final String header;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    useProvider(cryptoDepositDisclaimerFpod(currency.symbol).select((_) {}));
    final deposit = useProvider(cryptoDepositNotipod(currency.symbol));

    return ProviderListener<AsyncValue<CryptoDepositDisclaimer>>(
      provider: cryptoDepositDisclaimerFpod(currency.symbol),
      onChange: (context, asyncValue) {
        asyncValue.whenData((value) {
          if (value == CryptoDepositDisclaimer.notAccepted) {
            showDepositDisclaimer(context, currency.symbol);
          }
        });
      },
      child: SPageFrame(
        header: SPaddingH24(
          child: SSmallHeader(
            title: '$header ${currency.description}',
          ),
        ),
        child: Column(
          children: [
            if (deposit.tag != null)
              CryptoDepositWithAddressAndTag(
                currency: currency,
              )
            else
              CryptoDepositWithAddress(
                currency: currency,
              ),
            const SDivider(),
            const SpaceH24(),
            SPaddingH24(
              child: SPrimaryButton2(
                icon: SShareIcon(
                  color: colors.white,
                ),
                active: true,
                name: 'Share',
                onTap: () => Share.share(
                  'My ${currency.symbol} Address: ${deposit.address} '
                  '${deposit.tag != null ? ', Tag: ${deposit.tag}' : ''}',
                ),
              ),
            ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
