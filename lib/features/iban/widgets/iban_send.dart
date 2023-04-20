import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:simple_kit/simple_kit.dart';

class IbanSend extends StatelessObserverWidget {
  const IbanSend({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final currencies = sSignalRModules.currenciesList;
    final itemsWithBalance = currenciesWithBalanceFrom(currencies);

    final baseCurrency = sSignalRModules.baseCurrency;

    final eurCurrency = currencyFrom(
      itemsWithBalance,
      'EUR',
    );

    return Column(
      children: [
        const SpaceH20(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
          decoration: BoxDecoration(
            color: colors.blueLight,
          ),
          child: Text(
            intl.iban_send_info,
            maxLines: 3,
            style: sBodyText2Style,
            textAlign: TextAlign.center,
          ),
        ),
        const SpaceH24(),
        SPaddingH24(
          child: InkWell(
            onTap: () => navigateToWallet(context, eurCurrency),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: 26,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: colors.grey4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        intl.iban_euro_balance,
                        style: sSubtitle2Style,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    eurCurrency.volumeBaseBalance(baseCurrency),
                    style: sTextH1Style,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SpaceH24(),
        MarketSeparator(text: intl.iban_destination_accounts),
        SCardRow(
          icon: const SizedBox(
            width: 24,
            height: 24,
            child: SAccountIcon(),
          ),
          rightIcon: const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: SEditIcon(),
          ),
          name: 'Savings (Caixa bank)',
          amount: '',
          helper: 'PT14 2004 1010 0505 0001 3M02 606',
          description: '',
          removeDivider: true,
          onTap: () {},
        ),
        SCardRow(
          icon: SizedBox(
            width: 24,
            height: 24,
            child: SPlusIcon(
              color: colors.blue,
            ),
          ),
          //rightIcon: const SEditIcon(),
          name: intl.iban_add_bank_account,
          amount: '',
          helper: intl.iban_local_euro_accounts_only,
          description: '',
          removeDivider: true,
          onTap: () {
            sRouter.push(const IbanAddBankAccountRouter());
          },
        ),
      ],
    );
  }
}
