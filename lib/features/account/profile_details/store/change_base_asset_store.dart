import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from_all.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/modules/wallet_api/models/base_asset/set_base_assets_request_model.dart';

part 'change_base_asset_store.g.dart';

@lazySingleton
class ChangeBaseAssetStore = _ChangeBaseAssetStoreBase
    with _$ChangeBaseAssetStore;

abstract class _ChangeBaseAssetStoreBase with Store {
  _ChangeBaseAssetStoreBase() {
    loader = StackLoaderStore();
    _init();
  }
  static final _logger = Logger('ChangeBaseAssetStore');

  @observable
  StackLoaderStore? loader;

  @observable
  String checkedAsset = '';

  @observable
  ObservableList<String> assetsList = ObservableList.of([]);

  @action
  Future<void> changeBaseAsset(String newAsset) async {
    _logger.log(notifier, 'changeBaseAsset');

    if (newAsset != checkedAsset) {
      try {
        loader!.startLoading();
        final model = SetBaseAssetsRequestModel(
          assetSymbol: newAsset,
        );

        final _ = await sNetwork.getWalletModule().setBaseAsset(model);

        final baseCurrency = getIt<FormatService>().findCurrency(
          assetSymbol: newAsset,
        );

        sSignalRModules.setBaseCurrency(
          BaseCurrencyModel(
            prefix: baseCurrency.prefixSymbol,
            accuracy: baseCurrency.accuracy,
            symbol: baseCurrency.symbol,
          ),
        );
        setBaseAsset(newAsset);
      } catch (e) {
        _logger.log(stateFlow, 'changeBaseAsset', e);
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
  Future<void> finishLoading() async {
    if (loader!.loading) {
      loader!.finishLoading();
      loader!.finishLoadingImmediately();
      await sRouter.pop();
    }
  }

  @action
  Future<void> _init() async {
    final baseAsset = sSignalRModules.baseCurrency;
    setBaseAsset(baseAsset.symbol);

    final walletApi = sNetwork.getWalletModule();

    final request = await walletApi.getBaseAssetsList();

    request.pick(
      onData: (data) async {
        assetsList = ObservableList.of(data.data);
      },
      onError: (error) {},
    );
  }
}
