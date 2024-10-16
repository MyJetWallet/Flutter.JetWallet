import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer/account_transfer_preview_request_model.dart';

part 'transfer_amount_store.g.dart';

class TransfetAmountStore extends _TransfetAmountStoreBase with _$TransfetAmountStore {
  TransfetAmountStore() : super();

  static TransfetAmountStore of(BuildContext context) => Provider.of<TransfetAmountStore>(context, listen: false);
}

abstract class _TransfetAmountStoreBase with Store {
  @computed
  bool get isContinueAvaible {
    return inputValid && Decimal.parse(inputValue) != Decimal.zero && isBothAssetsSeted;
  }

  @observable
  bool inputValid = false;

  @observable
  String? errorText;

  @observable
  String inputValue = '0';

  @observable
  CardDataModel? fromCard;

  @observable
  CardDataModel? toCard;

  @observable
  SimpleBankingAccount? fromAccount;

  @observable
  SimpleBankingAccount? toAccount;

  @computed
  CredentialsType? get fromType {
    if (fromCard != null) {
      return CredentialsType.unlimitCard;
    } else if (fromAccount != null && (fromAccount?.isClearjuctionAccount ?? false)) {
      return CredentialsType.clearjunctionAccount;
    } else if (fromAccount != null) {
      return CredentialsType.unlimitAccount;
    } else {
      return null;
    }
  }

  @computed
  CredentialsType? get toType {
    if (toCard != null) {
      return CredentialsType.unlimitCard;
    } else if (toAccount != null && (toAccount?.isClearjuctionAccount ?? false)) {
      return CredentialsType.clearjunctionAccount;
    } else if (toAccount != null) {
      return CredentialsType.unlimitAccount;
    } else {
      return null;
    }
  }

  @computed
  bool get isNoAccounts => !(sSignalRModules.bankingProfileData?.isAvaibleAnyAccount ?? false);

  @action
  void init({
    CardDataModel? newFromCard,
    CardDataModel? newToCard,
    SimpleBankingAccount? newFromAccount,
    SimpleBankingAccount? newToAccount,
  }) {
    fromCard = newFromCard;
    toCard = newToCard;
    fromAccount = newFromAccount;
    toAccount = newToAccount;

    _checkShowTosts();
  }

  @action
  void _checkShowTosts() {
    var isNoBalance = false;

    if (fromCard != null && !(fromCard?.isNotEmptyBalance ?? false)) {
      isNoBalance = true;
    }
    if (fromAccount != null && !(fromAccount?.isNotEmptyBalance ?? false)) {
      isNoBalance = true;
    }

    Timer(
      const Duration(milliseconds: 200),
      () {
        if (isNoBalance) {
          sNotification.showError(
            intl.error_message_insufficient_funds,
            id: 1,
            isError: false,
          );
        }
      },
    );
  }

  @action
  void setNewFromAsset({
    CardDataModel? newFromCard,
    SimpleBankingAccount? newFromAccount,
  }) {
    fromCard = newFromCard;
    fromAccount = newFromAccount;
    inputValue = '0';

    _checkShowTosts();

    _validateInput();
  }

  @action
  void setNewToAsset({
    CardDataModel? newToCard,
    SimpleBankingAccount? newToAccount,
  }) {
    toCard = newToCard;
    toAccount = newToAccount;
    inputValue = '0';

    _validateInput();
  }

  @action
  void pasteValue(String value) {
    inputValue = value;

    _validateInput();
  }

  @action
  void updateInputValue(String value) {
    inputValue = responseOnInputAction(
      oldInput: inputValue,
      newInput: value,
      accuracy: 2,
      wholePartLenght: maxWholePrartLenght,
    );

    _validateInput();
  }

  @action
  void onTransfetAll() {
    inputValue = '0';
    inputValue = responseOnInputAction(
      oldInput: inputValue,
      newInput: maxLimit.toString(),
      accuracy: 2,
    );

    _validateInput();
  }

  @computed
  int get maxWholePrartLenght =>
      (isBothAssetsSeted && maxLimit != Decimal.zero) ? (maxLimit.round().toString().length + 1) : 15;

  @computed
  bool get isBothAssetsSeted => (fromAccount != null || fromCard != null) && (toAccount != null || toCard != null);

  @computed
  Decimal get maxLimit {
    return fromAccount?.balance ?? fromCard?.balance ?? Decimal.zero;
  }

  @computed
  Decimal get minLimit {
    return Decimal.zero;
  }

  @action
  void _validateInput() {
    if (Decimal.parse(inputValue) == Decimal.zero) {
      inputValid = true;

      return;
    }

    if (!isInputValid(inputValue)) {
      inputValid = false;

      return;
    }

    final value = Decimal.parse(inputValue);

    inputValid = value >= minLimit && value <= maxLimit;

    if (maxLimit == Decimal.zero) {
      _updatePaymentMethodInputError(
        null,
      );
    } else if (value < minLimit) {
      _updatePaymentMethodInputError(
        '${intl.currencyBuy_paymentInputErrorText1} ${minLimit.toFormatCount(
          accuracy: 2,
          symbol: 'EUR',
        )}',
      );
    } else if (value > maxLimit) {
      _updatePaymentMethodInputError(
        '${intl.currencyBuy_paymentInputErrorText2} ${maxLimit.toFormatCount(
          accuracy: 2,
          symbol: 'EUR',
        )}',
      );
    } else {
      _updatePaymentMethodInputError(null);
    }
  }

  @action
  void _updatePaymentMethodInputError(String? error) {
    if (error != null) {
      // place for Analytics
    }
    errorText = error;
  }
}
