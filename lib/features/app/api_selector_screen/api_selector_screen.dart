import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/dio_proxy_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/simple_kit.dart';

//final _config = RemoteConfigService();

@RoutePage(name: 'ApiSelectorRouter')
class ApiSelectorScreen extends StatelessObserverWidget {
  const ApiSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final index = useState(0);
    final dioProxy = getIt.get<DioProxyService>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SPaddingH24(
              child: SStandardField(
                labelText: intl.apiSelectorScreen_provideProxy,
                onChanged: (value) => dioProxy.updateProxyName(value),
                onErase: () => dioProxy.updateProxyName(''),
              ),
            ),
            SPaddingH24(
              child: Row(
                children: [
                  const SErrorIcon(),
                  const SpaceW10(),
                  Flexible(
                    child: Text(
                      intl.apiSelector_justSkip,
                      maxLines: 3,
                      style: sBodyText2Style.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /*
            Expanded(
              child: CupertinoPicker(
                itemExtent: 50,
                diameterRatio: 1,
                onSelectedItemChanged: (value) => index.value = value,
                children: [
                  for (final flavor in _config.connectionFlavors.flavors)
                    Center(
                      child: Text(
                        apiTitleFromUrl(flavor.candlesApi),
                        style: const TextStyle(color: Colors.black),
                      ),
                    )
                ],
              ),
            ),
            */
            const SpaceH40(),
            TextButton(
              onPressed: () {
                dioProxy.proxySkip();

                getIt<AppStore>().checkInitRouter();
              },
              child: Text(
                intl.serverCode0_ok,
                style: const TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
