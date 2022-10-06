import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/wallet_api/models/base_asset/set_base_assets_request_model.dart';

import '../../../../core/services/signal_r/signal_r_modules.dart';

part 'change_base_asset_store.g.dart';

@lazySingleton
class ChangeBaseAssetStore = _ChangeBaseAssetStoreBase
    with _$ChangeBaseAssetStore;

abstract class _ChangeBaseAssetStoreBase with Store {
  _ChangeBaseAssetStoreBase() {
    _init();
  }
  static final _logger = Logger('ChangeBaseAssetStore');

  @observable
  String checkedAsset = '';

  @observable
  ObservableList<String> assetsList = ObservableList.of([]);

  @action
  Future<void> changeBaseAsset(String newAsset) async {
    _logger.log(notifier, 'changeBaseAsset');

    if (newAsset != checkedAsset) {
      try {
        final model = SetBaseAssetsRequestModel(
          assetSymbol: newAsset,
        );

        final _ = await sNetwork.getWalletModule().setBaseAsset(model);
        setBaseAsset(newAsset);
      } catch (e) {
        _logger.log(stateFlow, 'confirmNewPassword', e);
      }
    } else {
      await sRouter.pop();
    }
  }

  @action
  void setBaseAsset(String newAsset) {
    _logger.log(notifier, 'setBaseAsset');
    checkedAsset = newAsset;
  }

  @action
  Future<void> _init() async {
    final baseAsset = sSignalRModules.baseCurrency;
    setBaseAsset(baseAsset.symbol);

    final walletApi = sNetwork.getWalletModule();

    final request = await walletApi.getBaseAssetsList();

    request.pick(
      onData: (data) async {
        print('datadatadatadatadatadatadata');
        print(data.data);
        // assetsList = ObservableList.of(data);
      },
      onError: (error) {},
    );
  }
}
