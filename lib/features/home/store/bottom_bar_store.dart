import 'package:auto_route/auto_route.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

part 'bottom_bar_store.g.dart';

class BottomBarStore = _BottomBarStoreBase with _$BottomBarStore;

abstract class _BottomBarStoreBase with Store {
  @observable
  BottomItemType homeTab = BottomItemType.wallets;
  @action
  void setHomeTab(BottomItemType value) {
    homeTab = value;
    final index = bottomBarItems.indexOf(homeTab);
    _tabsRouter?.setActiveIndex(index);
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
        BottomItemType.wallets,
        BottomItemType.market,
        if ((sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
          (element) => element.id == AssetPaymentProductsEnum.earnProgram,
        )) ...[
          BottomItemType.earn,
        ],
        if ((sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
            .where(
              (element) => element.id == AssetPaymentProductsEnum.investProgram,
            )
            .isNotEmpty) ...[
          BottomItemType.invest,
        ],
        if (sUserInfo.cardAvailable && displayCardPreorderScreen) ...[
          BottomItemType.card,
        ],
        if ((sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
            .where(
              (element) => element.id == AssetPaymentProductsEnum.rewardsOnboardingProgram,
            )
            .isNotEmpty) ...[
          BottomItemType.rewards,
        ],
      ]);
}
