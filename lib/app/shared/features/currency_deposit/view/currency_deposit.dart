import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../shared/components/buttons/app_button_outlined.dart';
import '../../../../../shared/components/loaders/loader.dart';
import '../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../shared/components/spacers.dart';
import '../../../helpers/short_address_form.dart';
import '../../../models/currency_model.dart';
import '../notifier/currency_deposit_notipod.dart';
import '../provider/deposit_disclaimer_fpod.dart';
import 'components/deposit_currency.dart';
import 'components/deposit_field.dart';
import 'components/deposit_info.dart';
import 'components/show_deposit_disclaimer.dart';

class CurrencyDeposit extends HookWidget {
  const CurrencyDeposit({
    Key? key,
    required this.header,
    required this.currency,
  }) : super(key: key);

  final String header;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    useProvider(depositDisclaimerFpod(currency.symbol).select((_) {}));
    final deposit = useProvider(
      currencyDepositNotipod(currency.symbol),
    );
    final depositN = useProvider(
      currencyDepositNotipod(currency.symbol).notifier,
    );

    return ProviderListener<AsyncValue<DepositDisclaimer>>(
      provider: depositDisclaimerFpod(currency.symbol),
      onChange: (context, asyncValue) {
        asyncValue.whenData((value) {
          if (value == DepositDisclaimer.notAccepted) {
            showDepositDisclaimer(context, currency.symbol);
          }
        });
      },
      child: PageFrame(
        header: '$header ${currency.description} (${currency.symbol})',
        onBackButton: () => Navigator.pop(context),
        child: deposit.union.when(
          success: () {
            return Column(
              children: [
                const SpaceH20(),
                Expanded(
                  child: ListView(
                    children: [
                      DepositField(
                        header: 'Wallet Address',
                        open: deposit.openAddress,
                        onTap: () => depositN.switchAddressQr(),
                        text: shortAddressForm(deposit.address),
                        actualValue: deposit.address,
                      ),
                      if (deposit.tag != null) ...[
                        const SpaceH10(),
                        DepositField(
                          header: 'Tag',
                          open: deposit.openTag,
                          onTap: () => depositN.switchTagQr(),
                          text: deposit.tag!,
                        )
                      ],
                    ],
                  ),
                ),
                const SpaceH10(),
                DepositCurrency(
                  currency: currency,
                ),
                if (deposit.tag != null) ...[
                  const SpaceH10(),
                  DepositInfo(
                    assetSymbol: currency.symbol,
                  ),
                ],
                const SpaceH10(),
                AppButtonOutlined(
                  name: 'Share my address',
                  onTap: () => Share.share(
                    // ignore: missing_whitespace_between_adjacent_strings
                    'My ${currency.symbol} Address: ${deposit.address}'
                    '${deposit.tag != null ? ', Tag: ${deposit.tag}' : ''}',
                  ),
                )
              ],
            );
          },
          loading: () => const Loader(),
        ),
      ),
    );
  }
}
