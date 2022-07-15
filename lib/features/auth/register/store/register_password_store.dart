import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/credentials_service/credentials_service.dart';
import 'package:jetwallet/core/services/simple_notifications/simple_notifications.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
part 'register_password_store.g.dart';

class RegisterPasswordStore extends _RegisterPasswordStoreBase
    with _$RegisterPasswordStore {
  RegisterPasswordStore() : super();

  static _RegisterPasswordStoreBase of(BuildContext context) =>
      Provider.of<RegisterPasswordStore>(context, listen: false);
}

abstract class _RegisterPasswordStoreBase with Store {
  _RegisterPasswordStoreBase() {
    passwordController.addListener(checkIsButtonActive);
  }

  final ScrollController customScrollController = ScrollController();
  final StackLoaderStore loader = StackLoaderStore();

  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();

  @observable
  bool passwordError = false;
  @action
  bool setPasswordError(bool value) => passwordError = value;

  @observable
  bool disableContinue = false;
  @action
  bool setDisableContinue(bool value) => disableContinue = value;

  @observable
  bool isButtonActive = false;

  @action
  void checkIsButtonActive() {
    getIt
        .get<CredentialsService>()
        .updateAndValidatePassword(passwordController.text);

    isButtonActive = getIt.get<CredentialsService>().readyToRegister &&
        !disableContinue &&
        !loader.loading;
  }

  @action
  void showError(error) {
    disableContinue = false;
    loader.finishLoading();
    passwordError = true;

    getIt.get<SNotificationNotifier>().showError(
          error.toString(),
          duration: 4,
          id: 1,
          needFeedback: true,
        );
  }

  @action
  void dispose() {
    passwordController
      ..removeListener(checkIsButtonActive)
      ..dispose();

    passwordFocusNode.dispose();
  }
}
