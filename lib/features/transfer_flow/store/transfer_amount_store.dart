import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

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
  }

  @action
  void setNewFromAsset({
    CardDataModel? newFromCard,
    SimpleBankingAccount? newFromAccount,
  }) {
    fromCard = newFromCard;
    fromAccount = newFromAccount;
    inputValue = '0';

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
        '${intl.currencyBuy_paymentInputErrorText1} ${volumeFormat(
          decimal: minLimit,
          accuracy: 2,
          symbol: 'EUR',
        )}',
      );
    } else if (value > maxLimit) {
      _updatePaymentMethodInputError(
        '${intl.currencyBuy_paymentInputErrorText2} ${volumeFormat(
          decimal: maxLimit,
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
