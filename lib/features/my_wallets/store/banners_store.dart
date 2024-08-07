import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/deep_link_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/baner_model.dart';
import 'package:simple_networking/modules/wallet_api/models/banners/close_banner_request_model.dart';

part 'banners_store.g.dart';

class BannersStore extends _BannersStoreBase with _$BannersStore {
  BannersStore({required super.vsync}) : super();

  static _BannersStoreBase of(BuildContext context) => Provider.of<BannersStore>(context, listen: false);
}

abstract class _BannersStoreBase with Store {
  _BannersStoreBase({required this.vsync}) {
    updateBannersLists();

    updateTabController();

    addListener();

    reaction(
      (_) => sSignalRModules.banersListMessage,
      (msg) {
        controller.dispose();

        updateBannersLists();

        updateTabController();

        addListener();
      },
    );
  }

  final TickerProvider vsync;

  @observable
  ObservableList<BanerModel> marketingBanners = ObservableList.of([]);

  @observable
  ObservableList<BanerModel> profileBanners = ObservableList.of([]);

  @observable
  ObservableList<BanerModel> productBanners = ObservableList.of([]);

  @observable
  late TabController controller;

  @observable
  int selectedIndex = 0;

  void updateBannersLists() {
    final allbanners = sSignalRModules.banersListMessage.banners;

    marketingBanners = ObservableList.of(
      allbanners.where((banner) => banner.group == BanerGroupType.marketing),
    );
    profileBanners = ObservableList.of(
      allbanners.where((banner) => banner.group == BanerGroupType.profile),
    );
    productBanners = ObservableList.of(
      allbanners.where((banner) => banner.group == BanerGroupType.product),
    );
  }

  @action
  void addListener() {
    controller.animation!.addListener(
      () {
        if (controller.indexIsChanging) {
          if (selectedIndex != controller.index) {
            selectedIndex = controller.index;
          }
        } else {
          final temp = controller.animation!.value.round();
          if (selectedIndex != temp) {
            selectedIndex = temp;

            controller.index = selectedIndex;
          }
        }
      },
    );
  }

  @action
  void onBannerTap(BanerModel baner) {
    sAnalytics.tapOnTheBanner(
      bannerId: baner.bannerId,
      bannerTitle: baner.title ?? '',
    );
    final action = baner.action;
    if (action != null) {
      getIt.get<DeepLinkService>().handle(Uri.parse(action));
    }
  }

  @action
  Future<void> onCloseBannerTap(BanerModel baner) async {
    sAnalytics.closeBanner(
      bannerId: baner.bannerId,
      bannerTitle: baner.title ?? '',
    );

    marketingBanners.removeWhere((element) => element.bannerId == baner.bannerId);

    await sNetwork.getWalletModule().postCloseBanner(
          CloseBannerRequestModel(
            bannerId: baner.bannerId,
          ),
        );
  }

  @action
  void updateTabController() {
    final newSelectedIndex = marketingBanners.isNotEmpty ? min(selectedIndex, marketingBanners.length - 1) : 0;
    controller = TabController(
      initialIndex: newSelectedIndex,
      length: marketingBanners.length,
      vsync: vsync,
      animationDuration: const Duration(milliseconds: 100),
    );
  }

  void dispose() {
    controller.dispose();
  }
}
