import 'package:flutter/material.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

part 'prepaid_card_promo_banner_store.g.dart';

bool _isBanerWasClosedGlobal = true;

class PrepaidCardPromoBannerStore extends _PrepaidCardPromoBannerStoreBase with _$PrepaidCardPromoBannerStore {
  PrepaidCardPromoBannerStore() : super();

  static _PrepaidCardPromoBannerStoreBase of(BuildContext context) => Provider.of<PrepaidCardPromoBannerStore>(context);
}

abstract class _PrepaidCardPromoBannerStoreBase with Store {
  _PrepaidCardPromoBannerStoreBase() {
    isBanerWasClosed = _isBanerWasClosedGlobal;
    _checkIsNeedToShowBanner();
  }
  @computed
  bool get isShowBanner => isPrepaidCardMethodAvaible && !isBanerWasClosed;

  @computed
  bool get isPrepaidCardMethodAvaible => (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
      .any((element) => element.id == AssetPaymentProductsEnum.prepaidCard);

  @observable
  bool isBanerWasClosed = false;

  Future<void> _checkIsNeedToShowBanner() async {
    final checkClosedBanner = await sLocalStorageService.getValue(isPerapaidCardBannerClosed);
    final isBanerWasClosed = checkClosedBanner == 'true';

    _isBanerWasClosedGlobal = isBanerWasClosed;
  }

  @action
  void onBannerTap() {
    sAnalytics.tapOnTheBunnerPrepaidCardOnWallet();
    sRouter.push(const AccountRouter());
  }

  @action
  void onCloseBannerTap() {
    sAnalytics.tapOnTheCloseButtonOnBunnerPrepaidCard();
    isBanerWasClosed = true;
    _isBanerWasClosedGlobal = isShowBanner;
    sLocalStorageService.setString(isPerapaidCardBannerClosed, 'true');
  }
}
