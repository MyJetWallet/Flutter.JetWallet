import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/my_wallets/helper/currencies_for_my_wallet.dart';
import 'package:jetwallet/utils/enum.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/wallet_api/models/wallet/set_active_assets_request_model.dart';

part 'my_wallets_srore.g.dart';

class MyWalletsSrore = _MyWalletsSroreBase with _$MyWalletsSrore;

abstract class _MyWalletsSroreBase with Store {
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
    return isReordering
        ? reorderingCurrencies
        : currenciesForMyWallet(_allAssets);
  }

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
    final response = await getIt
        .get<SNetwork>()
        .simpleNetworking
        .getWalletModule()
        .setActiveAssets(
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

  @computed
  String get simpleAccountButtonText {
    switch (simpleAccontStatus) {
      case SimpleWalletAccountStatus.none:
        return intl.my_wallets_get_account;
      case SimpleWalletAccountStatus.creating:
        return intl.my_wallets_create_account;
      case SimpleWalletAccountStatus.created:
        return '1 ${intl.my_wallets_account}';
      default:
        return '';
    }
  }
}
