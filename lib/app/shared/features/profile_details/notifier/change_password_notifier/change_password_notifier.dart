import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_networking/services/change_password/model/change_password_request_model.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import 'change_password_state.dart';
import 'change_password_union.dart';

class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  ChangePasswordNotifier({
    required this.read,
  }) : super(const ChangePasswordState());

  final Reader read;

  static final _logger = Logger('ChangePasswordNotifier');

  void setOldPassword(String password) {
    _logger.log(notifier, 'setOldPassword');

    state = state.copyWith(oldPassword: password);
  }

  void setNewPassword(String password) {
    _logger.log(notifier, 'setNewPassword');

    state = state.copyWith(newPassword: password);
  }

  Future<void> confirmNewPassword() async {
    _logger.log(notifier, 'confirmNewPassword');

    try {
      final model = ChangePasswordRequestModel(
        oldPassword: state.oldPassword,
        newPassword: state.newPassword,
      );

      await read(changePasswordSerivcePod).confirmNewPassword(model);

      state = state.copyWith(union: const Done());
    } catch (e) {
      _logger.log(stateFlow, 'confirmNewPassword', e);

      state = state.copyWith(
        union: const Error('Try again that’s not your current password!'),
      );
    }
  }

  void setInput() {
    _logger.log(notifier, 'setInput');

    state = state.copyWith(union: const Input());
  }
}
