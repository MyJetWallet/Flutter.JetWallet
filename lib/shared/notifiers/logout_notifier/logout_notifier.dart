import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/services/authentication/model/logout/logout_request_model.dart';

import '../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../router/notifier/startup_notifier/authorized_union.dart'
    as authorized_union;
import '../../../router/notifier/startup_notifier/startup_notipod.dart';
import '../../../router/provider/authorization_stpod/authorization_stpod.dart';
import '../../../router/provider/authorization_stpod/authorization_union.dart';
import '../../logging/levels.dart';
import '../../providers/service_providers.dart';
import '../user_info_notifier/user_info_notipod.dart';
import 'logout_union.dart';

class LogoutNotifier extends StateNotifier<LogoutUnion> {
  LogoutNotifier(this.read) : super(const Result());

  final Reader read;

  static final _logger = Logger('LogoutNotifier');

  Future<void> logout({bool withLoading = true}) async {
    _logger.log(notifier, 'logout');

    try {
      if (withLoading) {
        state = const Loading();
      }

      final model = LogoutRequestModel(
        token: read(authInfoNotipod).token,
      );

      _syncLogout(model);
    } catch (e) {
      _logger.log(stateFlow, 'logout', e);
    } finally {
      await read(localStorageServicePod).clearStorage();

      if (read(startupNotipod).authorized is authorized_union.Home) {
        await read(signalRServicePod).disconnect();
      }

      read(authorizationStpod).state = const Unauthorized();
      read(userInfoNotipod.notifier).clear();
      read(authInfoNotipod.notifier).resetResendButton();

      unawaited(sAnalytics.logout());

      state = const Result();
    }
  }

  void _syncLogout(LogoutRequestModel model) {
    read(authServicePod).logout(model);
  }
}
