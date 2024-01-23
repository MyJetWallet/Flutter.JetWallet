import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/push_notification_service.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart' as sk;

@RoutePage(name: 'PushPermissionRoute')
class PushPermissionScreen extends StatefulWidget {
  const PushPermissionScreen({super.key});

  @override
  State<PushPermissionScreen> createState() => _PushPermissionScreenState();
}

class _PushPermissionScreenState extends State<PushPermissionScreen> {
  @override
  void initState() {
    sAnalytics.pushNotificationSV();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: '',
      color: sk.SColorsLight().gray2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Lottie.asset(
                'assets/animations/push_notification.json',
                width: 327,
                height: 405,
              ),
              Text(
                intl.permission_title,
                maxLines: 12,
                textAlign: TextAlign.center,
                style: sk.STStyles.header3,
              ),
              const SizedBox(height: 16),
              Text(
                intl.permission_subtitle,
                maxLines: 12,
                textAlign: TextAlign.center,
                style: sk.STStyles.subtitle1.copyWith(
                  color: sk.SColorsLight().gray10,
                ),
              ),
              const Spacer(),
              sk.SButton.black(
                callback: () async {
                  sAnalytics.pushNotificationButtonTap();

                  if (getIt.isRegistered<PushNotificationService>()) {
                    await getIt.get<PushNotificationService>().requestPermission().then((value) {
                      getIt.get<StartupService>().successfullAuthentication(needPush: false);
                    });
                  }
                },
                text: intl.permission_button,
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
            ],
          ),
        ),
      ),
    );
  }
}
