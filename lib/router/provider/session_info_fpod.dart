import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../shared/providers/service_providers.dart';
import 'authorized_stpod/authorized_stpod.dart';
import 'authorized_stpod/authorized_union.dart';
import 'router_stpod/router_stpod.dart';
import 'router_stpod/router_union.dart';

final sessionInfoFpod = FutureProvider<void>((ref) async {
  final _logger = Logger('sessionInfoFpod');

  final service = ref.read(infoServicePod);
  final router = ref.watch(routerStpod);
  final authorized = ref.watch(authorizedStpod.notifier);
  final userInfo = ref.read(userInfoNotipod);
  final userInfoN = ref.watch(userInfoNotipod.notifier);

  if (router.state == const Authorized()) {
    try {
      final info = await service.sessionInfo();

      userInfoN.updateTwoFaStatus(
        enabled: info.twoFaEnabled,
      );

      if (info.emailVerified) {
        if (userInfo.pinEnabled) {
          authorized.state = const PinVerification();
        } else {
          authorized.state = const Home();
        }
      } else {
        authorized.state = const EmailVerification();
      }
    } catch (e) {
      _logger.warning('Failed to fetch session info', e);
    }
  }
});
