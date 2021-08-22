import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

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

  if (router.state == const Authorized()) {
    try {
      final info = await service.sessionInfo();

      if (info.emailVerified) {
        authorized.state = const Home();
      } else {
        authorized.state = const EmailVerification();
      }
    } catch (e) {
      _logger.warning('Failed to fetch session info', e);
    }
  }
});
