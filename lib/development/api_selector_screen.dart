import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../router/view/router.dart';
import '../shared/components/spacers.dart';
import '../shared/services/remote_config_service/service/remote_config_service.dart';

class ApiSelectorScreen extends HookWidget {
  ApiSelectorScreen({Key? key}) : super(key: key);

  static const routeName = '/api_selector_screen';

  final config = RemoteConfigService();

  @override
  Widget build(BuildContext context) {
    final index = useState(0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 50,
                diameterRatio: 1,
                onSelectedItemChanged: (value) => index.value = value,
                children: [
                  for (final flavor in config.connectionFlavors.flavors)
                    Center(child: Text(Uri.parse(flavor.tradingApi).host))
                ],
              ),
            ),
            const SpaceH40(),
            TextButton(
              onPressed: () {
                config.overrideApisFrom(index.value);
                Navigator.pushReplacementNamed(context, AppRouter.routeName);
              },
              child: const Text(
                'OK',
                style: TextStyle(
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
