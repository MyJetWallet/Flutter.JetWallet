import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/package_info_service.dart';

class AppVersionBox extends StatelessObserverWidget {
  const AppVersionBox({super.key});

  @override
  Widget build(BuildContext context) {
    final packageInfo = getIt.get<PackageInfoService>().info;
    final colors = SColorsLight();

    return packageInfo.version != 'unknown' && packageInfo.buildNumber != 'unknown'
        ? Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 10.0,
            ),
            decoration: BoxDecoration(
              color: colors.gray2,
              borderRadius: BorderRadius.circular(16.0),
            ),
            alignment: Alignment.center,
            height: 26.0,
            child: Text(
              '${intl.appVersionBox_version}: ${packageInfo.version}'
              ' (${packageInfo.buildNumber})',
              style: STStyles.captionMedium.copyWith(
                color: colors.gray10,
              ),
            ),
          )
        : const SizedBox();
  }
}
