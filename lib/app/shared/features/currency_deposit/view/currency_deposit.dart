import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../shared/components/buttons/app_button_outlined.dart';
import '../../../../../shared/components/loader.dart';
import '../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../shared/components/spacers.dart';
import '../../../models/currency_model.dart';
import '../helper/short_form_from.dart';
import '../provider/deposit_address_fpod.dart';
import '../provider/deposit_disclaimer_fpod.dart';
import 'components/deposit_currency.dart';
import 'components/deposit_field.dart';
import 'components/deposit_info.dart';
import 'components/failed_to_fetch_deposit_address.dart';
import 'components/show_deposit_disclaimer.dart';

class CurrencyDeposit extends HookWidget {
  const CurrencyDeposit({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final openAddress = useState(true);
    final openTag = useState(false);
    useProvider(depositDisclaimerFpod(currency.symbol).select((_) {}));
    final depositAddress = useProvider(
      depositAddressFpod(currency.symbol),
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
        header: 'Deposit ${currency.description} (${currency.symbol})',
        onBackButton: () => Navigator.pop(context),
        child: depositAddress.when(
          data: (data) {
            if (data.address == null) {
              return FailedToFetchDepositAddress(
                currency: currency,
                onRetry: () => context.refresh(
                  depositAddressFpod(currency.symbol),
                ),
              );
            } else {
              return Column(
                children: [
                  const SpaceH20(),
                  Expanded(
                    child: ListView(
                      children: [
                        DepositField(
                          open: openAddress.value,
                          onTap: () {
                            openTag.value = false;
                            openAddress.value = true;
                          },
                          header: 'Wallet Address',
                          text: shortFormFrom(data.address!),
                          actualValue: data.address,
                        ),
                        if (data.memo != null) ...[
                          const SpaceH10(),
                          DepositField(
                            open: openTag.value,
                            onTap: () {
                              openAddress.value = false;
                              openTag.value = true;
                            },
                            header: 'Tag',
                            text: data.memo!,
                          )
                        ],
                      ],
                    ),
                  ),
                  const SpaceH10(),
                  DepositCurrency(
                    currency: currency,
                  ),
                  if (data.memo != null) ...[
                    const SpaceH10(),
                    DepositInfo(
                      assetSymbol: currency.symbol,
                    ),
                  ],
                  const SpaceH10(),
                  AppButtonOutlined(
                    name: 'Share my address',
                    onTap: () => Share.share(
                      'My ${currency.symbol} Address: ${data.address}, '
                      '${data.memo != null ? 'Tag: ${data.memo}' : ''}',
                    ),
                  )
                ],
              );
            }
          },
          loading: () => const Loader(),
          error: (e, _) => Text('Error: $e'),
        ),
      ),
    );
  }
}
