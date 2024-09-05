import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

class IbanSend extends StatelessObserverWidget {
  const IbanSend({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final currencies = sSignalRModules.currenciesList;
    final eurCurrency = currencyFrom(
      currencies,
      'EUR',
    );

    final store = getIt.get<IbanStore>();

    return SingleChildScrollView(
      child: Column(
        children: [
          const SpaceH12(),
          SPaddingH24(
            child: InkWell(
              highlightColor: colors.grey5,
              splashColor: Colors.transparent,
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () => navigateToWallet(
                context,
                eurCurrency,
              ),
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
                        NetworkIconWidget(
                          eurCurrency.iconUrl.isNotEmpty
                              ? eurCurrency.iconUrl
                              : 'https://wallet-api.simple-spot.biz/icons/eur.webp',
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
                      eurCurrency.assetBalance.toFormatCount(
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
              itemCount: store.allContacts.length,
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
                            contact: store.allContacts[index],
                          ),
                        );
                      },
                      defaultIcon: const SEditIcon(),
                      pressedIcon: const SEditIcon(
                        color: Color(0xFFA8B0BA),
                      ),
                    ),
                  ),
                  name: store.allContacts[index].name ?? '',
                  amount: '',
                  helper: store.allContacts[index].iban ?? '',
                  description: '',
                  needSpacer: true,
                  onTap: () {
                    getIt<AppRouter>()
                        .push(
                          IbanSendAmountRouter(
                            contact: store.allContacts[index],
                            bankingAccount: const SimpleBankingAccount(),
                            isCJ: true,
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
