// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/simple_notifications/simple_notifications.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
part 'login_store.g.dart';

class LoginStore extends _LoginStoreBase with _$LoginStore {
  LoginStore({String? email}) : super(email);

  static _LoginStoreBase of(BuildContext context) =>
      Provider.of<LoginStore>(context, listen: false);
}

abstract class _LoginStoreBase with Store {
  _LoginStoreBase(String? email) {
    _email = email;
    emailController = TextEditingController(text: _email ?? '');

    emailController.addListener(checkIsButtonActive);
    passwordController.addListener(checkIsButtonActive);

    passwordFocusNode.addListener(_onFocusChange);
  }

  String? _email;

  final ScrollController customScrollController = ScrollController();
  final StackLoaderStore loader = StackLoaderStore();

  final formKey = GlobalKey<FormState>();

  late final TextEditingController emailController;
  final FocusNode emailFocusNode = FocusNode();

  @observable
  bool emailError = false;
  @action
  bool setEmailError(bool value) => emailError = value;

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
    isButtonActive = isEmailValid(emailController.text) &&
        isPasswordValid(passwordController.text) &&
        !disableContinue &&
        !loader.loading;
  }

  @action
  void disableError() {
    emailError = false;
    passwordError = false;
  }

  @action
  void showError(error) {
    disableContinue = false;
    loader.finishLoading();
    emailError = true;
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
    emailFocusNode.dispose();
    passwordFocusNode
      ..removeListener(_onFocusChange)
      ..dispose();

    emailController
      ..removeListener(checkIsButtonActive)
      ..dispose();
    passwordController
      ..removeListener(checkIsButtonActive)
      ..dispose();
  }

  void _onFocusChange() {
    if (passwordFocusNode.hasFocus) {
      customScrollController.animateTo(
        customScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }
}
