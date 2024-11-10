import 'dart:async';

import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:decimal/decimal.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/wallet_api/models/card_add/card_add_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_add/card_add_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_remove/card_remove_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/delete_card/delete_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/unlimint/delete_unlimint_card_request_model.dart';
import 'package:uuid/uuid.dart';

part 'bank_card_store.g.dart';

enum BankCardStoreMode { add, edit }

class BankCardStore extends _BankCardStoreBase with _$BankCardStore {
  BankCardStore() : super();

  static _BankCardStoreBase of(BuildContext context) => Provider.of<BankCardStore>(context, listen: false);
}

abstract class _BankCardStoreBase with Store {
  @observable
  BankCardStoreMode cardStoreMode = BankCardStoreMode.add;

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
  void setCardLabel(String value) {
    cardLabel = value;

    if (expiryYear.isEmpty) {
      expiryMonthError = true;
    }

    //labelError = validLabel(value);
  }

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
    if ((expiryYear.length != 4 && expiryYear.length != 2) || expiryMonth.length < 2) {
      return false;
    }

    return isCardNumberValid && isExpiryMonthValid && isExpiryYearValid;
  }

  @computed
  bool get isEditButtonSaveActive {
    return cardLabel.trim().isNotEmpty && isExpiryMonthValid && isExpiryYearValid;
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
  bool get isLabelValid {
    return !saveCard || cardLabel.trim().isNotEmpty;
  }

  @action
  void init(BankCardStoreMode mode, {CircleCard? card}) {
    cardStoreMode = mode;

    if (mode == BankCardStoreMode.edit) {
      cardNumberController.text = '**** **** **** ${card!.last4}';
      expiryMonthController.text = '${card.expMonth}/${card.expYear}';
      expiryYearController.text = card.expYear.toString();
      cardLabelController.text = card.cardLabel ?? '';

      expiryMonth = card.expMonth.toString();
      expiryYear = card.expYear.toString();

      expiryMonthError = !isExpiryMonthValid;
      expiryYearError = !isExpiryYearValid;
    }
    if (mode == BankCardStoreMode.add) {
      var tempCardLabel = 'Card 1';
      final cards = sSignalRModules.cards.cardInfos;
      for (var index = 1; index <= cards.length; index++) {
        if (cards.any((element) => element.cardLabel == tempCardLabel)) {
          tempCardLabel = 'Card ${index + 1}';
        } else {
          break;
        }
      }
      cardLabelController = TextEditingController(text: tempCardLabel);
      cardLabel = tempCardLabel;
    }
  }

  @action
  void updateCardNumber(String newCardNumber) {
    cardNumber = newCardNumber;

    // [xxxx xxxx xxxx xxxx]
    cardNumberError = cardNumber.length == 19 && !isCardNumberValid;

    if (cardNumber.length == 19 && isCardNumberValid) {
      cardNode.nextFocus();
      monthNode.requestFocus();
    }
  }

  @action
  void onEraseCardNumber() {
    cardNumberController.text = '';
    cardNumberController.clear();
    cardNumber = '';
    cardNumberError = false;
  }

  @action
  Future<void> pasteCode() async {
    final data = await Clipboard.getData('text/plain');
    var code = data?.text?.trim() ?? '';
    code = code.replaceAll(' ', '');
    code = code.replaceAll(' ', '');

    try {
      int.parse(code);
      if (code.length == 16) {
        final buffer = StringBuffer();

        for (var i = 0; i < code.length; i++) {
          buffer.write(code[i]);
          final nonZeroIndex = i + 1;
          if (nonZeroIndex % 4 == 0 && nonZeroIndex != code.length && nonZeroIndex != (code.length - 1)) {
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

  @observable
  bool isTypingInExp = false;

  @action
  void updateExpiryMonth(String expiryDate) {
    isTypingInExp = true;

    if (expiryDate.length < 2) {
      if ((int.tryParse(expiryDate) ?? 0) > 2) {
        expiryMonth = '0$expiryDate';
        expiryMonthController.text = '0$expiryDate';
      }
      expiryMonthError = false;

      expiryMonthController.selection = TextSelection.collapsed(offset: expiryMonthController.text.length);
    }

    if (expiryDate.length >= 5) {
      final sp = expiryDate.split('/');

      expiryMonth = sp.first;
      expiryYear = sp[1];

      labelNode.requestFocus();

      if ((expiryYear.length == 4 || expiryYear.length == 2) && expiryYear != '20') {
        expiryMonthError = !isExpiryMonthValid;
        expiryYearError = !isExpiryYearValid;
      } else {
        expiryMonthError = false;
        expiryYearError = false;
      }
    } else {
      expiryMonth = '';
      expiryYear = '';

      expiryMonthError = false;
      expiryYearError = false;
    }
  }

  @action
  void validExpiry() {
    if (!isTypingInExp) return;

    if (expiryMonth.isEmpty || expiryYear.isEmpty) {
      expiryMonthError = true;
      expiryYearError = true;
    } else {
      if (expiryMonth.length != 2 || expiryYear.length != 2) {
        expiryMonthError = true;
        expiryYearError = true;
      }
    }
  }

  @action
  Future<void> addCard({
    required Function() onSuccess,
    required VoidCallback onError,
    required bool isPreview,
    PaymentAsset? currency,
    required String amount,
    required CurrencyModel asset,
  }) async {
    loader.startLoadingImmediately();

    try {
      final response = await sNetwork.getWalletModule().encryptionKey();

      final cardNumberString = cardNumber.replaceAll('\u{2005}', '').replaceAll(' ', '');

      final rsa = RsaKeyHelper();
      final key = '-----BEGIN RSA PUBLIC KEY-----\r\n'
          '${response.data?.data.key}'
          '\r\n-----END RSA PUBLIC KEY-----';
      final key1 = rsa.parsePublicKeyFromPem(key);
      final encrypter = Encrypter(RSA(publicKey: key1));
      final encrypted = encrypter.encrypt('{"cardNumber":"$cardNumberString"}');
      final base64Encoded = encrypted.base64;

      if (!saveCard) {
        cardLabel = '';
      }

      final model = CardAddRequestModel(
        encKeyId: response.data?.data.keyId ?? '',
        requestGuid: const Uuid().v4(),
        encData: base64Encoded,
        expMonth: int.parse(expiryMonth),
        expYear: int.parse(
          expiryYear.length == 4 ? expiryYear : '20$expiryYear',
        ),
        isActive: !isPreview || saveCard,
        cardLabel: cardLabel.isEmpty ? null : cardLabel,
        cardAssetSymbol: currency?.asset,
      );

      final newCard = await sNetwork.getWalletModule().cardAdd(model);

      newCard.pick(
        onData: (data) async {
          if (isPreview) {
            final cardNumberFinal = cardNumber.replaceAll('\u{2005}', '');
            if (newCard.data?.data.status == CardStatus.verificationRequired) {
              if (newCard.data?.data.requiredVerification == CardVerificationType.cardCheck) {
                await sRouter.push(
                  UploadVerificationPhotoRouter(
                    cardId: newCard.data?.data.cardId ?? '',
                    onSuccess: () {
                      showPreview(
                        cardNumber: cardNumberFinal,
                        amount: amount,
                        cardId: newCard.data?.data.cardId ?? '',
                        showUaAlert: newCard.data?.data.showUaAlert ?? false,
                        asset: asset,
                        expMonth: int.parse(expiryMonth),
                        expYear: int.parse(
                          expiryYear.length == 4 ? expiryYear : '20$expiryYear',
                        ),
                        cardLabel: cardLabel.isEmpty ? '' : cardLabel,
                        network: data.data.network,
                      );
                    },
                  ),
                );
              } else if (newCard.data?.data.requiredVerification == CardVerificationType.cardWithSelfieCheck) {
                await sRouter.push(
                  UploadVerificationPhotoRouter(
                    isSelfie: true,
                    cardId: newCard.data?.data.cardId ?? '',
                    onSuccess: () {
                      showPreview(
                        cardNumber: cardNumberFinal,
                        amount: amount,
                        cardId: newCard.data?.data.cardId ?? '',
                        showUaAlert: newCard.data?.data.showUaAlert ?? false,
                        asset: asset,
                        expMonth: int.parse(expiryMonth),
                        expYear: int.parse(
                          expiryYear.length == 4 ? expiryYear : '20$expiryYear',
                        ),
                        cardLabel: cardLabel.isEmpty ? '' : cardLabel,
                        network: data.data.network,
                      );
                    },
                  ),
                );
              }
            } else if (newCard.data?.data.status == CardStatus.accepted) {
              await showPreview(
                cardNumber: cardNumberFinal,
                amount: amount,
                cardId: newCard.data?.data.cardId ?? '',
                showUaAlert: newCard.data?.data.showUaAlert ?? false,
                asset: asset,
                expMonth: int.parse(expiryMonth),
                expYear: int.parse(
                  expiryYear.length == 4 ? expiryYear : '20$expiryYear',
                ),
                cardLabel: cardLabel.isEmpty ? '' : cardLabel,
                network: data.data.network,
              );
            } else {
              _showFailureScreen();
            }
          }

          loader.finishLoadingImmediately();
          onSuccess();
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
          );
          loader.finishLoading(onFinish: onError);
        },
      );
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 1,
      );
      loader.finishLoading(onFinish: onError);
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
      );
      loader.finishLoading(onFinish: onError);
    }
  }

  @action
  Future<void> showPreview({
    required String amount,
    required String cardNumber,
    required String cardId,
    required CurrencyModel asset,
    bool showUaAlert = false,
    required int expMonth,
    required int expYear,
    required String cardLabel,
    required CircleCardNetwork network,
  }) async {
    await sRouter.maybePop();
    if (saveCard) await sRouter.maybePop();

    Timer(const Duration(milliseconds: 300), () {
      final cardIndex = sSignalRModules.cards.cardInfos.indexWhere(
        (element) => element.id == cardId,
      );

      final finalCardNumber = cardNumber.substring(cardNumber.length - 4);
      CircleCard? card;

      card = cardIndex != -1
          ? sSignalRModules.cards.cardInfos.firstWhere((element) => element.id == cardId)
          : CircleCard(
              id: cardId,
              last4: finalCardNumber,
              network: network,
              expMonth: expMonth,
              expYear: expYear,
              status: CircleCardStatus.complete,
              showUaAlert: showUaAlert,
              lastUsed: false,
              cardLabel: cardLabel,
              paymentDetails: CircleCardInfoPayment(
                minAmount: Decimal.zero,
                maxAmount: Decimal.zero,
                feePercentage: Decimal.zero,
              ),
            );

      getIt.get<SimpleLoggerService>().log(
            level: Level.info,
            place: 'Bank Card Store',
            message: card.toString(),
          );

      sRouter.push(
        AmountRoute(
          tab: AmountScreenTab.buy,
          asset: asset,
          card: card,
        ),
      );
    });
  }

  @action
  Future<void> updateCardLabel(
    String cardId,
  ) async {
    try {
      loader.startLoadingImmediately();

      await sNetwork.getWalletModule().updateCardLabel(
            cardId,
            cardLabel,
          );

      await sRouter.maybePop();

      loader.finishLoadingImmediately();
      sNotification.showError(
        intl.card_update_notification,
        id: 1,
        isError: false,
      );
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

  @action
  Future<void> deleteCard(CircleCard card) async {
    try {
      loader.startLoadingImmediately();

      if (card.integration == IntegrationType.circle || card.integration == null) {
        final model = DeleteCardRequestModel(cardId: card.id);
        final _ = await sNetwork.getWalletModule().postDeleteCard(model);
      } else if (card.integration == IntegrationType.unlimint) {
        final model = DeleteUnlimintCardRequestModel(cardId: card.id);
        final _ = await sNetwork.getWalletModule().postDeleteUnlimintCard(model);
      } else if (card.integration == IntegrationType.unlimintAlt) {
        final model = CardRemoveRequestModel(cardId: card.id);
        final _ = await sNetwork.getWalletModule().cardRemove(model);
      }

      loader.finishLoadingImmediately();

      sNotification.showError(
        intl.card_delete_notification,
        id: 1,
        isError: false,
      );
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

  @action
  void _showFailureScreen() {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.cardVerification_cardBlocked,
        secondaryText: intl.cardVerification_cardBlockedDescription,
      ),
    );
  }
}
