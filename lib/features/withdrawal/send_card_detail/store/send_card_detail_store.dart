import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'send_card_detail_store.g.dart';

class SendCardDetailStore extends _SendCardDetailStoreBase
    with _$SendCardDetailStore {
  SendCardDetailStore() : super();

  static SendCardDetailStore of(BuildContext context) =>
      Provider.of<SendCardDetailStore>(context, listen: false);
}

abstract class _SendCardDetailStoreBase with Store {
  @observable
  String cardNumber = '';

  @observable
  bool cardNumberError = false;
  @action
  bool setCardNumberError(bool value) => cardNumberError = value;

  @computed
  bool get isCardNumberValid {
    return CreditCardValidator().validateCCNum(cardNumber).isValid;
  }

  @action
  void updateCardNumber(String _cardNumber) {
    cardNumber = _cardNumber;

    // [xxxx xxxx xxxx xxxx]
    cardNumberError = cardNumber.length == 19
        ? isCardNumberValid
            ? false
            : true
        : false;
  }

  @action
  Future<void> pasteCardNumber(TextEditingController controller) async {
    final copiedText = await _copiedText();
    updateCardNumber(copiedText);
    controller.text = copiedText;

    _moveCursorAtTheEnd(controller);
  }

  Future<String> _copiedText() async {
    final data = await Clipboard.getData('text/plain');

    return (data?.text ?? '').replaceAll(' ', '');
  }

  @action
  void _moveCursorAtTheEnd(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }
}
