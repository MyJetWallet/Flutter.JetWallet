import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:store_redirect/store_redirect.dart';

import '../../../shared/providers/flavor_pod.dart';
import '../../../shared/providers/package_info_fpod.dart';
import '../../../shared/providers/service_providers.dart';
import '../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../helper/compare_versions.dart';
import 'update_union.dart';

class UpdateNotifier extends StateNotifier<UpdateUnion> {
  UpdateNotifier(this.read) : super(const UpdateUnion.noUpdates()) {
    _context = read(sNavigatorKeyPod).currentContext!;
    _info = read(packageInfoPod);
    _initState();
  }

  final Reader read;

  late BuildContext _context;
  late PackageInfo _info;

  void updateState() {
    state = const ShowingAlert();
  }

  Future<void> _initState() async {
    final minimum = compareVersions(minimumVersion, _info.version);
    final recommended = compareVersions(recommendedVersion, _info.version);

    if (minimum == VersionStatus.greater) {
      state = const ShowingAlert();
      await Future.delayed(const Duration(microseconds: 1));

      showForceUpdateAlert();
    } else {
      if (recommended == VersionStatus.greater) {
        state = const ShowingAlert();
        await Future.delayed(const Duration(microseconds: 1));

        showRecommendedUpdateAlert();
      } else {
        state = const NoUpdates();
      }
    }
  }

  void showForceUpdateAlert() {
    final intl = read(intlPod);

    sShowAlertPopup(
      _context,
      willPopScope: false,
      primaryText: '${intl.updateNotifier_timeToUpdate}!',
      secondaryText: intl.updateNotifier_downloadTheLatestVersion,
      primaryButtonName: intl.updateNotifier_update,
      onPrimaryButtonTap: () => _storeRedirect(),
    );
  }

  void showRecommendedUpdateAlert() {
    final intl = read(intlPod);

    sShowAlertPopup(
      _context,
      willPopScope: false,
      primaryText: '${intl.updateNotifier_updateSimple}?',
      secondaryText: intl.updateNotifier_weRecommendUpdateLatestVersion,
      primaryButtonName: intl.updateNotifier_update,
      onPrimaryButtonTap: () => _storeRedirect(),
      secondaryButtonName: intl.updateNotifier_notNow,
      onSecondaryButtonTap: () {
        Navigator.pop(_context);
        state = const NoUpdates();
      },
    );
  }

  void _storeRedirect() {
    final flavor = read(flavorPod);

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
