import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../auth/screens/splash/view/splash_screen.dart';
import '../../../../shared/components/spacers.dart';
import '../../../../shared/services/remote_config_service/service/remote_config_service.dart';
import '../helper/api_title_from.dart';

final _config = RemoteConfigService();

class ApiSelectorScreen extends HookWidget {
  const ApiSelectorScreen({Key? key}) : super(key: key);

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
                  for (final flavor in _config.connectionFlavors.flavors)
                    Center(
                      child: Text(
                        apiTitleFromUrl(flavor.candlesApi),
                      ),
                    )
                ],
              ),
            ),
            const SpaceH40(),
            TextButton(
              onPressed: () {
                _config.overrideApisFrom(index.value);
                Navigator.pushReplacementNamed(context, SplashScreen.routeName);
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
