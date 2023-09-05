import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/package_info_service.dart';
import 'package:simple_kit/simple_kit.dart';

class AppVersionBox extends StatelessObserverWidget {
  const AppVersionBox({super.key});

  @override
  Widget build(BuildContext context) {
    final packageInfo = getIt.get<PackageInfoService>().info;
    final colors = sKit.colors;

    return packageInfo.version != 'unknown' &&
            packageInfo.buildNumber != 'unknown'
        ? Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 10.0,
            ),
            decoration: BoxDecoration(
              color: colors.grey5,
              borderRadius: BorderRadius.circular(16.0),
            ),
            alignment: Alignment.center,
            height: 26.0,
            child: Text(
              '${intl.appVersionBox_version}: ${packageInfo.version}'
              ' (${packageInfo.buildNumber})',
              style: sCaptionTextStyle.copyWith(
                color: colors.grey1,
              ),
            ),
          )
        : const SizedBox();
  }
}
