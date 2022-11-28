import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:simple_kit/simple_kit.dart';

class DebugInfo extends StatelessObserverWidget {
  const DebugInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Device pixel ratio: $devicePixelRatio',
              style: sTextH4Style,
            ),
            const SpaceH20(),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Container();
                      //return const ExampleScreen();
                    },
                  ),
                );
              },
              child: const Text(
                'Example Screen',
              ),
            ),
            TextButton(
              onPressed: () async {
                sNotification.showError(
                  'Perhaps you missed “.” or “@” somewhere?”',
                  id: 1,
                );
              },
              child: const Text(
                'Show notification',
              ),
            ),
            TextButton(
              onPressed: () async {
                FirebaseCrashlytics.instance.crash();
              },
              child: const Text(
                'Trigger crash',
              ),
            ),
            TextButton(
              onPressed: () async {
                throw 'You triggered error at ${DateTime.now()}';
              },
              child: const Text(
                'Trigger error',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
