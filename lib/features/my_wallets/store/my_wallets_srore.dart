import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/my_wallets/helper/currencies_for_my_wallet.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/wallet_api/models/wallet/set_active_assets_request_model.dart';

part 'my_wallets_srore.g.dart';

class MyWalletsSrore = _MyWalletsSroreBase with _$MyWalletsSrore;

abstract class _MyWalletsSroreBase with Store {
  @computed
  ObservableList<CurrencyModel> get _allAssets {
    final result = sSignalRModules.currenciesList;

    return result;
  }

  @computed
  List<CurrencyModel> get currencies {
    final result = currenciesForMyWallet(_allAssets);

    return result;
  }

  @action
  void onReorder(int oldIndex, int newIndex) {
    var newIndexTemp = newIndex;

    if (oldIndex < newIndexTemp) {
      newIndexTemp -= 1;
    }
    final item = currencies.removeAt(oldIndex);
    currencies.insert(newIndexTemp, item);

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
}
