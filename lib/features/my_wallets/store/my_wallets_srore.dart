// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/global_loader.dart';
import 'package:jetwallet/features/my_wallets/helper/currencies_for_my_wallet.dart';
import 'package:jetwallet/features/my_wallets/helper/show_wallet_verify_account.dart';
import 'package:jetwallet/utils/enum.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';
import 'package:simple_networking/modules/wallet_api/models/wallet/set_active_assets_request_model.dart';

import '../../../core/services/user_info/user_info_service.dart';

part 'my_wallets_srore.g.dart';

class MyWalletsSrore extends _MyWalletsSroreBase with _$MyWalletsSrore {
  MyWalletsSrore() : super();

  static _MyWalletsSroreBase of(BuildContext context) => Provider.of<MyWalletsSrore>(context, listen: false);
}

abstract class _MyWalletsSroreBase with Store {
  _MyWalletsSroreBase() {
    currenciesForSearch.addAll(_avaibledAssetsForSearch);
    sortByBalanceAndWeight(currenciesForSearch);
    reorderingCurrencies = currenciesForMyWallet(currencies: _allAssets);
  }

  Duration updateDuration = const Duration(seconds: 5);

  @computed
  bool get isLoading => !sSignalRModules.initFinished;

  @observable
  bool isReordering = false;

  StackLoaderStore loader = StackLoaderStore();

  @computed
  ObservableList<CurrencyModel> get _allAssets {
    return sSignalRModules.currenciesList;
  }

  @computed
  ObservableList<CurrencyModel> get _avaibledAssetsForSearch {
    return currenciesForSearchInMyWallet(_allAssets);
  }

  @observable
  ObservableList<CurrencyModel> reorderingCurrencies = ObservableList.of([]);

  @computed
  ObservableList<CurrencyModel> get currencies {
    if (isReordering) {
      return reorderingCurrencies;
    } else if (_allAssets.any((element) => element.symbol == justDeletedAsset)) {
      final a = ObservableList<CurrencyModel>.of([..._allAssets]);
      a.removeWhere((element) => element.symbol == justDeletedAsset);

      return currenciesForMyWallet(currencies: a);
    } else if (!_listsAreEqual(
      reorderingCurrencies,
      currenciesForMyWallet(currencies: _allAssets),
    )) {
      return reorderingCurrencies.length != currenciesForMyWallet(currencies: _allAssets).length
          ? currenciesForMyWallet()
          : reorderingCurrencies;
    } else {
      return currenciesForMyWallet(currencies: _allAssets);
    }
  }

  bool _listsAreEqual(List<CurrencyModel> list1, List<CurrencyModel> list2) {
    var i = -1;

    if (list1.length != list2.length) return false;

    return list1.every((val) {
      i++;

      return list2[i].symbol == val.symbol;
    });
  }

  @computed
  int get countOfPendingTransactions => sSignalRModules.pendingOperationCount;

  @observable
  ObservableList<CurrencyModel> currenciesForSearch = ObservableList.of([]);

  @action
  void onStartReordering() {
    reorderingCurrencies = currencies;
    isReordering = true;
  }

  @action
  void onReorder(int oldIndex, int newIndex) {
    var newIndexTemp = newIndex;

    if (oldIndex < newIndexTemp) {
      newIndexTemp -= 1;
    }
    final item = reorderingCurrencies.removeAt(oldIndex);
    reorderingCurrencies.insert(newIndexTemp, item);
  }

  @action
  void endReorderingImmediately() {
    isReordering = false;
    reorderingCurrencies = currenciesForMyWallet(currencies: _allAssets);
  }

  @action
  void onEndReordering() {
    sAnalytics.tapOnTheButtonDoneForChangeWalletsOrderOnTheWalletScreen();

    isReordering = false;

    final activeAssets = <ActiveAsset>[];
    for (var index = 0; index < currencies.length; index++) {
      activeAssets.add(
        ActiveAsset(
          assetSymbol: currencies[index].symbol,
          order: index,
        ),
      );
    }
    final model = SetActiveAssetsRequestModel(activeAssets: activeAssets);
    getIt.get<SNetwork>().simpleNetworking.getWalletModule().setActiveAssets(
          model,
        );
  }

  String justDeletedAsset = '';

  Timer? _timer;

  @action
  void onDelete(int index) {
    sAnalytics.tapOnTheDeleteButtonOnTheWalletScreen();

    _timer?.cancel();

    justDeletedAsset = currencies[index].symbol;
    currencies.removeAt(index);

    reorderingCurrencies = currencies;

    final activeAssets = <ActiveAsset>[];
    for (var index = 0; index < currencies.length; index++) {
      activeAssets.add(
        ActiveAsset(
          assetSymbol: currencies[index].symbol,
          order: index,
        ),
      );
    }
    final model = SetActiveAssetsRequestModel(activeAssets: activeAssets);
    getIt.get<SNetwork>().simpleNetworking.getWalletModule().setActiveAssets(
          model,
        );

    _timer = Timer(
      updateDuration,
      () {
        justDeletedAsset = '';
        currenciesForSearch
          ..clear()
          ..addAll(_avaibledAssetsForSearch);
        sortByBalanceAndWeight(currenciesForSearch);
      },
    );
  }

  @action
  void onSearch(String text) {
    final tempList = _avaibledAssetsForSearch
        .where(
          (e) =>
              e.description.toLowerCase().contains(text.toLowerCase()) ||
              e.symbol.toLowerCase().contains(text.toLowerCase()),
        )
        .toList();
    currenciesForSearch
      ..clear()
      ..addAll(tempList);
    sortByBalanceAndWeight(currenciesForSearch);
  }

  @action
  Future<void> onChooseAsetFromSearch(CurrencyModel currency) async {
    sAnalytics.tapOnAssetForAddToFavouritesOnAddWalletForFavouritesSheet(
      addedFavouritesAssetName: currency.symbol,
    );

    if (justDeletedAsset == currency.symbol) {
      justDeletedAsset = '';
    }

    final tempList = currencies + [currency];
    final activeAssets = <ActiveAsset>[];
    for (var index = 0; index < tempList.length; index++) {
      activeAssets.add(
        ActiveAsset(
          assetSymbol: tempList[index].symbol,
          order: index,
        ),
      );
    }
    final model = SetActiveAssetsRequestModel(activeAssets: activeAssets);
    final response = await getIt.get<SNetwork>().simpleNetworking.getWalletModule().setActiveAssets(
          model,
        );

    if (!response.hasData) {
      currencies.add(currency);
    }

    _avaibledAssetsForSearch.removeWhere((element) => element.symbol == currency.symbol);

    currenciesForSearch
      ..clear()
      ..addAll(_avaibledAssetsForSearch);
    sortByBalanceAndWeight(currenciesForSearch);

    reorderingCurrencies.add(currency);

    Timer(
      updateDuration,
      () {
        reorderingCurrencies = currenciesForMyWallet(currencies: _allAssets);
      },
    );
  }

  @action
  void onCloseSearchBottomSheetWithoutChoose() {
    currenciesForSearch
      ..clear()
      ..addAll(_avaibledAssetsForSearch);
    sortByBalanceAndWeight(currenciesForSearch);
  }

  @observable
  SimpleWalletAccountStatus simpleAccontStatus = SimpleWalletAccountStatus.none;
  @action
  void setSimpleAccountStatus(SimpleWalletAccountStatus status) {
    simpleAccontStatus = status;
  }

  // Manual change button status
  @observable
  BankingShowState? accountManualStatus;

  @computed
  SimpleAccountStatus get simpleStatus =>
      sSignalRModules.bankingProfileData?.simple?.status ?? SimpleAccountStatus.kycRequired;

  @computed
  AccountStatus get simpleAccountStatus =>
      sSignalRModules.bankingProfileData?.simple?.account?.status ?? AccountStatus.inactive;

  @computed
  BankingClientStatus get personalStatus =>
      sSignalRModules.bankingProfileData?.banking?.status ?? BankingClientStatus.simpleKycRequired;

  @computed
  BankingShowState get buttonStatus {
    if (accountManualStatus != null) {
      return accountManualStatus!;
    }

    return sSignalRModules.bankingProfileData?.showState ?? BankingShowState.getAccount;
  }

  @computed
  String get simpleAccountButtonText {
    final bankAccountsCount = (sSignalRModules.bankingProfileData?.banking?.accounts ?? [])
        .where((element) => element.status == AccountStatus.active)
        .length;

    final bankAccountsInCreationCount = (sSignalRModules.bankingProfileData?.banking?.accounts ?? [])
        .where((element) => element.status == AccountStatus.inCreation)
        .length;

    var allAccountsCount = bankAccountsCount;
    if (sSignalRModules.bankingProfileData?.simple != null) {
      if (sSignalRModules.bankingProfileData?.simple?.account?.status == AccountStatus.active) allAccountsCount++;
    }

    switch (buttonStatus) {
      case BankingShowState.getAccount:
        return intl.my_wallets_get_account;
      case BankingShowState.getAccountBlock:
        return intl.my_wallets_get_account;
      case BankingShowState.inProgress:
        return intl.my_wallets_create_account;
      case BankingShowState.accountList:
        return (sSignalRModules.bankingProfileData?.banking?.accounts ?? [])
                .where((element) => element.status == AccountStatus.inCreation)
                .isNotEmpty
            ? allAccountsCount > 1
                ? '$allAccountsCount ${intl.my_wallets_accounts} + $bankAccountsInCreationCount ${intl.creating}'
                : '$allAccountsCount ${intl.my_wallets_account} + $bankAccountsInCreationCount ${intl.creating}'
            : allAccountsCount > 1
                ? '$allAccountsCount ${intl.my_wallets_accounts}'
                : '$allAccountsCount ${intl.my_wallets_account}';

      case BankingShowState.onlySimple:
        return '1 ${intl.my_wallets_account}';
      default:
        return intl.my_wallets_get_account;
    }
  }

  @computed
  String get simpleCardButtonText {
    final userInfo = getIt.get<UserInfoService>();
    final preText = simpleAccountButtonText;
    final cardsActiveCount = sSignalRModules.bankingProfileData?.banking?.cards
            ?.where(
              (element) => element.status == AccountStatusCard.active || element.status == AccountStatusCard.frozen,
            )
            .toList()
            .length ??
        0;
    final cardsPendingCount = sSignalRModules.bankingProfileData?.banking?.cards
            ?.where((element) => element.status == AccountStatusCard.inCreation)
            .toList()
            .length ??
        0;
    if ((cardsActiveCount == 0 && cardsPendingCount == 0) || !userInfo.isSimpleCardAvailable) {
      return preText;
    } else if (cardsActiveCount > 0 && cardsPendingCount == 0) {
      return cardsActiveCount == 1
          ? '$preText + 1 ${intl.my_wallets_card}'
          : '$preText + $cardsActiveCount ${intl.my_wallets_cards}';
    } else if (cardsActiveCount == 0 && cardsPendingCount > 0) {
      return '$preText + ${intl.my_wallets_card_creating}';
    } else {
      return '$preText + $cardsActiveCount ${intl.my_wallets_cards} + ${intl.my_wallets_card_creating}';
    }
  }

  void afterVerification() {
    Future.delayed(
      updateDuration,
      () {
        sNotification.showError(
          intl.let_us_create_account,
          isError: false,
        );

        setSimpleAccountStatus(SimpleWalletAccountStatus.creating);

        sAnalytics.walletsScreenView(
          favouritesAssetsList: List.generate(
            currencies.length,
            (index) => currencies[index].symbol,
          ),
        );

        sAnalytics.eurWalletShowToastLestCreateAccount();

        getIt.get<GlobalLoader>().setLoading(false);
      },
    );
  }

  @action
  Future<void> createSimpleAccount() async {
    final isSimpleAccountMethodAvaible = sSignalRModules.paymentProducts?.any(
          (element) => element.id == AssetPaymentProductsEnum.simpleIbanAccount,
        ) ??
        false;
    if (!isSimpleAccountMethodAvaible) {
      sNotification.showError(
        intl.operation_bloked_text,
        id: 1,
        needFeedback: true,
      );

      return;
    }

    //loader.startLoadingImmediately();
    getIt.get<GlobalLoader>().setLoading(true);

    //getIt.get<GlobalLoader>().setLoading(true);

    final context = sRouter.navigatorKey.currentContext!;

    //await Future.delayed(const Duration(seconds: 10));
    try {
      final resp = await getIt.get<SNetwork>().simpleNetworking.getWalletModule().postSimpleAccountCreate();

      if (resp.hasError) {
        sNotification.showError(
          intl.something_went_wrong_try_again,
          id: 1,
          needFeedback: true,
        );
        accountManualStatus = null;
        loader.finishLoadingImmediately();
        getIt.get<GlobalLoader>().setLoading(false);
      } else {
        getIt.get<GlobalLoader>().setLoading(false);
        if (resp.data!.simpleKycRequired || resp.data!.addressSetupRequired) {
          sAnalytics.eurWalletVerifyYourAccount();

          showWalletVerifyAccount(
            context,
            after: afterVerification,
            isBanking: false,
          );
        } else if (resp.data!.bankingKycRequired) {
          showWalletVerifyAccount(
            context,
            after: afterVerification,
            isBanking: true,
          );
        } else {
          getIt.get<GlobalLoader>().setLoading(false);
          //accountManualStatus = BankingShowState.accountList;
        }
      }
    } catch (e) {
      getIt.get<GlobalLoader>().setLoading(false);
    }
  }
}
