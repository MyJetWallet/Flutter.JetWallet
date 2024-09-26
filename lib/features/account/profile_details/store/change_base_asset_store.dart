import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/wallet_api/models/base_asset/set_base_assets_request_model.dart';

part 'change_base_asset_store.g.dart';

@lazySingleton
class ChangeBaseAssetStore = _ChangeBaseAssetStoreBase with _$ChangeBaseAssetStore;

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
        loader!.startLoadingImmediately();
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
      } finally {
        //await finishLoading();
      }
    } else {
      await sRouter.maybePop();
    }
  }

  @action
  void setBaseAsset(String newAsset) {
    _logger.log(notifier, 'setBaseAsset');
    checkedAsset = newAsset;

    if ((sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
          (element) => element.id == AssetPaymentProductsEnum.jar,
    )) {
      getIt.get<JarsStore>().refreshJarsStore();
    }
  }

  @action
  Future<void> finishLoading() async {
    if (loader!.loading) {
      loader!.finishLoading();
      loader!.finishLoadingImmediately();
      await sRouter.maybePop();
    }
  }

  @action
  Future<void> _init() async {
    final baseAsset = sSignalRModules.baseCurrency;
    setBaseAsset(baseAsset.symbol);

    final walletApi = sNetwork.getWalletModule();

    await Future.delayed(const Duration(seconds: 1));

    final request = await walletApi.getBaseAssetsList();

    request.pick(
      onData: (data) async {
        assetsList = ObservableList.of(data.data);
      },
      onError: (error) {},
    );
  }
}
