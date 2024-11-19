import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

part 'jars_banner_store.g.dart';

class JarsBannerStore extends _JarsBannerStoreBase with _$JarsBannerStore {
  JarsBannerStore() : super();

  static _JarsBannerStoreBase of(BuildContext context) => Provider.of<JarsBannerStore>(context);
}

abstract class _JarsBannerStoreBase with Store {
  @computed
  bool get showBanner => landingUrl.isNotEmpty && !isBannerClosed;

  @observable
  bool isBannerClosed = true;

  @observable
  String landingUrl = '';

  @action
  Future<void> init() async {
    // landingUrl = jarsInfoLanding;
    landingUrl = 'https://uat.simple-spot.biz/lp/jars/';

    isBannerClosed =
        bool.tryParse(await getIt.get<LocalStorageService>().getValue(isJarsLandingClosed) ?? 'false') ?? false;
  }

  @action
  void closeBanner() {
    isBannerClosed = true;
    getIt.get<LocalStorageService>().setString(isJarsLandingClosed, 'true');
  }

  void openLanding(BuildContext context) {
    if (landingUrl.isNotEmpty) {
      launchURL(context, landingUrl, launchMode: LaunchMode.platformDefault);
    }
  }
}
