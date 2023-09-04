import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/account/profile_details/models/change_password_union.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/auth_api/models/change_password/change_password_request_model.dart';

part 'change_password_store.g.dart';

class ChangePasswordStore = _ChangePasswordStoreBase with _$ChangePasswordStore;

abstract class _ChangePasswordStoreBase with Store {
  static final _logger = Logger('ChangePasswordStore');

  @observable
  String oldPassword = '';

  @observable
  String newPassword = '';

  @observable
  ChangePasswordUnion union = const ChangePasswordUnion.input();

  @observable
  bool oldPasswordError = false;
  @action
  bool setOldPasswordError(bool value) => oldPasswordError = value;

  @computed
  bool get isButtonActive {
    return oldPassword.isNotEmpty;
  }

  @computed
  bool get isNewPasswordButtonActive {
    return isPasswordValid(newPassword);
  }

  @action
  void setOldPassword(String password) {
    _logger.log(notifier, 'setOldPassword');

    oldPassword = password;
  }

  @action
  void setNewPassword(String password) {
    _logger.log(notifier, 'setNewPassword');

    newPassword = password;
  }

  @action
  Future<void> confirmNewPassword() async {
    _logger.log(notifier, 'confirmNewPassword');

    try {
      final model = ChangePasswordRequestModel(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      final _ = await sNetwork.getAuthModule().poshConfirmNewPassword(model);

      union = const ChangePasswordUnion.done();
    } catch (e) {
      _logger.log(stateFlow, 'confirmNewPassword', e);

      union = ChangePasswordUnion.error(
        '${intl.changePassword_errorCurrentPassword}!',
      );
    }
  }

  @action
  void setInput() {
    _logger.log(notifier, 'setInput');

    union = const ChangePasswordUnion.input();
  }
}
