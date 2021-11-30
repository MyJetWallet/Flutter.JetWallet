import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../helpers/short_address_form.dart';
import '../../../models/currency_model.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../notifier/crypto_deposit_notipod.dart';
import '../notifier/crypto_deposit_union.dart';
import '../provider/crypto_deposit_disclaimer_fpod.dart';
import 'components/address_field_with_qr.dart';
import 'components/show_deposit_disclaimer.dart';

// TODO Draft
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
    useProvider(cryptoDepositDisclaimerFpod(currency.symbol).select((_) {}));
    final baseCurrency = useProvider(baseCurrencyPod);
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
            const Spacer(),
            // TODO add to AddressFieldWithQr
            QrImage(
              padding: EdgeInsets.zero,
              data: deposit.address,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
              embeddedImage: const AssetImage(
                'assets/images/qr_logo.png',
              ),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: Size(90.r, 90.r),
              ),
              size: 220.r,
            ),
            const Spacer(),
            AddressFieldWithQr(
              header: 'BTC Wallet address',
              value: shortAddressForm(deposit.address),
              realValue: deposit.address,
              afterCopyText: 'Address copied',
              valueLoading: deposit.union is Loading,
              actionIcon: const SAngleUpIcon(),
              onTap: () {
                // TODO
              },
            ),
            const SDivider(),
            SWalletItem(
              icon: NetworkSvgW24(
                url: currency.iconUrl,
              ),
              primaryText: currency.description,
              amount: currency.formatBaseBalance(baseCurrency),
              secondaryText: '${currency.assetBalance} ${currency.symbol}',
            ),
            SPaddingH24(
              child: SPrimaryButton2(
                active: true,
                name: 'Share',
                onTap: () => Share.share(
                  // ignore: missing_whitespace_between_adjacent_strings
                  'My ${currency.symbol} Address: ${deposit.address}'
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
