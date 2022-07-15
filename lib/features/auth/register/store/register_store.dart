import 'package:flutter/cupertino.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/credentials_service/credentials_service.dart';
import 'package:jetwallet/core/services/simple_notifications/simple_notifications.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';

part 'register_store.g.dart';

class RegisterStore extends _RegisterStoreBase with _$RegisterStore {
  RegisterStore() : super();

  static _RegisterStoreBase of(BuildContext context) =>
      Provider.of<RegisterStore>(context, listen: false);
}

abstract class _RegisterStoreBase with Store {
  _RegisterStoreBase() {
    emailController.addListener(checkIsButtonActive);

    Future.delayed(
      const Duration(milliseconds: 300),
      emailFocusNode.requestFocus,
    );
  }

  final ScrollController customScrollController = ScrollController();
  final StackLoaderStore loader = StackLoaderStore();

  final formKey = GlobalKey<FormState>();
  final sNoty = getIt.get<SNotificationNotifier>();

  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  @observable
  bool emailError = false;
  @action
  bool setEmailError(bool value) => emailError = value;

  @action
  void checkIsButtonActive() {
    emailError = false;

    getIt
        .get<CredentialsService>()
        .updateAndValidateEmail(emailController.text);
  }

  void showError() {
    if (emailController.text.contains(' ')) {
      sNoty.showError(
        intl.register_invalidEmail,
        id: 2,
        needFeedback: true,
      );
    } else {
      sNoty.showError(
        '${intl.forgotPassword_error}?',
        id: 1,
        needFeedback: true,
      );
    }
  }

  void scrollToBottom() {
    customScrollController.animateTo(
      customScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @action
  void dispose() {
    emailController
      ..removeListener(checkIsButtonActive)
      ..dispose();

    emailFocusNode.dispose();
  }
}
