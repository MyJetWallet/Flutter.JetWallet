// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/flavor_service.dart';
import 'package:jetwallet/core/services/package_info_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/helpers/compare_version.dart';
import 'package:store_redirect/store_redirect.dart';

class ForceServiceUpdate {
  bool isAnyDialogOpened = false;

  /// If return true, means need update
  Future<bool> init({
    BuildContext? context,
    bool showPopup = false,
  }) async {
    final info = getIt.get<PackageInfoService>().info;

    final minimum = compareVersions(minimumVersion, info.version);
    final recommended = compareVersions(recommendedVersion, info.version);

    if (info.version == '1.0.0') {
      return false;
    }

    if (minimum == VersionStatus.greater) {
      await Future.delayed(const Duration(microseconds: 1));

      if (showPopup && context != null && !isAnyDialogOpened) {
        showForceUpdateAlert(context);
      }

      return true;
    } else {
      if (recommended == VersionStatus.greater) {
        await Future.delayed(const Duration(microseconds: 1));

        if (showPopup && context != null && !isAnyDialogOpened) {
          showRecommendedUpdateAlert(context);
        }

        return true;
      }
    }

    return false;
  }

  void showForceUpdateAlert(BuildContext context) {
    isAnyDialogOpened = true;

    sShowAlertPopup(
      context,
      willPopScope: false,
      primaryText: '${intl.update_timeToUpdate}!',
      secondaryText: intl.update_downloadTheLatestVersion,
      primaryButtonName: intl.update_update,
      onPrimaryButtonTap: () => _storeRedirect(),
    );
  }

  void showRecommendedUpdateAlert(BuildContext context) {
    isAnyDialogOpened = true;

    sShowAlertPopup(
      context,
      willPopScope: false,
      primaryText: '${intl.update_updateSimple}?',
      secondaryText: intl.update_weRecommendUpdateLatestVersion,
      primaryButtonName: intl.update_update,
      onPrimaryButtonTap: () => _storeRedirect(),
      secondaryButtonName: intl.update_notNow,
      onSecondaryButtonTap: () {
        Navigator.pop(sRouter.navigatorKey.currentContext!);

        isAnyDialogOpened = false;

        getIt<AppStore>().setSkipVersionCheck(true);
        getIt<AppStore>().checkInitRouter();
      },
    );
  }

  void _storeRedirect() {
    final info = getIt.get<PackageInfoService>().info;
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
      androidAppId: info.packageName,
      iOSAppId: appId,
    );
  }
}
