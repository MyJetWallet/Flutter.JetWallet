// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_buy/action_buy.dart';
import 'package:jetwallet/features/actions/action_send/widgets/send_options.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_country_model.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/store/send_card_payment_method_store.dart';
import 'package:jetwallet/features/withdrawal_banking/helpers/show_bank_transfer_select.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/helpers/flag_asset_name.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

import '../../../core/services/local_storage_service.dart';
import '../../app/store/app_store.dart';
import '../helpers/show_currency_search.dart';

Future<void> showSendAction(bool isEmptyBalance, BuildContext context) async {
  final kycState = getIt.get<KycService>();
  final handler = getIt.get<KycAlertHandler>();

  final isToCryptoWalletAvaible = checkToCryptoWalletAvaible();
  final isGlobalAvaible = checkGlobalAvaible();
  final isGiftAvaible = checkGiftAvaible();
  final isAllowBankTransfer = isGlobalAvaible && checkBankTransferAvailable();

  if (isEmptyBalance) {
    showPleaseAddFundsToYourBalanceDialog(() {
      showBuyAction(context: context);
    });

    return;
  }

  if (!(isToCryptoWalletAvaible || isGlobalAvaible || isGiftAvaible)) {
    handler.handle(
      multiStatus: [
        kycState.tradeStatus,
        kycState.withdrawalStatus,
      ],
      isProgress: kycState.verificationInProgress,
      currentNavigate: () => showSendTimerAlertOr(
        context: context,
        or: () {
          sNotification.showError(
            intl.operation_bloked_text,
            id: 1,
          );
        },
        from: [BlockingType.transfer, BlockingType.withdrawal],
      ),
      requiredDocuments: kycState.requiredDocuments,
      requiredVerifications: kycState.requiredVerifications,
    );

    return;
  }

  sShowBasicModalBottomSheet(
    context: context,
    pinned: ActionBottomSheetHeader(
      name: intl.sendOptions_send,
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      if (isToCryptoWalletAvaible)
        SCardRow(
          icon: const SWallet2Icon(),
          onTap: () {
            Navigator.pop(context);
            _showSendActionChooseAsset(context);
          },
          amount: '',
          description: '',
          name: intl.sendOptions_to_crypto_wallet,
          helper: intl.withdrawOptions_actionItemNameDescr,
        ),
      if (isGlobalAvaible)
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
        ),
      if (isGiftAvaible)
        SCardRow(
          icon: const SGiftSendIcon(),
          onTap: () {
            Navigator.pop(context);
            sRouter.push(const GiftSelectAssetRouter());
          },
          amount: '',
          description: '',
          name: intl.send_gift,
          helper: intl.send_gift_to_simple_wallet,
        ),
      if (isAllowBankTransfer)
        SCardRow(
          icon: Assets.svg.medium.bank.simpleSvg(color: SColorsLight().blue),
          onTap: () {
            Navigator.pop(context);
            showBankTransferTo(context);
          },
          amount: '',
          description: '',
          name: intl.bank_transfer,
          helper: intl.bank_transfer_to_yourself,
        ),
      const SpaceH42(),
    ],
  );
}

Future<void> showSendGlobally(
  BuildContext context,
  CurrencyModel currency,
) async {
  final availableCountries = <KycCountryModel>[];
  final globalSearchStore = ActionSearchStore();

  for (var i = 0; i < sSignalRModules.globalSendMethods!.methods!.length; i++) {
    if (sSignalRModules.globalSendMethods!.methods![i].countryCodes != null &&
        sSignalRModules.globalSendMethods!.methods![i].countryCodes!.isNotEmpty) {
      for (var q = 0; q < sSignalRModules.globalSendMethods!.methods![i].countryCodes!.length; q++) {
        if (sSignalRModules.globalSendMethods!.methods![i].countryCodes![q].isNotEmpty) {
          final cind = sSignalRModules.kycCountries.indexWhere(
            (element) => element.countryCode == sSignalRModules.globalSendMethods!.methods![i].countryCodes![q],
          );

          if (cind != -1) {
            if (!availableCountries.contains(sSignalRModules.kycCountries[cind])) {
              availableCountries.add(sSignalRModules.kycCountries[cind]);
            }
          }
        }
      }
    }
  }

  globalSearchStore.globalSendSearchInit(availableCountries);

  sAnalytics.destinationCountryScreenView();

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: availableCountries.length >= 7,
    expanded: availableCountries.length >= 7,
    then: (value) {},
    pinned: ActionBottomSheetHeader(
      name: intl.global_send_destionation_country,
      showSearch: availableCountries.length >= 7,
      onChanged: (String value) {
        globalSearchStore.globalSendSearch(value);
      },
      needBottomPadding: false,
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
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

            final list = getCountryMethodsList(
              store.filtredGlobalSendCountries[index].countryCode,
            );

            if (list.length == 1) {
              sRouter.push(
                SendCardDetailRouter(
                  countryCode: store.filtredGlobalSendCountries[index].countryCode,
                  currency: currency,
                  method: list[0],
                ),
              );
            } else {
              sRouter.push(
                SendCardPaymentMethodRouter(
                  currency: currency,
                  countryCode: store.filtredGlobalSendCountries[index].countryCode,
                ),
              );
            }
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

bool checkIsBlockerNotContains(BlockingType blockingType) {
  final clientDetail = sSignalRModules.clientDetail;

  final result = clientDetail.clientBlockers.any(
    (element) => element.blockingType == blockingType,
  );

  return !result;
}

bool checkToCryptoWalletAvaible() {
  final kycState = getIt.get<KycService>();

  final isAnySuportedByCurrencies = sSignalRModules.currenciesList.any(
    (element) => element.supportsCryptoWithdrawal && element.isAssetBalanceNotEmpty,
  );
  final isNoKycBlocker = kycState.withdrawalStatus == kycOperationStatus(KycStatus.allowed);
  final isNoClientBlocker = checkIsBlockerNotContains(BlockingType.withdrawal);

  return isAnySuportedByCurrencies && isNoKycBlocker && isNoClientBlocker;
}

bool checkGlobalAvaible() {
  final kycState = getIt.get<KycService>();

  final isAnySuportedByCurrencies = sSignalRModules.currenciesList.any(
    (element) => element.supportsGlobalSend,
  );
  final isNoKycBlocker = kycState.withdrawalStatus == kycOperationStatus(KycStatus.allowed);
  final isNoClientBlocker = checkIsBlockerNotContains(BlockingType.withdrawal);

  return isAnySuportedByCurrencies && isNoKycBlocker && isNoClientBlocker;
}

bool checkBankTransferAvailable() {
  final allowSimpleBanking = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
    (element) => element.id == AssetPaymentProductsEnum.simpleIbanAccount,
  );

  final allowBanking = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
    (element) => element.id == AssetPaymentProductsEnum.bankingIbanAccount,
  );

  return allowSimpleBanking || allowBanking;
}

bool checkGiftAvaible() {
  final kycState = getIt.get<KycService>();

  final isAnySuportedByCurrencies = sSignalRModules.currenciesList.any(
    (element) => element.supportsGiftlSend && element.isAssetBalanceNotEmpty,
  );
  final isNoKycBlocker = kycState.withdrawalStatus == kycOperationStatus(KycStatus.allowed);
  final isNoClientBlocker = checkIsBlockerNotContains(BlockingType.transfer);

  return isAnySuportedByCurrencies && isNoKycBlocker && isNoClientBlocker;
}

Future<void> _showSendActionChooseAsset(
  BuildContext context,
) async {
  getIt.get<ActionSearchStore>().init();
  final showSearch = showSendCurrencySearch(context);

  final storageService = getIt.get<LocalStorageService>();
  final lastCurrency = await storageService.getValue(lastAssetSend);

  sAnalytics.cryptoSendChooseAssetScreenView(
    sendMethodType: '0',
  );

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
      _ActionSend(
        lastCurrency: lastCurrency,
      ),
    ],
    then: (value) {},
  );
}

class _ActionSend extends StatelessObserverWidget {
  const _ActionSend({
    this.lastCurrency,
  });

  final String? lastCurrency;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final state = getIt.get<ActionSearchStore>();

    var currencyFiltered = List<CurrencyModel>.from(state.fCurrencies);
    currencyFiltered = currencyFiltered
        .where(
          (element) => element.isAssetBalanceNotEmpty && element.supportsCryptoWithdrawal,
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

void showBankTransferTo(BuildContext context, [CurrencyModel? currency]) {
  final accounts = sSignalRModules.bankingProfileData?.banking?.accounts ?? [];
  final activeAccounts = accounts.where((element) => element.status == AccountStatus.active);
  final bankingShowState = sSignalRModules.bankingProfileData?.banking?.status ?? BankingClientStatus.unsupported;

  final simpleAccounts = sSignalRModules.bankingProfileData?.simple?.account;
  final simpleBankingShowState = sSignalRModules.bankingProfileData?.simple?.status ?? SimpleAccountStatus.unsupported;

  final allowSimpleBanking = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
    (element) => element.id == AssetPaymentProductsEnum.simpleIbanAccount,
  );

  final allowBanking = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
    (element) => element.id == AssetPaymentProductsEnum.bankingIbanAccount,
  );

  print('#@#@#@ 1 $bankingShowState $accounts');
  print('#@#@#@ 2 $simpleBankingShowState $simpleAccounts');

  sShowBasicModalBottomSheet(
    context: context,
    pinned: ActionBottomSheetHeader(
      name: intl.bank_transfer_to,
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      SCardRow(
        icon: Assets.svg.medium.userAlt.simpleSvg(color: SColorsLight().blue),
        onTap: () {
          if (!allowSimpleBanking) {
            return;
          }
          if (simpleBankingShowState == SimpleAccountStatus.allowed) {
            if (simpleAccounts == null || simpleAccounts.status != AccountStatus.active) {
              return;
            } else {
              Navigator.pop(context);

              showBankTransforSelect(
                context,
                simpleAccounts,
                true,
                true,
                currency,
              );
            }
          }
        },
        amount: '',
        description: '',
        name: intl.bank_transfer_to_myself,
        helper: allowSimpleBanking
            ? simpleBankingShowState != SimpleAccountStatus.allowed
                ? intl.bank_transfer_coming_soon
                : simpleAccounts == null
                    ? intl.bank_transfer_coming_soon
                    : simpleAccounts.status == AccountStatus.active
                        ? ''
                        : intl.bank_transfer_coming_soon
            : intl.bank_transfer_coming_soon,
      ),
      SCardRow(
        icon: Assets.svg.medium.userSend.simpleSvg(color: SColorsLight().blue),
        onTap: () {
          if (!allowBanking) {
            return;
          }
          if (bankingShowState == BankingClientStatus.allowed) {
            if (accounts.isEmpty) {
              if (simpleAccounts?.status == AccountStatus.active) {
                Navigator.pop(context);
                context.pushRoute(const GetPersonalIbanRouter());
              }
              return;
            } else {
              if (activeAccounts.isNotEmpty) {
                Navigator.pop(context);
                showBankTransforSelect(
                  context,
                  activeAccounts.first,
                  false,
                  true,
                  currency,
                );
              } else {
                return;
              }
            }
          } else if (bankingShowState == BankingClientStatus.bankingKycRequired) {
            if (simpleAccounts?.status == AccountStatus.inCreation) {
              return;
            } else {
              Navigator.pop(context);
              context.pushRoute(const GetPersonalIbanRouter());
            }
          }
        },
        amount: '',
        description: '',
        name: intl.bank_transfer_to_another_person,
        helper: allowBanking
            ? (bankingShowState != BankingClientStatus.allowed &&
                    bankingShowState != BankingClientStatus.bankingKycRequired)
                ? intl.bank_transfer_coming_soon
                : ''
            : intl.bank_transfer_coming_soon,
      ),
      const SpaceH42(),
    ],
  );
}

void showGlobalSendCurrenctSelect(BuildContext context) {
  getIt.get<ActionSearchStore>().init();
  getIt.get<ActionSearchStore>().clearSearchValue();
  final searchStore = getIt.get<ActionSearchStore>();

  sAnalytics.chooseAssetToSendScreenView();

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
    required this.searchStore,
  });

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
          (element) => element.type == AssetType.crypto && element.supportsGlobalSend,
        )
        .toList();

    final cryptoSearchLength = sSignalRModules.currenciesList
        .where(
          (element) => element.type == AssetType.crypto && element.supportsGlobalSend && element.isAssetBalanceNotEmpty,
        )
        .length;
    final showCryptoSearch = cryptoSearchLength >= 7;

    final showFiatLength = sSignalRModules.currenciesList
        .where(
          (element) => element.type == AssetType.fiat && element.supportsGlobalSend && element.isAssetBalanceNotEmpty,
        )
        .length;
    final showFiatSearch = showFiatLength >= 7;

    if (cryptoSearchLength == 0) {
      state.updateShowCrypto(false);
    } else if (showFiatLength == 0) {
      state.updateShowCrypto(true);
    }

    return Column(
      children: [
        if (cryptoSearchLength != 0 && showFiatLength != 0) ...[
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
                  if (currency.supportsGlobalSend && currency.isAssetBalanceNotEmpty)
                    SimpleTableAccount(
                      assetIcon: NetworkIconWidget(
                        currency.iconUrl,
                      ),
                      label: currency.description,
                      supplement: currency.symbol,
                      onTableAssetTap: () {
                        Navigator.pop(context);
                        showSendGlobally(context, currency);
                      },
                      hasRightValue: false,
                    ),
            ],
          ),
        ] else ...[
          Column(
            children: [
              for (final currency in state.fCurrencies)
                if (currency.type == AssetType.fiat)
                  if (currency.supportsGlobalSend && currency.isAssetBalanceNotEmpty)
                    SimpleTableAccount(
                      assetIcon: NetworkIconWidget(
                        currency.iconUrl,
                      ),
                      label: currency.description,
                      supplement: currency.symbol,
                      onTableAssetTap: () {
                        Navigator.pop(context);
                        showSendGlobally(context, currency);
                      },
                      hasRightValue: false,
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
