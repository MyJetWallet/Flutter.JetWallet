import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/change_password/model/change_password_request_model.dart';
import '../../../../../service/services/change_password/service/change_password_service.dart';
import '../../../../../shared/logging/levels.dart';
import 'change_password_state.dart';
import 'change_password_union.dart';

class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  ChangePasswordNotifier({
    required this.changePasswordService,
  }) : super(const ChangePasswordState());

  final ChangePasswordService changePasswordService;

  static final _logger = Logger('ChangePasswordNotifier');

  String? get oldPassword => state.oldPassword;

  String? get newPassword => state.newPassword;

  void setOldPassword(String? number) {
    _logger.log(notifier, 'setOldPassword');

    state = state.copyWith(oldPassword: number);
  }

  void setNewPassword(String? number) {
    _logger.log(notifier, 'setNewPassword');

    state = state.copyWith(newPassword: number);
  }

  bool activeButton() {
    _logger.log(notifier, 'activeButton');

    return state.oldPassword != '' && state.oldPassword != null;
  }

  Future<void> confirmNewPassword() async {
    _logger.log(notifier, 'confirmNewPassword');

    try {
      final model = ChangePasswordRequestModel(
        oldPassword: state.oldPassword!,
        newPassword: state.newPassword!,
      );

      await changePasswordService.confirmNewPassword(model);

      state = state.copyWith(union: const Done());
    } catch (e) {
      _logger.log(stateFlow, 'confirmNewPassword', e);

      state = state.copyWith(
        union: const Error('Try again that’s not your current password!'),
        oldPasswordValid: true,
      );
    }
  }

  void setInput() {
    _logger.log(notifier, 'setInput');

    state = state.copyWith(union: const Input());
  }
}
