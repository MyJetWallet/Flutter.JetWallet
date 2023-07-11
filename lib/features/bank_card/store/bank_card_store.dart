import 'dart:async';

import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/wallet_api/models/card_add/card_add_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_add/card_add_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_remove/card_remove_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/delete_card/delete_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/unlimint/delete_unlimint_card_request_model.dart';
import 'package:uuid/uuid.dart';

part 'bank_card_store.g.dart';

enum BankCardStoreMode { ADD, EDIT }

class BankCardStore extends _BankCardStoreBase with _$BankCardStore {
  BankCardStore() : super();

  static _BankCardStoreBase of(BuildContext context) =>
      Provider.of<BankCardStore>(context, listen: false);
}

abstract class _BankCardStoreBase with Store {
  @observable
  BankCardStoreMode cardStoreMode = BankCardStoreMode.ADD;

  @observable
  StackLoaderStore loader = StackLoaderStore();

  TextEditingController expiryMonthController = TextEditingController();
  TextEditingController expiryYearController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardholderNameController = TextEditingController();
  TextEditingController cardLabelController = TextEditingController();

  FocusNode cardNode = FocusNode();
  FocusNode monthNode = FocusNode();
  FocusNode yearNode = FocusNode();
  FocusNode labelNode = FocusNode();

  @observable
  String cardNumber = '';
  @observable
  bool cardNumberError = false;
  @action
  bool setCardNumberError(bool value) => cardNumberError = value;

  @observable
  String expiryMonth = '';
  @observable
  bool expiryMonthError = false;
  @action
  bool setMonthError(bool value) => expiryMonthError = value;

  @observable
  String expiryYear = '';
  @observable
  bool expiryYearError = false;
  @action
  bool setYearError(bool value) => expiryYearError = value;

  @observable
  String cardLabel = '';
  @action
  void setCardLabel(String value) => cardLabel = value;
  @observable
  bool labelError = false;
  @action
  bool setLabelError(bool value) => labelError = value;

  @observable
  bool cvvError = false;
  @action
  bool setCvvError(bool value) => cvvError = value;

  @observable
  bool canClick = true;
  @action
  void setCanClick(bool value) => canClick = value;

  @observable
  bool saveCard = true;
  @action
  void checkSetter() => saveCard = !saveCard;

  @computed
  bool get isCardNumberValid {
    return CreditCardValidator().validateCCNum(cardNumber).isValid;
  }

  @computed
  bool get isCardDetailsValid {
    if ((expiryYear.length != 4 && expiryYear.length != 2) ||
        expiryMonth.length < 2) {
      return false;
    }

    return isCardNumberValid && isExpiryMonthValid && isExpiryYearValid;
  }

  @computed
  bool get isEditButtonSaveActive {
    return cardLabel.isNotEmpty;
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

  @action
  void init(BankCardStoreMode mode, {CircleCard? card}) {
    cardStoreMode = mode;

    if (mode == BankCardStoreMode.EDIT) {
      print(card);

      cardNumberController.text = '123123123';
      expiryMonthController.text = '${card!.expMonth}/${card.expYear}';
      expiryYearController.text = card.expYear.toString();
      cardLabelController.text = card.cardLabel ?? '';
      //cardLabel = card.cardLabel ?? '';
    }
  }

  @action
  void updateCardNumber(String _cardNumber) {
    cardNumber = _cardNumber;

    // [xxxx xxxx xxxx xxxx]
    cardNumberError = cardNumber.length == 19 ? !isCardNumberValid : false;

    if (cardNumber.length == 19 && isCardNumberValid) {
      cardNode.nextFocus();
      monthNode.requestFocus();
    }
  }

  @action
  Future<void> pasteCode() async {
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
  void updateExpiryMonth(String expiryDate) {
    if (expiryDate.length >= 4) {
      var sp = expiryDate.split('/');

      expiryMonth = sp.first;
      expiryYear = sp[1];

      if ((expiryYear.length == 4 || expiryYear.length == 2) &&
          expiryYear != '20') {
        expiryMonthError = !isExpiryMonthValid;
        expiryYearError = !isExpiryYearValid;
      } else {
        expiryYearError = false;
      }
    }
  }

  @action
  Future<void> addCard({
    required Function() onSuccess,
    required VoidCallback onError,
    required bool isPreview,
    CurrencyModel? currency,
    required String amount,
  }) async {
    loader.startLoadingImmediately();

    try {
      final response = await sNetwork.getWalletModule().encryptionKey();

      final cardNumberString =
          cardNumber.replaceAll('\u{2005}', '').replaceAll(' ', '');

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
        cardLabel: cardLabel.isEmpty ? null : cardLabel,
      );

      final newCard = await sNetwork.getWalletModule().cardAdd(model);

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
                        showUaAlert: newCard.data?.data.showUaAlert ?? false,
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
                        showUaAlert: newCard.data?.data.showUaAlert ?? false,
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
                showUaAlert: newCard.data?.data.showUaAlert ?? false,
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
    bool showUaAlert = false,
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
          showUaAlert: showUaAlert,
        ),
      );
    });
  }

  @action
  Future<void> updateCardLabel(
    String cardId,
  ) async {
    final updateLabelResponse =
        await sNetwork.getWalletModule().updateCardLabel(
              cardId,
              cardLabel,
            );
  }

  @action
  Future<void> deleteCard(CircleCard card) async {
    try {
      if (card.integration == IntegrationType.circle ||
          card.integration == null) {
        final model = DeleteCardRequestModel(cardId: card.id);
        final _ = sNetwork.getWalletModule().postDeleteCard(model);
      } else if (card.integration == IntegrationType.unlimint) {
        final model = DeleteUnlimintCardRequestModel(cardId: card.id);
        final _ = sNetwork.getWalletModule().postDeleteUnlimintCard(model);
      } else if (card.integration == IntegrationType.unlimintAlt) {
        final model = CardRemoveRequestModel(cardId: card.id);
        final _ = sNetwork.getWalletModule().cardRemove(model);
      }
    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
      );
    }
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
