import 'package:auto_route/auto_route.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/deep_link_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/push_notification.dart';
import 'package:jetwallet/core/services/route_query_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/sumsub_service/sumsub_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';

import '../../core/di/di.dart';
import '../../core/services/local_storage_service.dart';

@RoutePage(name: 'DebugInfoRouter')
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getIt<AppStore>().sessionID,
                  style: sBodyText2Style,
                ),
                const SpaceH10(),
                Text(
                  'Device pixel ratio: $devicePixelRatio',
                  style: sTextH5Style,
                ),
                const SpaceH20(),
                SizedBox(
                  width: 200,
                  child: Row(
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
                TextButton(
                  onPressed: () {
                    getIt<AppRouter>().push(const SignalrDebugInfoRouter());
                  },
                  child: const Text(
                    'SignalR Logs',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    /*getIt.get<DeepLinkService>().handle(
                          Uri.parse(
                              'http://simple.app/action/jw_swap/jw_operation_id/a93fa24f9f544774863e4e7b4c07f3c0'),
                        );*/

                    await sRouter.push(const LogsRouter());
                  },
                  child: const Text(
                    'Logs screen',
                  ),
                ),
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
                TextButton(
                  onPressed: () async {
                    getIt<AppStore>().updateAuthState(
                      token: 'CRASHME',
                    );

                    final infoRequest =
                        await sNetwork.getAuthModule().postSessionCheck();
                  },
                  child: const Text(
                    'Simulate 401',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    getIt<AppStore>().updateAuthState(
                      token: 'CRASHME',
                      refreshToken: 'CRASHME',
                    );

                    final infoRequest =
                        await sNetwork.getAuthModule().postSessionCheck();
                  },
                  child: const Text(
                    'Simulate refresh token is break',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    getIt<AppStore>().generateNewSessionID();
                  },
                  child: const Text(
                    'Change Session ID (Simulate error)',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    getIt.get<SignalRService>().signalR!.simulateError();
                  },
                  child: const Text(
                    'Simulate signalr error',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await getIt
                        .get<SignalRService>()
                        .signalR!
                        .disconnect('DEBUG');
                  },
                  child: const Text(
                    'kill signalr',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      final resp =
                          await sNetwork.getWalletModule().debugError();

                      if (resp.hasError) {
                        sNotification.showError(
                          resp.error!.cause,
                          id: 1,
                        );
                      }
                    } on ServerRejectException catch (error) {
                      sNotification.showError(
                        error.cause,
                        id: 1,
                      );
                    }
                  },
                  child: const Text(
                    'Simulate 500 error',
                  ),
                ),

                TextButton(
                  onPressed: () async {
                    try {
                      final resp =
                          await sNetwork.getWalletModule().debugReject();

                      if (resp.hasError) {
                        sNotification.showError(
                          resp.error!.cause,
                          id: 1,
                        );
                      }
                    } on ServerRejectException catch (error) {
                      sNotification.showError(
                        error.cause,
                        id: 1,
                      );
                    }
                  },
                  child: const Text(
                    'Simulate 200 reject',
                  ),
                ),

                TextButton(
                  onPressed: () async {
                    await sRouter.push(
                      const KycVerificationSumsubRouter(),
                    );
                  },
                  child: const Text(
                    'Sumsub',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await sRouter.push(
                      SuccessScreenRouter(
                        secondaryText: 'intl.previewConvert_orderProcessing',
                      ),
                    );
                  },
                  child: const Text(
                    'Success',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
