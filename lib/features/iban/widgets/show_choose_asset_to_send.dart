import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/action_send.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';

void showChooseAssetToSend(
  BuildContext context, {
  bool isUahBankTransfer = false,
  bool isGlobalSend = false,
  AddressBookContactModel? contact,
  bool? isCJ,
}) {
  getIt.get<ActionSearchStore>().init();
  getIt.get<ActionSearchStore>().clearSearchValue();

  final bankAccounts = sSignalRModules.bankingProfileData?.banking?.accounts ?? <SimpleBankingAccount>[];
  getIt.get<ActionSearchStore>().bankAccountsInit(bankAccounts);

  var currencyFiltered = List<CurrencyModel>.from(
    getIt.get<ActionSearchStore>().fCurrencies,
  );
  currencyFiltered = currencyFiltered
      .where(
        (element) => element.isAssetBalanceNotEmpty && element.supportsCryptoWithdrawal,
      )
      .toList();

  showBasicBottomSheet(
    context: context,
    basicBottomSheetHeader: BasicBottomSheetHeaderWidget(
      title: intl.actionSend_bottomSheetHeaderName,
      searchOptions: (currencyFiltered.length +
                  (isUahBankTransfer
                      ? bankAccounts.length
                      : isGlobalSend
                          ? 0
                          : isCJ!
                              ? 0
                              : bankAccounts.length)) >=
              7
          ? SearchOptions(
              hint: intl.actionBottomSheetHeader_search,
              onChange: (String value) {
                getIt.get<ActionSearchStore>().search(value);
                getIt.get<ActionSearchStore>().bankAccountsSearch(value);
              },
            )
          : null,
    ),
    children: [
      _ChooseAssetToSend(
        isUahBankTransfer,
        isGlobalSend,
        contact,
        isCJ,
      ),
    ],
  );
}

class _ChooseAssetToSend extends StatelessObserverWidget {
  const _ChooseAssetToSend(
    this.isUahBankTransfer,
    this.isGlobalSend,
    this.contact,
    this.isCJ,
  );

  final bool isUahBankTransfer;
  final bool isGlobalSend;
  final AddressBookContactModel? contact;
  final bool? isCJ;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final state = getIt.get<ActionSearchStore>();

    var currencyFiltered = List<CurrencyModel>.from(state.fCurrencies);
    currencyFiltered = currencyFiltered
        .where(
          (element) =>
              element.isAssetBalanceNotEmpty &&
              ((isUahBankTransfer || isGlobalSend)
                  ? element.supporGlobalSendWithdrawal
                  : element.supportsCryptoWithdrawal),
        )
        .toList();

    currencyFiltered.sort((a, b) {
      return b.baseBalance.compareTo(a.baseBalance);
    });

    final searchedBankAccounts = List<SimpleBankingAccount>.from(state.searchBankAccounts);

    final simpleAccount = sSignalRModules.bankingProfileData?.simple?.account;

    final activeAccounts =
        sSignalRModules.bankingProfileData?.banking?.accounts?.where((acc) => acc.status == AccountStatus.active) ?? [];

    final eurCurrency = currencyFrom(
      sSignalRModules.currenciesList,
      'EUR',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isUahBankTransfer || isGlobalSend) ...[
          if (simpleAccount != null) _buildEuroText(),
        ] else ...[
          if (isCJ! && simpleAccount != null)
            _buildEuroText()
          else if (searchedBankAccounts.isNotEmpty)
            _buildEuroText(),
        ],
        if (isGlobalSend || isUahBankTransfer) ...[
          if (simpleAccount != null)
            _buildSimpleBank(
              context,
              eurCurrency,
              simpleAccount,
            ),
        ] else ...[
          if (isCJ! && simpleAccount != null)
            _buildSimpleBank(
              context,
              eurCurrency,
              simpleAccount,
            )
          else
            _buildBankAccounts(
              context,
              eurCurrency,
              searchedBankAccounts,
            ),
        ],
        if (currencyFiltered.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 8.0,
            ),
            child: Text(
              intl.market_crypto,
              style: STStyles.body2Semibold.copyWith(
                color: SColorsLight().gray8,
              ),
            ),
          ),
        for (final currency in currencyFiltered)
          if (currency.isAssetBalanceNotEmpty)
            if (currency.supportsCryptoWithdrawal)
              SimpleTableAccount(
                assetIcon: NetworkIconWidget(
                  currency.iconUrl,
                ),
                label: currency.description,
                rightValue: getIt<AppStore>().isBalanceHide
                    ? '**** ${baseCurrency.symbol}'
                    : currency.volumeBaseBalance(baseCurrency),
                supplement:
                    getIt<AppStore>().isBalanceHide ? '******* ${currency.symbol}' : currency.volumeAssetBalance,
                onTableAssetTap: () {
                  Navigator.pop(context);

                  if (isGlobalSend) {
                    _globalSendFlow(currency);
                  } else if (isUahBankTransfer) {
                    final methods = sSignalRModules.globalSendMethods?.methods
                            ?.where((method) => method.type == 10 && (method.countryCodes?.contains('UA') ?? true))
                            .toList() ??
                        [];

                    if (methods.isNotEmpty) {
                      sRouter.push(
                        SendCardDetailRouter(
                          method: methods.first,
                          countryCode: 'UA',
                          currency: currency,
                        ),
                      );
                    }
                  } else {
                    getIt<AppRouter>().push(
                      IbanSendAmountRouter(
                        isCJ: isCJ!,
                        contact: contact!,
                        currency: currency,
                        bankingAccount: isCJ! ? simpleAccount : activeAccounts.first,
                      ),
                    );
                  }
                },
              ),
        const SizedBox(
          height: 12.0,
        ),
      ],
    );
  }

  void _globalSendFlow(CurrencyModel currency) {
    showSendGlobally(
      getIt<AppRouter>().navigatorKey.currentContext!,
      currency,
    );
  }

  Widget _buildEuroText() => Padding(
        padding: const EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 8.0,
        ),
        child: Text(
          intl.iban_euro,
          style: STStyles.body2Semibold.copyWith(
            color: SColorsLight().gray8,
          ),
        ),
      );

  Widget _buildEurCurrency(
    BuildContext context,
    CurrencyModel eurCurrency,
    SimpleBankingAccount simpleAccount,
  ) =>
      SimpleTableAccount(
        assetIcon: NetworkIconWidget(
          eurCurrency.iconUrl,
        ),
        label: eurCurrency.description,
        rightValue: getIt<AppStore>().isBalanceHide
            ? '**** ${eurCurrency.symbol}'
            : simpleAccount.balance!.toFormatSum(
                accuracy: eurCurrency.accuracy,
                symbol: eurCurrency.symbol,
              ),
        supplement: eurCurrency.symbol,
        onTableAssetTap: () {
          Navigator.pop(context);

          if (isGlobalSend) {
            _globalSendFlow(eurCurrency);
          } else if (isUahBankTransfer) {
            final methods = sSignalRModules.globalSendMethods?.methods
                    ?.where((method) => method.type == 10 && (method.countryCodes?.contains('UA') ?? true))
                    .toList() ??
                [];

            if (methods.isNotEmpty) {
              sRouter.push(
                SendCardDetailRouter(
                  method: methods.first,
                  countryCode: 'UA',
                  currency: eurCurrency,
                ),
              );
            }
          }
        },
      );

  Widget _buildSimpleBank(BuildContext context, CurrencyModel eurCurrency, SimpleBankingAccount simpleAccount) =>
      SimpleTableAccount(
        assetIcon: const BlueBankIcon(
          size: 24.0,
        ),
        label: simpleAccount.label ?? 'Account 1',
        rightValue: getIt<AppStore>().isBalanceHide
            ? '**** ${eurCurrency.symbol}'
            : (simpleAccount.balance ?? Decimal.zero).toFormatSum(
                accuracy: eurCurrency.accuracy,
                symbol: eurCurrency.symbol,
              ),
        supplement:
            simpleAccount.status == AccountStatus.active ? intl.eur_wallet_simple_account : intl.create_simple_creating,
        hasRightValue: simpleAccount.status == AccountStatus.active,
        onTableAssetTap: () {
          Navigator.pop(context);

          if (isGlobalSend) {
            _globalSendFlow(eurCurrency);
          } else if (isUahBankTransfer) {
            final methods = sSignalRModules.globalSendMethods?.methods
                    ?.where((method) => method.type == 10 && (method.countryCodes?.contains('UA') ?? true))
                    .toList() ??
                [];

            if (methods.isNotEmpty) {
              sRouter.push(
                SendCardDetailRouter(
                  method: methods.first,
                  countryCode: 'UA',
                  currency: eurCurrency,
                ),
              );
            }
          } else {
            getIt<AppRouter>().push(
              IbanSendAmountRouter(
                contact: contact!,
                bankingAccount: simpleAccount,
                isCJ: isCJ!,
              ),
            );
          }
        },
      );

  Widget _buildBankAccounts(
    BuildContext context,
    CurrencyModel eurCurrency,
    List<SimpleBankingAccount> searchedBankAccounts,
  ) =>
      ListView.builder(
        shrinkWrap: true,
        itemCount: searchedBankAccounts.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return SimpleTableAsset(
            onTableAssetTap: () {
              Navigator.pop(context);

              if (isGlobalSend) {
                _globalSendFlow(eurCurrency);
              } else if (isUahBankTransfer) {
                final methods = sSignalRModules.globalSendMethods?.methods
                        ?.where((method) => method.type == 10 && (method.countryCodes?.contains('UA') ?? true))
                        .toList() ??
                    [];

                if (methods.isNotEmpty) {
                  sRouter.push(
                    SendCardDetailRouter(
                      method: methods.first,
                      countryCode: 'UA',
                      currency: eurCurrency,
                    ),
                  );
                }
              } else {
                getIt<AppRouter>().push(
                  IbanSendAmountRouter(
                    contact: contact!,
                    bankingAccount: searchedBankAccounts[index],
                    isCJ: isCJ!,
                  ),
                );
              }
            },
            assetIcon: const BlueBankIcon(
              size: 24.0,
            ),
            label: searchedBankAccounts[index].label ?? 'Account',
            supplement: searchedBankAccounts[index].status == AccountStatus.active
                ? intl.eur_wallet_personal_account
                : intl.create_personal_creating,
            hasRightValue: searchedBankAccounts[index].status == AccountStatus.active,
            rightValue: getIt<AppStore>().isBalanceHide
                ? '**** ${eurCurrency.symbol}'
                : (searchedBankAccounts[index].balance ?? Decimal.zero).toFormatSum(
                    accuracy: eurCurrency.accuracy,
                    symbol: eurCurrency.symbol,
                  ),
          );
        },
      );
}
