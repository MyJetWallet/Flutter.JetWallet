import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../core/di/di.dart';
import '../../core/services/local_storage_service.dart';

class DebugInfo extends StatefulObserverWidget {
  const DebugInfo({Key? key}) : super(key: key);

  @override
  State<DebugInfo> createState() => _DebugInfoState();
}

class _DebugInfoState extends State<DebugInfo>
    with SingleTickerProviderStateMixin {
  bool isSlotA = true;

  @override
  void initState() {
    _checkActiveSlot();
    super.initState();
  }

  Future<void> _checkActiveSlot() async {
    final storageService = getIt.get<LocalStorageService>();
    final activeSlotUsing = await storageService.getValue(activeSlot);
    if (activeSlotUsing == 'slot b') {
      setState(() {
        isSlotA = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: 'Debug mode',
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Device pixel ratio: $devicePixelRatio',
                style: sTextH4Style,
              ),
              const SpaceH20(),
              SizedBox(
                width: 200,
                child:
                Row(
                  children: [
                    const Text('Slot B'),
                    const Spacer(),
                    Container(
                      width: 40.0,
                      height: 22.0,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Switch(
                        value: isSlotA,
                        onChanged: (bool newValue) {
                          final storageService =
                            getIt.get<LocalStorageService>();
                          storageService.setString(
                            activeSlot,
                            newValue ? 'slot a' : 'slot b',
                          );
                          setState(() {
                            isSlotA = !isSlotA;
                          });
                        },
                        activeColor: Colors.white,
                        activeTrackColor: Colors.black,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    const Text('Slot A'),
                  ],
                ),
              ),
              const SpaceH20(),
              // TextButton(
              //   onPressed: () {
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) {
              //           return Container();
              //           //return const ExampleScreen();
              //         },
              //       ),
              //     );
              //   },
              //   child: const Text(
              //     'Example Screen',
              //   ),
              // ),
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
      ),
    );
  }
}
