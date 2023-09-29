import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/my_wallets/helper/currencies_for_my_wallet.dart';
import 'package:jetwallet/utils/enum.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/wallet/set_active_assets_request_model.dart';

part 'my_wallets_srore.g.dart';

class MyWalletsSrore = _MyWalletsSroreBase with _$MyWalletsSrore;

abstract class _MyWalletsSroreBase with Store {
  _MyWalletsSroreBase() {}

  @observable
  bool isReordering = false;

  @computed
  ObservableList<CurrencyModel> get _allAssets => sSignalRModules.currenciesList;

  @computed
  ObservableList<CurrencyModel> get currencies => currenciesForMyWallet(_allAssets);

  @computed
  ObservableList<CurrencyModel> get currenciesForSearch => currenciesForSearchInMyWallet(_allAssets);

  @action
  void onStartReordering() {
    isReordering = true;
  }

  @action
  void onEndReordering() {
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

  @action
  void onDelete(int index) {
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
  void onChooseAsetFromSearch(CurrencyModel currency) {
    currencies.add(currency);

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

  @observable
  SimpleWalletAccountStatus simpleAccontStatus = SimpleWalletAccountStatus.none;
  @action
  void setSimpleAccountStatus(SimpleWalletAccountStatus status) {
    simpleAccontStatus = status;
  }

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
    if (simpleStatus == SimpleAccountStatus.allowed) {
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
}
