import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
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

    final eurCurrency = currencyFrom(
      itemsWithBalance,
      'EUR',
    );

    print(eurCurrency.iconUrl);

    final store = getIt.get<IbanStore>();

    return SingleChildScrollView(
      child: Column(
        children: [
          const SpaceH8(),
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
              highlightColor: colors.grey5,
              splashColor: Colors.transparent,
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () => navigateToWallet(context, eurCurrency),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 22,
                  bottom: 26,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.grey4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SNetworkSvg24(
                          url: eurCurrency.iconUrl.isNotEmpty
                              ? eurCurrency.iconUrl
                              : 'https://wallet-api.simple-spot.biz/icons/eur.svg',
                        ),
                        const SizedBox(width: 10),
                        Text(
                          intl.iban_euro_balance,
                          style: sSubtitle2Style,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      volumeFormat(
                        prefix: eurCurrency.prefixSymbol,
                        decimal: eurCurrency.assetBalance,
                        accuracy: eurCurrency.accuracy,
                        symbol: eurCurrency.symbol,
                      ),
                      style: sTextH1Style,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SpaceH24(),
          MarketSeparator(text: intl.iban_destination_accounts),
          if (!store.ibanAdressBookLoaded) ...[
            Column(
              children: [
                const SizedBox(height: 12),
                SSkeletonTextLoader(
                  height: 46,
                  width: MediaQuery.of(context).size.width * .9,
                  borderRadius: const BorderRadius.all(Radius.circular(11)),
                ),
                const SizedBox(height: 12),
                SSkeletonTextLoader(
                  height: 46,
                  width: MediaQuery.of(context).size.width * .9,
                  borderRadius: const BorderRadius.all(Radius.circular(11)),
                ),
                const SizedBox(height: 12),
                SSkeletonTextLoader(
                  height: 46,
                  width: MediaQuery.of(context).size.width * .9,
                  borderRadius: const BorderRadius.all(Radius.circular(11)),
                ),
              ],
            ),
          ] else ...[
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: store.contacts.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return SCardRow(
                  icon: const SizedBox(
                    width: 24,
                    height: 24,
                    child: SAccountIcon(),
                  ),
                  rightIcon: Padding(
                    padding: const EdgeInsets.only(top: 9.0),
                    child: SIconButton(
                      onTap: () {
                        sRouter.push(
                          IbanEditBankAccountRouter(
                            contact: store.contacts[index],
                          ),
                        );
                      },
                      defaultIcon: const SEditIcon(),
                      pressedIcon: const SEditIcon(
                        color: Color(0xFFA8B0BA),
                      ),
                    ),
                  ),
                  name: store.contacts[index].name ?? '',
                  amount: '',
                  helper: store.contacts[index].iban ?? '',
                  description: '',
                  removeDivider: true,
                  onTap: () {
                    getIt<AppRouter>()
                        .push(
                          IbanSendAmountRouter(
                            contact: store.contacts[index],
                          ),
                        )
                        .then(
                          (value) => store.getAddressBook(),
                        );
                  },
                );
              },
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
                sRouter.push(IbanAddBankAccountRouter()).then(
                      (value) => store.getAddressBook(),
                    );
              },
            ),
          ],
        ],
      ),
    );
  }
}
