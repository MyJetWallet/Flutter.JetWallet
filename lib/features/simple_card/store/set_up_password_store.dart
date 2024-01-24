import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_set_password_request.dart';

import '../../../core/di/di.dart';

part 'set_up_password_store.g.dart';

class SetUpPasswordStore extends _SetUpPasswordStoreBase with _$SetUpPasswordStore {
  SetUpPasswordStore() : super();

  static _SetUpPasswordStoreBase of(BuildContext context) => Provider.of<SetUpPasswordStore>(context, listen: false);
}

abstract class _SetUpPasswordStoreBase with Store {
  @observable
  StackLoaderStore loader = StackLoaderStore();

  TextEditingController passwordController = TextEditingController();

  @observable
  String password = '';
  @action
  void setPassword(String value) {
    setPasswordError(false);
    password = value;
    isJustFailedPreContinueCheck = false;
  }

  @observable
  bool hidePassword = true;
  @action
  void setHidePassword(bool value) {
    hidePassword = value;
  }

  @observable
  bool passwordError = false;
  @action
  bool setPasswordError(bool value) => passwordError = value;

  @observable
  bool canClick = true;
  @action
  void setCanClick(bool value) => canClick = value;

  @observable
  bool savePassword = true;
  @action
  void checkSetter() => savePassword = !savePassword;

  @observable
  bool isJustFailedPreContinueCheck = false;

  @computed
  bool get isPasswordLengthApproved {
    return password.length >= 8;
  }

  @computed
  bool get isSmallSymbolsApproved {
    return RegExp(r'^(?=.*?[a-z]).{0,32}$').hasMatch(password);
  }

  @computed
  bool get isBigSymbolsApproved {
    return RegExp(r'^(?=.*?[A-Z]).{0,32}$').hasMatch(password);
  }

  @computed
  bool get isNumbersApproved {
    return RegExp(r'^(?=.*?[0-9]).{0,32}$').hasMatch(password);
  }

  @computed
  bool get isButtonSaveActive {
    return isNumbersApproved &&
        isSmallSymbolsApproved &&
        isBigSymbolsApproved &&
        isPasswordLengthApproved &&
        !isJustFailedPreContinueCheck;
  }

  @computed
  bool get isRepeatableCharactersApproved {
    return RegExp(r'^(?!.*(.)\1\1)').hasMatch(password);
  }

  @computed
  bool get isWhitespaceApproved {
    return !password.contains(' ');
  }

  @computed
  bool get isAllowedSymbolsApproved {
    return RegExp(r'^[a-zA-Z0-9!#$()*+,\-.;@[\]^_{}]*$').hasMatch(password);
  }

  @action
  bool validPassword(String value) {
    const pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,32}$';
    final regExp = RegExp(pattern);

    return !regExp.hasMatch(value);
  }

  @action
  Future<void> setCardPassword(
    String cardId,
  ) async {
    passwordError = validPassword(password);
    final context = getIt.get<AppRouter>().navigatorKey.currentContext;
    if (!passwordError) {
      try {
        loader.startLoadingImmediately();

        await sNetwork.getWalletModule().postCardSetPassword(
              data: SimpleCardSetPasswordRequest(
                cardId: cardId,
                password: password,
              ),
            );

        Navigator.pop(context!);
        sNotification.showError(
          intl.simple_card_password_working,
          id: 1,
          isError: false,
        );

        loader.finishLoadingImmediately();
      } on ServerRejectException catch (error) {
        sNotification.showError(
          error.cause,
          id: 1,
        );
      } catch (error) {
        sNotification.showError(
          intl.something_went_wrong_try_again,
          id: 1,
        );
      } finally {
        loader.finishLoadingImmediately();
      }
    }
  }

  @action
  bool preContinueCheck() {
    if (!isRepeatableCharactersApproved) {
      sNotification.showError(
        intl.simple_card_password_repeatable_characters,
      );
      isJustFailedPreContinueCheck = true;

      return false;
    }
    if (!isWhitespaceApproved) {
      sNotification.showError(
        intl.simple_card_password_whitespace,
      );
      isJustFailedPreContinueCheck = true;

      return false;
    }

    if (!isAllowedSymbolsApproved) {
      sNotification.showError(
        '${intl.simple_card_password_repeatable_allowed_symbols} ! # \$ ( ) * + - , . ; @ [ ] ^ _ { }',
      );
      isJustFailedPreContinueCheck = true;

      return false;
    }
    isJustFailedPreContinueCheck = false;

    return true;
  }
}
