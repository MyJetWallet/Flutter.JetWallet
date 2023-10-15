import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/my_wallets/helper/currencies_for_my_wallet.dart';
import 'package:jetwallet/utils/enum.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/wallet/set_active_assets_request_model.dart';

part 'my_wallets_srore.g.dart';

class MyWalletsSrore = _MyWalletsSroreBase with _$MyWalletsSrore;

abstract class _MyWalletsSroreBase with Store {
  _MyWalletsSroreBase() {}

  @observable
  bool isReordering = false;

  @computed
  ObservableList<CurrencyModel> get _allAssets {
    return sSignalRModules.currenciesList;
  }

  @observable
  ObservableList<CurrencyModel> reorderingCurrencies = ObservableList.of([]);

  @computed
  ObservableList<CurrencyModel> get currencies {
    return isReordering ? reorderingCurrencies : currenciesForMyWallet(_allAssets);
  }

  @computed
  bool get isPendingTransactions => currencies.any((element) => element.isPendingDeposit);

  @computed
  int get countOfPendingTransactions => currencies.where((element) => element.isPendingDeposit).length;

  @computed
  ObservableList<CurrencyModel> get currenciesForSearch => currenciesForSearchInMyWallet(_allAssets);

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
  void onEndReordering() {
    sAnalytics.tapOnTheButtonDoneForChangeWalletsOrderOnTheWalletScreen();

    isReordering = false;

    currencies
      ..clear()
      ..addAll(reorderingCurrencies);

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

  @action
  void onDelete(int index) {
    sAnalytics.tapOnTheDeleteButtonOnTheWalletScreen();
    currencies.removeAt(index);

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

  @action
  void onSearch(String text) {
    final tempList = _allAssets.where((e) => e.description.toLowerCase().contains(text.toLowerCase())).toList();
    currenciesForSearch
      ..clear()
      ..addAll(tempList);
  }

  @action
  Future<void> onChooseAsetFromSearch(CurrencyModel currency) async {
    sAnalytics.tapOnAssetForAddToFavouritesOnAddWalletForFavouritesSheet(
      addedFavouritesAssetName: currency.symbol,
    );

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
  }

  @observable
  SimpleWalletAccountStatus simpleAccontStatus = SimpleWalletAccountStatus.none;
  @action
  void setSimpleAccountStatus(SimpleWalletAccountStatus status) {
    simpleAccontStatus = status;
  }

  // Manual change button status
  @observable
  SimpleWalletAccountStatus? accountManualStatus;

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
  SimpleWalletAccountStatus get buttonStatus {
    if (accountManualStatus != null) {
      return accountManualStatus!;
    }

    if (simpleStatus == SimpleAccountStatus.allowed && sSignalRModules.bankingProfileData?.simple?.account != null) {
      if (personalStatus == BankingClientStatus.kycInProgress) {
        return SimpleWalletAccountStatus.createdAndcreating;
      }

      return SimpleWalletAccountStatus.created;
    }
    if (simpleStatus == SimpleAccountStatus.kycInProgress) {
      return SimpleWalletAccountStatus.creating;
    } else if (simpleStatus == SimpleAccountStatus.kycBlocked) {
      return SimpleWalletAccountStatus.blocked;
    } else {
      return SimpleWalletAccountStatus.none;
    }
  }

  @computed
  String get simpleAccountButtonText {
    switch (buttonStatus) {
      case SimpleWalletAccountStatus.none:
        return intl.my_wallets_get_account;
      case SimpleWalletAccountStatus.blocked:
        return intl.my_wallets_get_account;
      case SimpleWalletAccountStatus.creating:
        return intl.my_wallets_create_account;
      case SimpleWalletAccountStatus.createdAndcreating:
        return intl.my_wallets_create_account;
      case SimpleWalletAccountStatus.created:
        return '${(sSignalRModules.bankingProfileData?.banking?.accounts?.length ?? 1) + 1} ${intl.my_wallets_account}';
      default:
        return '';
    }
  }

  @action
  Future<void> createSimpleAccount() async {
    accountManualStatus = SimpleWalletAccountStatus.creating;

    //await Future.delayed(const Duration(seconds: 10));
    final resp = await getIt.get<SNetwork>().simpleNetworking.getWalletModule().postSimpleAccountCreate();

    if (resp.hasError) {
      sNotification.showError(
        intl.something_went_wrong_try_again,
        duration: 4,
        id: 1,
        needFeedback: true,
      );
      accountManualStatus = null;
    } else {
      accountManualStatus = SimpleWalletAccountStatus.created;
    }
  }
}
