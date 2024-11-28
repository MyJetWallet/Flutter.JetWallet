import 'package:auto_route/auto_route.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

part 'bottom_bar_store.g.dart';

class BottomBarStore = _BottomBarStoreBase with _$BottomBarStore;

abstract class _BottomBarStoreBase with Store {
  @observable
  BottomItemType homeTab = BottomItemType.home;
  @action
  void setHomeTab(BottomItemType value) {
    homeTab = value;
    final index = bottomBarItems.indexOf(homeTab);
    _tabsRouter?.setActiveIndex(index);

    if (value == BottomItemType.home) {
      if ((sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
        (element) => element.id == AssetPaymentProductsEnum.jar,
      )) {
        getIt.get<JarsStore>().refreshJarsStore();
      }
    }
  }

  @observable
  TabsRouter? _tabsRouter;
  @action
  void setTabsRouter(TabsRouter value) {
    _tabsRouter = value;
  }

  TabsRouter? get getTabsRouter => _tabsRouter;

  @computed
  int get cerrentIndex => bottomBarItems.indexOf(homeTab);

  @computed
  ObservableList<BottomItemType> get bottomBarItems => ObservableList.of([
        BottomItemType.home,
        BottomItemType.market,
        if ((sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
          (element) => element.id == AssetPaymentProductsEnum.earnProgram,
        )) ...[
          BottomItemType.earn,
        ],
        if ((sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
          (element) => element.id == AssetPaymentProductsEnum.investProgram,
        )) ...[
          BottomItemType.invest,
        ],
        if ((sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
          (element) => element.id == AssetPaymentProductsEnum.cardPreorder,
        )) ...[
          BottomItemType.card,
        ],
        if ((sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
          (element) => element.id == AssetPaymentProductsEnum.cryptoCard,
        )) ...[
          BottomItemType.cryptoCard,
        ],
        if ((sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
          (element) => element.id == AssetPaymentProductsEnum.rewardsOnboardingProgram,
        )) ...[
          BottomItemType.rewards,
        ],
      ]);
}
