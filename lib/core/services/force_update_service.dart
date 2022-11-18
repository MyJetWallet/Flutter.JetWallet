import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/flavor_service.dart';
import 'package:jetwallet/core/services/package_info_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/utils/helpers/compare_version.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:store_redirect/store_redirect.dart';

class ForceServiceUpdate {
  final _info = getIt.get<PackageInfoService>().info;

  Future<ForceServiceUpdate> init() async {
    final minimum = compareVersions(minimumVersion, _info.version);
    final recommended = compareVersions(recommendedVersion, _info.version);

    if (minimum == VersionStatus.greater) {
      await Future.delayed(const Duration(microseconds: 1));

      showForceUpdateAlert();
    } else {
      if (recommended == VersionStatus.greater) {
        await Future.delayed(const Duration(microseconds: 1));

        showRecommendedUpdateAlert();
      }
    }

    return this;
  }

  void showForceUpdateAlert() {
    // sShowAlertPopup(
    //   sRouter.navigatorKey.currentContext!,
    //   willPopScope: false,
    //   primaryText: '${intl.update_timeToUpdate}!',
    //   secondaryText: intl.update_downloadTheLatestVersion,
    //   primaryButtonName: intl.update_update,
    //   onPrimaryButtonTap: () => _storeRedirect(),
    // );
  }

  void showRecommendedUpdateAlert() {
    sShowAlertPopup(
      sRouter.navigatorKey.currentContext!,
      willPopScope: false,
      primaryText: '${intl.update_updateSimple}?',
      secondaryText: intl.update_weRecommendUpdateLatestVersion,
      primaryButtonName: intl.update_update,
      onPrimaryButtonTap: () => _storeRedirect(),
      secondaryButtonName: intl.update_notNow,
      onSecondaryButtonTap: () {
        Navigator.pop(sRouter.navigatorKey.currentContext!);
      },
    );
  }

  void _storeRedirect() {
    final flavor = flavorService();

    late String appId;

    if (flavor == Flavor.prod) {
      appId = '1603406843';
    } else if (flavor == Flavor.stage) {
      appId = '1604368566';
    } else {
      appId = '1604368665';
    }

    StoreRedirect.redirect(
      androidAppId: _info.packageName,
      iOSAppId: appId,
    );
  }
}
