// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'dart:async';

import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/wallet_api/models/card_add/card_add_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_add/card_add_response_model.dart';
import 'package:uuid/uuid.dart';

part 'add_bank_card_store.g.dart';

class AddBankCardStore extends _AddBankCardStoreBase with _$AddBankCardStore {
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

  TextEditingController expiryMonthController = TextEditingController();

  TextEditingController expiryYearController = TextEditingController();

  TextEditingController cardNumberController = TextEditingController();

  TextEditingController cardholderNameController = TextEditingController();

  @observable
  String expiryYear = '';

  @observable
  String cardNumber = '';

  @observable
  String cardholderName = '';

  @observable
  bool saveCard = true;

  @observable
  FocusNode cardNode = FocusNode();

  @observable
  FocusNode monthNode = FocusNode();

  @observable
  FocusNode yearNode = FocusNode();

  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  bool canClick = true;

  @computed
  bool get isCardNumberValid {
    return CreditCardValidator().validateCCNum(cardNumber).isValid;
  }

  @computed
  bool get isExpiryMonthValid {
    if (int.parse(expiryMonth) > 12) return false;
    if (expiryYear.length != 4 && expiryYear.length != 2) return true;

    return CreditCardValidator()
        .validateExpDate('$expiryMonth/'
            '${expiryYear[expiryYear.length == 2 ? 0 : 2]}'
            '${expiryYear[expiryYear.length == 2 ? 1 : 3]}')
        .isValid;
  }

  @computed
  bool get isExpiryYearValid {
    return CreditCardValidator()
        .validateExpDate('$expiryMonth/'
            '${expiryYear[expiryYear.length == 2 ? 0 : 2]}'
            '${expiryYear[expiryYear.length == 2 ? 1 : 3]}')
        .isValid;
  }

  @computed
  bool get isCardholderNameValid {
    return cardholderName.split(' ').length >= 2;
  }

  @computed
  bool get isCardDetailsValid {
    if ((expiryYear.length != 4 && expiryYear.length != 2) ||
        expiryMonth.length < 2) {
      return false;
    }

    return isCardNumberValid &&
        isExpiryMonthValid &&
        isExpiryYearValid &&
        isCardholderNameValid;
  }

  @action
  void _initState() {
    final userInfo = sUserInfo.userInfo;
    final userName = '${userInfo.firstName} ${userInfo.lastName}';
    cardholderName = userName;
    cardholderNameController.text = userName;
  }

  @action
  Future<void> addCard({
    required Function() onSuccess,
    required VoidCallback onError,
    required bool isPreview,
    CurrencyModel? currency,
    required String amount,
  }) async {
    _logger.log(notifier, 'addCard');

    loader.startLoadingImmediately();

    try {
      final response = await sNetwork.getWalletModule().encryptionKey();

      final cardNumberString = cardNumber
          .replaceAll('\u{2005}', '')
          .replaceAll(' ', '');

      final rsa = RsaKeyHelper();
      final key = '-----BEGIN RSA PUBLIC KEY-----\r\n'
          '${response.data?.data.key}'
          '\r\n-----END RSA PUBLIC KEY-----';
      final key1 = rsa.parsePublicKeyFromPem(key);
      final encrypter = Encrypter(RSA(publicKey: key1));
      final encrypted = encrypter.encrypt('{"cardNumber":"$cardNumberString"}');
      final base64Encoded = encrypted.base64;

      final model = CardAddRequestModel(
        encKeyId: response.data?.data.keyId ?? '',
        requestGuid: const Uuid().v4(),
        encData: base64Encoded,
        expMonth: int.parse(expiryMonth),
        expYear: int.parse(
          expiryYear.length == 4 ? expiryYear : '20$expiryYear',
        ),
        isActive: isPreview ? saveCard : true,
      );

      final newCard = await sNetwork.getWalletModule().cardAdd(model);
      print(newCard);

      newCard.pick(
        onData: (data) async {
          if (isPreview) {
            final cardNumberFinal = cardNumber.replaceAll('\u{2005}', '');
            if (newCard.data?.data.status == CardStatus.verificationRequired) {
              if (newCard.data?.data.requiredVerification ==
                  CardVerificationType.cardCheck) {
                await sRouter.push(
                  UploadVerificationPhotoRouter(
                    cardId: newCard.data?.data.cardId ?? '',
                    onSuccess: () {
                      showPreview(
                        cardNumber: cardNumberFinal,
                        currency: currency!,
                        amount: amount,
                        cardId: newCard.data?.data.cardId ?? '',
                      );
                    },
                  ),
                );
              } else if (newCard.data?.data.requiredVerification ==
                  CardVerificationType.cardWithSelfieCheck) {
                await sRouter.push(
                  UploadVerificationPhotoRouter(
                    isSelfie: true,
                    cardId: newCard.data?.data.cardId ?? '',
                    onSuccess: () {
                      showPreview(
                        cardNumber: cardNumberFinal,
                        currency: currency!,
                        amount: amount,
                        cardId: newCard.data?.data.cardId ?? '',
                      );
                    },
                  ),
                );
              }
            } else if (newCard.data?.data.status == CardStatus.accepted) {
              showPreview(
                cardNumber: cardNumberFinal,
                currency: currency!,
                amount: amount,
                cardId: newCard.data?.data.cardId ?? '',
              );
            } else {
              _showFailureScreen();
            }
          }
          loader.finishLoading(onFinish: () => onSuccess());
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            duration: 4,
            id: 1,
          );
          loader.finishLoading(onFinish: onError);
        },
      );

    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        duration: 4,
        id: 1,
      );
      loader.finishLoading(onFinish: onError);
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        duration: 4,
        id: 1,
      );
      loader.finishLoading(onFinish: onError);
    }
  }

  @action
  void showPreview({
    required String amount,
    required CurrencyModel currency,
    required String cardNumber,
    required String cardId,
  }) {
    final finalCardNumber = cardNumber.substring(cardNumber.length - 4);
    sRouter.pop();
    Timer(const Duration(milliseconds: 500), () {
      sAnalytics.newBuyBuyAssetView(asset: currency.symbol);
      sRouter.push(
        CurrencyBuyRouter(
          newBankCardId: cardId,
          currency: currency,
          fromCard: true,
          paymentMethod: PaymentMethodType.bankCard,
          newBankCardNumber: finalCardNumber,
        ),
      );
    });
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

    if (cardNumber.length == 19 && isCardNumberValid) {
      cardNode.nextFocus();
      monthNode.requestFocus();
    }
  }

  @action
  void updateExpiryMonth(String expiryDate) {
    _logger.log(notifier, 'updateExpiryMonth');

    expiryMonth = expiryDate;

    if (expiryDate.length >= 2) {
      if (isExpiryMonthValid) {
        expiryMonthError = false;
        monthNode.nextFocus();
        updateExpiryYear(expiryYear);
      } else {
        expiryMonthError = true;
      }
    } else {
      if (int.parse(expiryMonth) > 2) {
        expiryMonth = '0$expiryDate';
        expiryMonthController.text = '0$expiryDate';
        monthNode.nextFocus();
        updateExpiryYear(expiryYear);
      }
      expiryMonthError = false;
    }
  }

  @action
  void yearFieldTap() {
    if (expiryMonth == '2') {
      expiryMonth = '02';
      expiryMonthController.text = '02';
    } else if (expiryMonth == '1') {
      expiryMonth = '01';
      expiryMonthController.text = '01';
    }
  }

  @action
  void updateExpiryYear(String expiryDate) {
    _logger.log(notifier, 'updateExpiryYear');

    expiryYear = expiryDate;

    if ((expiryDate.length == 4 || expiryDate.length == 2) &&
        expiryDate != '20') {
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
  Future<void> pasteCode() async {
    _logger.log(notifier, 'pasteCode');

    final data = await Clipboard.getData('text/plain');
    var code = data?.text?.trim() ?? '';
    code = code.replaceAll(' ', '');
    try {
      int.parse(code);
      if (code.length == 16) {
        final buffer = StringBuffer();

        for (var i = 0; i < code.length; i++) {
          buffer.write(code[i]);
          final nonZeroIndex = i + 1;
          if (nonZeroIndex % 4 == 0 &&
              nonZeroIndex != code.length &&
              nonZeroIndex != (code.length - 1)) {
            buffer.write(' ');
          }
        }
        updateCardNumber(buffer.toString());
        cardNumberController.text = buffer.toString();
      } else {
        updateCardNumber(code);
        cardNumberController.text = code;
      }
    } catch (e) {
      return;
    }
  }

  @action
  void checkSetter() {
    saveCard = !saveCard;
  }

  @action
  void toggleClick(bool value) {
    canClick = value;
  }

  @action
  void _showFailureScreen() {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.cardVerification_cardBlocked,
        secondaryText: intl.cardVerification_cardBlockedDescription,
        primaryButtonName: intl.cardVerification_close,
        onPrimaryButtonTap: () => sRouter.popUntilRoot(),
      ),
    );
  }
}
