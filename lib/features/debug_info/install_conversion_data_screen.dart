import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/apps_flyer_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../core/l10n/i10n.dart';

@RoutePage(name: 'InstallConversionDataRouter')
class InstallConversionDataScreen extends StatelessObserverWidget {
  const InstallConversionDataScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final installConversionData = getIt.get<AppsFlyerService>().tempInstallConversionData;

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: 'Install Conversion Data',
          showInfoButton: true,
          onInfoButtonTap: () => Share.share(installConversionData),
        ),
      ),
      child: SPaddingH24(
        child: Text(installConversionData),
      ),
    );
  }
}
