import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/card_buy/model/add/card_add_request_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';
import 'package:uuid/uuid.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../models/currency_model.dart';
import '../../currency_buy/model/preview_buy_with_bank_card_input.dart';
import '../../currency_buy/view/screens/preview_buy_with_bank_card.dart';
import 'add_unlimint_card_state.dart';

class AddUnlimintCardNotifier extends StateNotifier<AddUnlimintCardState> {
  AddUnlimintCardNotifier(this.read)
      : super(
          AddUnlimintCardState(
            loader: StackLoaderNotifier(),
            cardNumberError: StandardFieldErrorNotifier(),
            expiryMonthError: StandardFieldErrorNotifier(),
            expiryYearError: StandardFieldErrorNotifier(),
            cvvError: StandardFieldErrorNotifier(),
          ),
        ) {
    _initState();
  }

  final Reader read;

  static final _logger = Logger('AddCircleCardNotifier');

  void _initState() {
    final userInfo = read(userInfoNotipod);

    state = state.copyWith(
      cardholderName: '${userInfo.firstName} ${userInfo.lastName}',
    );
  }

  Future<void> addCard({
    required Function() onSuccess,
    required VoidCallback onError,
  }) async {
    _logger.log(notifier, 'addCard');

    final intl = read(intlPod);

    state.loader!.startLoading();

    try {
      final response =
          await read(cardBuyServicePod).encryptionKey(intl.localeName);

      final cardNumber = state.cardNumber.replaceAll('\u{2005}', '');

      final rsa = RsaKeyHelper();
      final key = '-----BEGIN RSA PUBLIC KEY-----\r\n'
          '${response.key}'
          '\r\n-----END RSA PUBLIC KEY-----';
      final key1 = rsa.parsePublicKeyFromPem(key);
      final encrypter = Encrypter(RSA(publicKey: key1));
      final encrypted = encrypter.encrypt('{"cardNumber":"$cardNumber"}');
      final base64Encoded = encrypted.base64;

      final model = CardAddRequestModel(
        encKeyId: response.keyId,
        requestGuid: const Uuid().v4(),
        encData: base64Encoded,
        expMonth: int.parse(state.expiryMonth),
        expYear: int.parse(state.expiryYear),
      );

      await read(cardBuyServicePod).cardAdd(
        model,
        intl.localeName,
      );
      state.loader!.finishLoading(onFinish: () => onSuccess());
    } on ServerRejectException catch (error) {
      read(sNotificationNotipod.notifier).showError(
        error.cause,
        duration: 4,
        id: 1,
      );
      state.loader!.finishLoading(onFinish: onError);
    } catch (error) {
      read(sNotificationNotipod.notifier).showError(
        intl.something_went_wrong_try_again2,
        duration: 4,
        id: 1,
      );
      state.loader!.finishLoading(onFinish: onError);
    }
  }

  void showPreview({
    required String amount,
    required CurrencyModel currency,
    required String encKeyId,
    required String encKey,
    required String cardNumber,
    required BuildContext context,
  }) {
    if (!mounted) return;
    navigatorPush(
      context,
      PreviewBuyWithBankCard(
        input: PreviewBuyWithBankCardInput(
          amount: amount,
          currency: currency,
          encKeyId: encKeyId,
          encData: encKey,
          cardNumber: cardNumber,
          expMonth: int.parse(state.expiryMonth),
          expYear: int.parse(state.expiryYear),
          isActive: false,
        ),
      ),
    );
  }

  void updateCardNumber(String cardNumber) {
    _logger.log(notifier, 'updateCardNumber');

    state = state.copyWith(cardNumber: cardNumber);

    // [xxxx xxxx xxxx xxxx]
    if (cardNumber.length == 19) {
      if (state.isCardNumberValid) {
        state.cardNumberError!.disableError();
      } else {
        state.cardNumberError!.enableError();
      }
    } else {
      state.cardNumberError!.disableError();
    }
  }

  void updateExpiryMonth(String expiryDate) {
    _logger.log(notifier, 'updateExpiryMonth');

    state = state.copyWith(expiryMonth: expiryDate);

    if (expiryDate.length >= 2) {
      if (state.isExpiryMonthValid) {
        state.expiryMonthError!.disableError();
        updateExpiryYear(state.expiryYear);
      } else {
        state.expiryMonthError!.enableError();
      }
    } else {
      state.expiryMonthError!.disableError();
    }
  }

  void updateExpiryYear(String expiryDate) {
    _logger.log(notifier, 'updateExpiryYear');

    state = state.copyWith(expiryYear: expiryDate);

    if (expiryDate.length >= 4) {
      if (state.isExpiryMonthValid) {
        state.expiryMonthError!.disableError();
      } else {
        state.expiryYearError!.enableError();
      }
      if (state.isExpiryYearValid) {
        state.expiryYearError!.disableError();
      } else {
        state.expiryYearError!.enableError();
      }
    } else {
      state.expiryYearError!.disableError();
    }
  }

  void updateCardholderName(String cardholderName) {
    _logger.log(notifier, 'updateCardholderName');

    state = state.copyWith(cardholderName: cardholderName.trim());
  }

  void checkSetter() {
    state = state.copyWith(saveCard: !state.saveCard);
  }
}
