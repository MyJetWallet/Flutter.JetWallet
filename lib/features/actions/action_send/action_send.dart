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
import 'package:jetwallet/features/iban/widgets/show_choose_asset_to_send.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_country_model.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/store/send_card_payment_method_store.dart';
import 'package:jetwallet/features/withdrawal_banking/helpers/show_bank_transfer_select.dart';
import 'package:jetwallet/utils/helpers/flag_asset_name.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
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
  final isAllowBankTransfer = isGlobalAvaible;

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

  if (isEmptyBalance) {
    showPleaseAddFundsToYourBalanceDialog(() {
      showBuyAction(context: context);
    });

    return;
  }

  await showBasicBottomSheet(
    context: context,
    header: BasicBottomSheetHeaderWidget(
      title: intl.sendOptions_send,
    ),
    children: [
      if (isToCryptoWalletAvaible)
        SimpleTableAsset(
          assetIcon: const SWallet2Icon(),
          label: intl.sendOptions_to_crypto_wallet,
          supplement: intl.withdrawOptions_actionItemNameDescr,
          onTableAssetTap: () {
            Navigator.pop(context);
            _showSendActionChooseAsset(context);
          },
          hasRightValue: false,
        ),
      if (isGlobalAvaible)
        SimpleTableAsset(
          assetIcon: const SNetworkIcon(),
          label: intl.global_send_name,
          supplement: intl.global_send_helper,
          onTableAssetTap: () {
            Navigator.pop(context);
            showGlobalSendCurrenctSelect(context);
          },
          hasRightValue: false,
        ),
      if (isGiftAvaible)
        SimpleTableAsset(
          assetIcon: const SGiftSendIcon(),
          label: intl.send_gift,
          supplement: intl.send_gift_to_simple_wallet,
          onTableAssetTap: () {
            Navigator.pop(context);
            sRouter.push(const GiftSelectAssetRouter());
          },
          hasRightValue: false,
        ),
      if (isAllowBankTransfer)
        SimpleTableAsset(
          assetIcon: Assets.svg.medium.bank.simpleSvg(color: SColorsLight().blue),
          label: intl.bank_transfer,
          supplement: intl.bank_transfer_to_yourself,
          onTableAssetTap: () {
            Navigator.pop(context);
            showBankTransferTo(context);
          },
          hasRightValue: false,
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

  await showBasicBottomSheet(
    context: context,
    expanded: availableCountries.length >= 7,
    header: BasicBottomSheetHeaderWidget(
      title: intl.global_send_destionation_country,
      searchOptions: availableCountries.length >= 7
          ? SearchOptions(
              hint: intl.actionBottomSheetHeader_search,
              onChange: (String value) {
                globalSearchStore.globalSendSearch(value);
              },
            )
          : null,
    ),
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
        return SimpleTableAsset(
          assetIcon: SizedBox(
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
          label: store.filtredGlobalSendCountries[index].countryName,
          onTableAssetTap: () {
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
          hasRightValue: false,
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

  await showBasicBottomSheet(
    context: context,
    expanded: showSearch,
    header: BasicBottomSheetHeaderWidget(
      title: intl.actionSend_bottomSheetHeaderName,
      searchOptions: showSearch
          ? SearchOptions(
              hint: intl.actionBottomSheetHeader_search,
              onChange: (String value) {
                getIt.get<ActionSearchStore>().search(value);
              },
            )
          : null,
    ),
    children: [
      _ActionSend(
        lastCurrency: lastCurrency,
      ),
    ],
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

  // final methods =
  //     sSignalRModules.globalSendMethods?.methods?.where((method) => method.receiveAsset == 'UAH').toList() ?? [];

  String getHelperTextToSendAnyone() {
    if (allowBanking) {
      if (simpleAccounts == null || simpleAccounts.status != AccountStatus.active) {
        return intl.bank_transfer_coming_soon;
      } else {
        if (activeAccounts.isNotEmpty) {
          return '';
        } else {
          if (accounts.isEmpty) {
            return '';
          } else {
            return intl.bank_transfer_coming_soon;
          }
        }
      }
    } else {
      return intl.bank_transfer_coming_soon;
    }
  }

  showBasicBottomSheet(
    context: context,
    header: BasicBottomSheetHeaderWidget(
      title: intl.bank_transfer_to,
    ),
    children: [
      SimpleTableAsset(
        assetIcon: Assets.svg.medium.userAlt.simpleSvg(color: SColorsLight().blue),
        label: intl.bank_transfer_to_myself,
        supplement: allowSimpleBanking
            ? simpleBankingShowState != SimpleAccountStatus.allowed
                ? intl.bank_transfer_coming_soon
                : simpleAccounts == null
                    ? intl.bank_transfer_coming_soon
                    : simpleAccounts.status == AccountStatus.active
                        ? ''
                        : intl.bank_transfer_coming_soon
            : intl.bank_transfer_coming_soon,
        onTableAssetTap: () {
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
        hasRightValue: false,
      ),
      SimpleTableAsset(
        assetIcon: Assets.svg.medium.userSend.simpleSvg(color: SColorsLight().blue),
        label: intl.bank_transfer_to_another_person,
        supplement: getHelperTextToSendAnyone(),
        onTableAssetTap: () {
          if (!allowBanking) {
            return;
          }
          if (bankingShowState == BankingClientStatus.allowed) {
            if (accounts.isEmpty) {
              if (simpleAccounts != null && simpleAccounts.status == AccountStatus.active) {
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
            if (simpleAccounts != null && simpleAccounts.status == AccountStatus.inCreation) {
              return;
            } else {
              if (simpleAccounts == null) {
                return;
              } else {
                Navigator.pop(context);
                context.pushRoute(const GetPersonalIbanRouter());
              }
            }
          } else if (bankingShowState == BankingClientStatus.kycInProgress) {
            if (activeAccounts.isNotEmpty) {
              Navigator.pop(context);
              showBankTransforSelect(
                context,
                activeAccounts.first,
                false,
                true,
                currency,
              );
            }
          }
        },
        hasRightValue: false,
      ),
      // if (methods.isNotEmpty)
      //   SCardRow(
      //     icon: Assets.svg.medium.business.simpleSvg(color: SColorsLight().blue),
      //     onTap: () {
      //       final methods = sSignalRModules.globalSendMethods?.methods
      //               ?.where((method) => method.type == 10 && (method.receiveAsset == 'UAH'))
      //               .toList() ??
      //           [];
      //
      //       if (methods.isEmpty) {
      //         sNotification.showError(
      //           intl.operation_bloked_text,
      //           id: 1,
      //         );
      //         return;
      //       }
      //
      //       if (currency != null) {
      //         sRouter.push(
      //           SendCardDetailRouter(
      //             method: methods.first,
      //             countryCode: 'UA',
      //             currency: currency,
      //           ),
      //         );
      //       } else {
      //         showChooseAssetToSend(
      //           sRouter.navigatorKey.currentContext!,
      //           isUahBankTransfer: true,
      //         );
      //       }
      //     },
      //     amount: '',
      //     description: '',
      //     name: intl.bank_transfer_uah_bank_account,
      //     helper: intl.bank_transfer_ua_iban,
      //   ),
      const SpaceH42(),
    ],
  );
}

void showGlobalSendCurrenctSelect(BuildContext context) {
  sAnalytics.chooseAssetToSendScreenView();

  showChooseAssetToSend(
    sRouter.navigatorKey.currentContext!,
    isGlobalSend: true,
  );
}
