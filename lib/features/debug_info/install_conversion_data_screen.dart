import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/apps_flyer_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../core/l10n/i10n.dart';

@RoutePage(name: 'InstallConversionDataRouter')
class InstallConversionDataScreen extends StatelessObserverWidget {
  const InstallConversionDataScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final storage = sLocalStorageService;
    final installConversionDataTemp = getIt.get<AppsFlyerService>().installConversionDataTemp;

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      header: const GlobalBasicAppBar(
        title: 'Install Conversion Data',
        hasRightIcon: false,
      ),
      child: SPaddingH24(
        child: Column(
          children: [
            const Text('Install conversion data on this run:'),
            Text(installConversionDataTemp),
            const Text('Install conversion data on first run:'),
            FutureBuilder<String?>(
              future: storage.getValue(installConversionDataKey),
              builder: (context, snap) =>
                  Text(snap.connectionState == ConnectionState.done ? snap.data ?? 'empty' : 'Loading...'),
            ),
            const Text('last onelinkData:'),
            FutureBuilder<String?>(
              future: storage.getValue(onelinkDataKey),
              builder: (context, snap) =>
                  Text(snap.connectionState == ConnectionState.done ? snap.data ?? 'empty' : 'Loading...'),
            ),
          ],
        ),
      ),
    );
  }
}
