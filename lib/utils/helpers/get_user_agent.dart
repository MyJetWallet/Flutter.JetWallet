import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/local_cache/local_cache_service.dart';
import 'package:jetwallet/core/services/package_info_service.dart';
import 'package:jetwallet/utils/helpers/device_helper.dart';

Future<String> getUserAgent() async {
  var lang = 'en';

  if (getIt.isRegistered<AppLocalizations>()) {
    lang = intl.localeName;
  }

  final deviceInfo = getIt.get<DeviceInfo>();
  final packageInfo = getIt.get<PackageInfoService>().info;
  final appVersion = packageInfo.version;
  final instllID = await getIt<LocalCacheService>().getInstallID();

  if (sRouter.navigatorKey.currentContext != null) {
    final mediaQuery = MediaQuery.of(sRouter.navigatorKey.currentContext!);

    final deviceSize = mediaQuery.size;
    final devicePixelRatio = mediaQuery.devicePixelRatio;

    return '$appVersion;${packageInfo.buildNumber};$deviceType;$deviceSize;'
        '''$devicePixelRatio;$lang;${deviceInfo.marketingName};${deviceInfo.deviceUid};$instllID''';
  } else {
    return '$appVersion;${packageInfo.buildNumber};$deviceType;unknown;'
        '''unknown;$lang;${deviceInfo.marketingName};${deviceInfo.deviceUid};$instllID''';
  }
}
