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

part 'set_up_password_store.g.dart';

class SetUpPasswordStore extends _SetUpPasswordStoreBase with _$SetUpPasswordStore {
  SetUpPasswordStore() : super();

  static _SetUpPasswordStoreBase of(BuildContext context) =>
      Provider.of<SetUpPasswordStore>(context, listen: false);
}

abstract class _SetUpPasswordStoreBase with Store {

  @observable
  StackLoaderStore loader = StackLoaderStore();

  TextEditingController passwordController = TextEditingController();

  @observable
  String password = '';
  @action
  void setPassword(String value) {
    password = value;
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

  @computed
  bool get isButtonSaveActive {
    return password.isNotEmpty;
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
    if (!passwordError) {
      try {
        loader.startLoadingImmediately();

        await sNetwork.getWalletModule().postCardSetPassword(
          data: SimpleCardSetPasswordRequest(
            cardId: cardId,
            password: password,
          ),
        );

        await sRouter.pop();

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
}
