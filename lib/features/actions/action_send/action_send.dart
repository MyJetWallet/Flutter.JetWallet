// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/send_alert_bottom_sheet.dart';
import 'package:jetwallet/features/actions/action_send/widgets/send_options.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:jetwallet/features/kyc/models/kyc_country_model.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/helpers/flag_asset_name.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

import '../../../core/services/local_storage_service.dart';
import '../helpers/show_currency_search.dart';

enum SendType { Wallet, Phone }

void showSendAction(
  BuildContext context, {
  bool isSendAvailable = true,
  bool isNotEmptyBalance = true,
  bool shouldPop = true,
}) {
  if (shouldPop) {
    Navigator.pop(context);
  }
  final searchState = getIt.get<ActionSearchStore>();
  final sendAssets = searchState.fCurrencies
      .where(
        (element) =>
            element.isAssetBalanceNotEmpty && element.supportsCryptoWithdrawal,
      )
      .toList();

  if (isNotEmptyBalance && isSendAvailable && sendAssets.isNotEmpty) {
    showSendTimerAlertOr(
      context: context,
      or: () => _showSendAction(context),
      from: BlockingType.withdrawal,
    );
  } else {
    sendAlertBottomSheet(context);
  }
}

Future<void> _showSendAction(BuildContext context) async {
  final isAnyAssetSupportPhoneSend = sSignalRModules.currenciesList
      .where(
        (element) =>
            element.isAssetBalanceNotEmpty &&
            element.supportsByPhoneNicknameWithdrawal &&
            element.supportsCryptoWithdrawal,
      )
      .toList();

  final isGlobalSendActive = sSignalRModules.currenciesList
      .where((element) => element.supportsGlobalSend)
      .toList();

  final isIbanOutActive = sSignalRModules.currenciesList
      .where((element) => element.supportIbanSendWithdrawal)
      .toList();

  sShowBasicModalBottomSheet(
    context: context,
    pinned: ActionBottomSheetHeader(
      name: intl.sendOptions_sendTo,
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      SCardRow(
        icon: const SWallet2Icon(),
        onTap: () {
          Navigator.pop(context);

          _showSendActionChooseAsset(context, SendType.Wallet);
        },
        amount: '',
        description: '',
        name: intl.withdrawOptions_actionItemName1,
        helper: intl.withdrawOptions_actionItemNameDescr,
        removeDivider: true,
      ),
      if (isAnyAssetSupportPhoneSend.isNotEmpty)
        SCardRow(
          icon: const SPhoneIcon(),
          onTap: () {
            Navigator.pop(context);

            _showSendActionChooseAsset(context, SendType.Phone);
          },
          amount: '',
          description: '',
          name: intl.sendOptions_actionItemName3,
          helper: intl.sendOptions_actionItemDescription1,
          removeDivider: true,
        ),
      if (isGlobalSendActive.isNotEmpty)
        SCardRow(
          icon: const SNetworkIcon(),
          onTap: () {
            Navigator.pop(context);

            showGlobalSendCurrenctSelect(context);
          },
          amount: '',
          description: '',
          name: intl.global_send_name,
          helper: intl.global_send_helper,
          removeDivider: true,
        ),
      if (isIbanOutActive.isNotEmpty)
        SCardRow(
          icon: const SAccountIcon(),
          onTap: () {
            Navigator.pop(context);

            sRouter.replaceAll(
              [
                HomeRouter(
                  children: [
                    IBanRouter(
                      initIndex: 1,
                    ),
                  ],
                ),
              ],
            );

            getIt.get<AppStore>().setHomeTab(2);
            if (getIt<AppStore>().tabsRouter != null) {
              getIt<AppStore>().tabsRouter!.setActiveIndex(2);

              if (getIt.get<IbanStore>().ibanTabController != null) {
                getIt.get<IbanStore>().ibanTabController!.animateTo(
                      1,
                    );
              } else {
                getIt.get<IbanStore>().setInitTab(1);
              }
            }
          },
          amount: '',
          description: '',
          name: intl.iban_send_name,
          helper: intl.iban_send_helper,
          removeDivider: true,
        ),
      const SpaceH42(),
    ],
    then: (value) {},
  );
}

Future<void> showSendGlobally(
  BuildContext context,
  CurrencyModel currency,
) async {
  final availableCountries = <KycCountryModel>[];
  final globalSearchStore = ActionSearchStore();

  log(jsonEncode(sSignalRModules.globalSendMethods!.toJson()));

  for (var i = 0; i < sSignalRModules.globalSendMethods!.methods!.length; i++) {
    if (sSignalRModules.globalSendMethods!.methods![i].countryCodes != null &&
        sSignalRModules
            .globalSendMethods!.methods![i].countryCodes!.isNotEmpty) {
      for (var q = 0;
          q <
              sSignalRModules
                  .globalSendMethods!.methods![i].countryCodes!.length;
          q++) {
        if (sSignalRModules
            .globalSendMethods!.methods![i].countryCodes![q].isNotEmpty) {
          final cind = sSignalRModules.kycCountries.indexWhere(
            (element) =>
                element.countryCode ==
                sSignalRModules.globalSendMethods!.methods![i].countryCodes![q],
          );

          if (cind != -1) {
            if (!availableCountries
                .contains(sSignalRModules.kycCountries[cind])) {
              availableCountries.add(sSignalRModules.kycCountries[cind]);
            }
          }
        }
      }
    }
  }

  globalSearchStore.globalSendSearchInit(availableCountries);

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: availableCountries.length >= 7,
    expanded: availableCountries.length >= 7,
    then: (value) {},
    pinned: ActionBottomSheetHeader(
      name: intl.global_send_destionation_country,
      //showSearch: availableCountries.length >= 7,
      onChanged: (String value) {
        globalSearchStore.globalSendSearch(value);
      },
      needBottomPadding: false,
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      if (availableCountries.length >= 7) ...[
        SPaddingH24(
          child: SStandardField(
            controller: TextEditingController(),
            labelText: intl.actionBottomSheetHeader_search,
            onChanged: (String value) {
              globalSearchStore.globalSendSearch(value);
            },
          ),
        ),
        const SDivider(),
      ],
      _GlobalSendCountriesList(
        currency: currency,
        store: globalSearchStore,
      ),
      const SpaceH42(),
    ],
  );
}

class _GlobalSendCountriesList extends StatelessObserverWidget {
  const _GlobalSendCountriesList({
    super.key,
    required this.currency,
    required this.store,
  });

  final CurrencyModel currency;
  final ActionSearchStore store;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: store.filtredGlobalSendCountries.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return SCardRow(
          icon: SizedBox(
            height: 24,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              height: 24,
              width: 24,
              child: SvgPicture.asset(
                flagAssetName(
                  store.filtredGlobalSendCountries[index].countryCode,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          spaceBIandText: 10,
          height: 69,
          onTap: () {
            Navigator.pop(context);

            sRouter.push(
              SendCardPaymentMethodRouter(
                currency: currency,
                countryCode:
                    store.filtredGlobalSendCountries[index].countryCode,
              ),
            );
          },
          amount: '',
          description: '',
          name: store.filtredGlobalSendCountries[index].countryName,
          removeDivider: false,
          divider: index != store.filtredGlobalSendCountries.length - 1,
        );
      },
    );
  }
}

Future<void> _showSendActionChooseAsset(
  BuildContext context,
  SendType type,
) async {
  final showSearch = showSendCurrencySearch(context);

  final storageService = getIt.get<LocalStorageService>();
  final lastCurrency = await storageService.getValue(lastAssetSend);

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: ActionBottomSheetHeader(
      name: intl.actionSend_bottomSheetHeaderName,
      showSearch: showSearch,
      onChanged: (String value) {
        getIt.get<ActionSearchStore>().search(value);
      },
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      if (type == SendType.Wallet) ...[
        _ActionSend(
          lastCurrency: lastCurrency,
          type: type,
        ),
      ] else ...[
        _ActionSendPhone(
          lastCurrency: lastCurrency,
          type: type,
        ),
      ],
    ],
    then: (value) {},
  );
}

class _ActionSend extends StatelessObserverWidget {
  const _ActionSend({
    this.lastCurrency,
    required this.type,
  });

  final String? lastCurrency;
  final SendType type;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final state = getIt.get<ActionSearchStore>();

    var currencyFiltered = List<CurrencyModel>.from(state.fCurrencies);
    currencyFiltered = currencyFiltered
        .where(
          (element) =>
              element.isAssetBalanceNotEmpty &&
              element.supportsCryptoWithdrawal,
        )
        .toList();

    currencyFiltered.sort((a, b) {
      if (lastCurrency != null) {
        if (a.symbol == lastCurrency) {
          return 0.compareTo(1);
        } else if (b.symbol == lastCurrency) {
          return 1.compareTo(0);
        }
      }

      return b.baseBalance.compareTo(a.baseBalance);
    });

    return Column(
      children: [
        for (final currency in currencyFiltered)
          if (currency.isAssetBalanceNotEmpty)
            if (currency.supportsCryptoWithdrawal)
              SWalletItem(
                decline: currency.dayPercentChange.isNegative,
                icon: SNetworkSvg24(
                  url: currency.iconUrl,
                ),
                primaryText: currency.description,
                removeDivider: currency == currencyFiltered.last,
                amount: currency.volumeBaseBalance(baseCurrency),
                secondaryText: currency.volumeAssetBalance,
                onTap: () {
                  Navigator.pop(context);

                  sRouter.push(
                    WithdrawRouter(
                      withdrawal: WithdrawalModel(
                        currency: currency,
                      ),
                    ),
                  );
                },
              ),
        const SpaceH42(),
      ],
    );
  }
}

class _ActionSendPhone extends StatelessObserverWidget {
  const _ActionSendPhone({
    this.lastCurrency,
    required this.type,
  });

  final String? lastCurrency;
  final SendType type;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final state = getIt.get<ActionSearchStore>();

    var currencyFiltered = List<CurrencyModel>.from(state.fCurrencies);
    currencyFiltered = currencyFiltered
        .where(
          (element) =>
              element.isAssetBalanceNotEmpty &&
              element.supportsCryptoWithdrawal,
        )
        .toList();

    currencyFiltered.sort((a, b) {
      if (lastCurrency != null) {
        if (a.symbol == lastCurrency) {
          return 0.compareTo(1);
        } else if (b.symbol == lastCurrency) {
          return 1.compareTo(0);
        }
      }

      return b.baseBalance.compareTo(a.baseBalance);
    });

    return Column(
      children: [
        for (final currency in currencyFiltered)
          if (currency.isAssetBalanceNotEmpty)
            if (currency.supportsCryptoWithdrawal)
              if (currency.supportsByPhoneNicknameWithdrawal)
                SWalletItem(
                  decline: currency.dayPercentChange.isNegative,
                  icon: SNetworkSvg24(
                    url: currency.iconUrl,
                  ),
                  primaryText: currency.description,
                  removeDivider: currency == currencyFiltered.last,
                  amount: currency.volumeBaseBalance(baseCurrency),
                  secondaryText: currency.volumeAssetBalance,
                  onTap: () {
                    sRouter.navigate(
                      SendByPhoneInputRouter(
                        currency: currency,
                      ),
                    );
                  },
                ),
        const SpaceH42(),
      ],
    );
  }
}

void showGlobalSendCurrenctSelect(BuildContext context) {
  getIt.get<ActionSearchStore>().init();
  getIt.get<ActionSearchStore>().clearSearchValue();
  final searchStore = getIt.get<ActionSearchStore>();

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    expanded: true,
    then: (value) {},
    pinned: ActionBottomSheetHeader(
      name: intl.action_send_global_send_bottomheet,
      onChanged: (String value) {
        getIt.get<ActionSearchStore>().search(value);
      },
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      _GlobalSendSelectCurrency(
        searchStore: searchStore,
      ),
    ],
  );
}

class _GlobalSendSelectCurrency extends StatelessObserverWidget {
  const _GlobalSendSelectCurrency({
    Key? key,
    required this.searchStore,
  }) : super(key: key);

  final ActionSearchStore searchStore;

  @override
  Widget build(BuildContext context) {
    final state = searchStore;
    final colors = sKit.colors;

    final watchList = sSignalRModules.keyValue.watchlist?.value ?? [];
    sortByBalanceWatchlistAndWeight(state.fCurrencies, watchList);

    var currencyFiltered = List<CurrencyModel>.from(state.fCurrencies);
    currencyFiltered = currencyFiltered
        .where(
          (element) =>
              element.type == AssetType.crypto && element.supportsGlobalSend,
        )
        .toList();

    final showCryptoSearch = sSignalRModules.currenciesList
            .where((element) =>
                element.type == AssetType.crypto && element.supportsGlobalSend)
            .length >=
        7;

    final showFiatSearch = sSignalRModules.currenciesList
            .where((element) =>
                element.type == AssetType.fiat && element.supportsGlobalSend)
            .length >=
        7;

    return Column(
      children: [
        if (true) ...[
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  state.updateShowCrypto(!state.showCrypto);
                  state.search('');
                  state.searchController.text = '';
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: colors.grey5,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    child: Row(
                      children: [
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 48) / 2,
                          child: Center(
                            child: Text(
                              intl.actionDeposit_crypto,
                              style: sSubtitle3Style.copyWith(
                                color: colors.grey3,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 48) / 2,
                          child: Center(
                            child: Text(
                              intl.actionDeposit_fiat,
                              style: sSubtitle3Style.copyWith(
                                color: colors.grey3,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (state.showCrypto)
                Positioned(
                  left: 0,
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 48) / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: Center(
                        child: Text(
                          intl.actionDeposit_crypto,
                          style: sSubtitle3Style.copyWith(
                            color: colors.white,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else
                Positioned(
                  right: 0,
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 48) / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: Center(
                        child: Text(
                          intl.actionDeposit_fiat,
                          style: sSubtitle3Style.copyWith(
                            color: colors.white,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SpaceH12(),
        ],
        if (state.showCrypto && showCryptoSearch) ...[
          SPaddingH24(
            child: SStandardField(
              controller: state.searchController,
              labelText: intl.actionBottomSheetHeader_search,
              onChanged: (String value) => state.search(value),
            ),
          ),
          const SDivider(),
        ] else if (showFiatSearch) ...[
          SPaddingH24(
            child: SStandardField(
              controller: state.searchController,
              labelText: intl.actionBottomSheetHeader_search,
              onChanged: (String value) => state.search(value),
            ),
          ),
          const SDivider(),
        ],
        if (state.showCrypto) ...[
          Column(
            children: [
              for (final currency in state.fCurrencies)
                if (currency.type == AssetType.crypto)
                  if (currency.supportsGlobalSend &&
                      currency.isAssetBalanceNotEmpty)
                    SWalletItem(
                      icon: SNetworkSvg24(
                        url: currency.iconUrl,
                      ),
                      primaryText: currency.description,
                      secondaryText: currency.symbol,
                      removeDivider: currency ==
                          state.fCurrencies
                              .where(
                                (element) =>
                                    element.type == AssetType.crypto &&
                                    element.supportsGlobalSend,
                              )
                              .last,
                      onTap: () {
                        Navigator.pop(context);
                        showSendGlobally(context, currency);
                      },
                    ),
            ],
          ),
        ] else ...[
          Column(
            children: [
              for (final currency in state.fCurrencies)
                if (currency.type == AssetType.fiat)
                  if (currency.supportsGlobalSend &&
                      currency.isAssetBalanceNotEmpty)
                    SWalletItem(
                      icon: SNetworkSvg24(
                        url: currency.iconUrl,
                      ),
                      primaryText: currency.description,
                      secondaryText: currency.symbol,
                      removeDivider: currency ==
                          state.fCurrencies
                              .where(
                                (element) =>
                                    element.type == AssetType.fiat &&
                                    element.supportsGlobalSend,
                              )
                              .last,
                      onTap: () {
                        Navigator.pop(context);
                        showSendGlobally(context, currency);
                      },
                    ),
              const SpaceH42(),
            ],
          ),
        ],
        const SpaceH42(),
      ],
    );
  }
}
