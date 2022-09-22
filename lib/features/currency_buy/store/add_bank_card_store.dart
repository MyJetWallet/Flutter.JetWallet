// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_bank_card_input.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/card_add/card_add_request_model.dart';
import 'package:uuid/uuid.dart';

part 'add_bank_card_store.g.dart';

class AddBankCardStore extends _AddBankCardStoreBase
    with _$AddBankCardStore {
  AddBankCardStore() : super();

  static _AddBankCardStoreBase of(BuildContext context) =>
      Provider.of<AddBankCardStore>(context, listen: false);
}

abstract class _AddBankCardStoreBase with Store {
  _AddBankCardStoreBase() {
    _initState();
  }

  static final _logger = Logger('AddBankCardStore');

  @observable
  int? month;

  @observable
  int? year;

  @observable
  bool cardNumberError = false;
  @action
  bool setCardNumberError(bool value) => cardNumberError = value;

  @observable
  bool expiryMonthError = false;
  @action
  bool setMonthError(bool value) => expiryMonthError = value;

  @observable
  bool expiryYearError = false;
  @action
  bool setYearError(bool value) => expiryYearError = value;

  @observable
  bool cvvError = false;
  @action
  bool setCvvError(bool value) => cvvError = value;

  @observable
  String expiryMonth = '';

  @observable
  String expiryYear = '';

  @observable
  String cardNumber = '';

  @observable
  String cardholderName = '';

  @observable
  bool saveCard = true;

  @observable
  StackLoaderStore? loader;


  @computed
  bool get isCardNumberValid {
    return CreditCardValidator().validateCCNum(cardNumber).isValid;
  }

  @computed
  bool get isExpiryMonthValid {
    if (int.parse(expiryMonth) > 12) return false;
    if (expiryYear.length < 4) return true;

    return CreditCardValidator()
        .validateExpDate('$expiryMonth/${expiryYear[2]}${expiryYear[3]}')
        .isValid;
  }

  @computed
  bool get isExpiryYearValid {
    return CreditCardValidator()
        .validateExpDate('$expiryMonth/${expiryYear[2]}${expiryYear[3]}')
        .isValid;
  }

  @computed
  bool get isCardholderNameValid {
    return cardholderName.split(' ').length >= 2;
  }

  @computed

  bool get isCardDetailsValid {
    if (expiryYear.length < 4 || expiryMonth.length < 2) return false;

    return isCardNumberValid &&
        isExpiryMonthValid &&
        isExpiryYearValid &&
        isCardholderNameValid;
  }

  @action
  void _initState() {
    final userInfo = sUserInfo.userInfo;
    cardholderName = '${userInfo.firstName} ${userInfo.lastName}';
  }

  @action
  Future<void> addCard({
    required Function() onSuccess,
    required VoidCallback onError,
  }) async {
    _logger.log(notifier, 'addCard');

    loader!.startLoading();

    try {
      final response = await sNetwork.getWalletModule().encryptionKey();

      final cardNumberString = cardNumber.replaceAll('\u{2005}', '');

      final rsa = RsaKeyHelper();
      final key = '-----BEGIN RSA PUBLIC KEY-----\r\n'
          '${response.data?.key}'
          '\r\n-----END RSA PUBLIC KEY-----';
      final key1 = rsa.parsePublicKeyFromPem(key);
      final encrypter = Encrypter(RSA(publicKey: key1));
      final encrypted = encrypter.encrypt('{"cardNumber":"$cardNumberString"}');
      final base64Encoded = encrypted.base64;

      final model = CardAddRequestModel(
        encKeyId: response.data?.keyId ?? '',
        requestGuid: const Uuid().v4(),
        encData: base64Encoded,
        expMonth: int.parse(expiryMonth),
        expYear: int.parse(expiryYear),
      );

      await sNetwork.getWalletModule().cardAdd(model);
      loader!.finishLoading(onFinish: () => onSuccess());
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        duration: 4,
        id: 1,
      );
      loader!.finishLoading(onFinish: onError);
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        duration: 4,
        id: 1,
      );
      loader!.finishLoading(onFinish: onError);
    }
  }

  @action
  void showPreview({
    required String amount,
    required CurrencyModel currency,
    required String encKeyId,
    required String encKey,
    required String cardNumber,
    required BuildContext context,
  }) {
    sRouter.push(
      PreviewBuyWithBankCardRouter(
        input: PreviewBuyWithBankCardInput(
          amount: amount,
          currency: currency,
          encKeyId: encKeyId,
          encData: encKey,
          cardNumber: cardNumber,
          expMonth: int.parse(expiryMonth),
          expYear: int.parse(expiryYear),
          isActive: false,
        ),
      ),
    );
  }

  @action
  void updateCardNumber(String _cardNumber) {
    _logger.log(notifier, 'updateCardNumber');

    cardNumber = _cardNumber;

    // [xxxx xxxx xxxx xxxx]
    cardNumberError = cardNumber.length == 19
        ? isCardNumberValid
        ? false
        : true
        : false;
  }

  @action
  void updateExpiryMonth(String expiryDate) {
    _logger.log(notifier, 'updateExpiryMonth');

    expiryMonth = expiryDate;

    if (expiryDate.length >= 2) {
      if (isExpiryMonthValid) {
        expiryMonthError = false;
        updateExpiryYear(expiryYear);
      } else {
        expiryMonthError = true;
      }
    } else {
      expiryMonthError = false;
    }
  }

  @action
  void updateExpiryYear(String expiryDate) {
    _logger.log(notifier, 'updateExpiryYear');
    print(expiryDate);

    expiryYear = expiryDate;

    if (expiryDate.length >= 4) {
      expiryMonthError = !isExpiryMonthValid;
      expiryYearError = !isExpiryYearValid;
    } else {
      expiryYearError = false;
    }
  }

  @action
  void updateCardholderName(String _cardholderName) {
    _logger.log(notifier, 'updateCardholderName');

    cardholderName = _cardholderName.trim();
  }

  @action
  void checkSetter() {
    saveCard = !saveCard;
  }
}
