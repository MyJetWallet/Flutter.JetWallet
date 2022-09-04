import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/card_buy/model/create/card_buy_create_request_model.dart';
import 'package:simple_networking/services/card_buy/model/execute/card_buy_execute_request_model.dart';
import 'package:simple_networking/services/card_buy/model/info/card_buy_info_request_model.dart';
import 'package:simple_networking/services/card_buy/model/info/card_buy_info_response_model.dart';
import 'package:simple_networking/services/key_value/model/key_value_request_model.dart';
import 'package:simple_networking/services/key_value/model/key_value_response_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';

import '../../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../shared/constants.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../../shared/services/local_storage_service.dart';
import '../../../../../screens/navigation/provider/navigation_stpod.dart';
import '../../../key_value/notifier/key_value_notipod.dart';
import '../../model/preview_buy_with_bank_card_input.dart';
import '../../view/components/show_bank_card_cvv_bottom_sheet.dart';
import '../../view/screens/preview_buy_with_circle/circle_3d_secure_web_view/circle_3d_secure_web_view.dart';
import 'preview_buy_with_bank_card_state.dart';

class PreviewBuyWithBankCardNotifier
    extends StateNotifier<PreviewBuyWithBankCardState> {
  PreviewBuyWithBankCardNotifier(
    this.input,
    this.read,
  ) : super(PreviewBuyWithBankCardState(loader: StackLoaderNotifier())) {
    _context = read(sNavigatorKeyPod).currentContext!;
    _intl = read(intlPod);
    _initState();
    _requestPreview();
  }

  final Reader read;
  final PreviewBuyWithBankCardInput input;

  late BuildContext _context;
  late AppLocalizations _intl;

  static final _logger = Logger('PreviewBuyWithBankCardNotifier');

  void _initState() {
    state = state.copyWith(
      amountToGet: Decimal.parse(input.amount),
      amountToPay: Decimal.parse(input.amount),
    );
  }

  Future<void> _requestPreview() async {
    state.loader.startLoadingImmediately();

    final model = CardBuyCreateRequestModel(
      paymentMethod: CirclePaymentMethod.bankCard,
      paymentAmount: state.amountToPay!,
      buyAsset: input.currency.symbol,
      paymentAsset: 'USD',
    );

    try {
      final response = await read(cardBuyServicePod).cardBuyCreatePayment(
        model,
        _intl.localeName,
      );

      state = state.copyWith(
        paymentAmount: response.paymentAmount,
        paymentAsset: response.paymentAsset,
        buyAmount: response.buyAmount,
        buyAsset: response.buyAsset,
        depositFeeAmount: response.depositFeeAmount,
        depositFeeAsset: response.depositFeeAsset,
        tradeFeeAmount: response.tradeFeeAmount,
        tradeFeeAsset: response.tradeFeeAsset,
        rate: response.rate,
        paymentId: response.paymentId ?? '',
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'requestPreview', error.cause);

      _showFailureScreen(error.cause);
    } catch (error) {
      _logger.log(stateFlow, 'requestPreview', error);

      _showFailureScreen(_intl.something_went_wrong);
    } finally {
      state.loader.finishLoading();
      Timer(const Duration(milliseconds: 500), () {
        _isChecked();
      });
    }
  }

  void onConfirm() {
    _logger.log(notifier, 'onConfirm');
    final storage = read(localStorageServicePod);
    storage.setString(checkedBankCard, 'true');
    showBankCardCvvBottomSheet(
      context: _context,
      header: '${_intl.previewBuyWithCircle_enter} CVV '
          '${_intl.previewBuyWithCircle_for} '
          ' •••• ${input.cardNumber != null
          ? input.cardNumber?.substring(input.cardNumber?.length ?? 4 - 4)
          : ''}',
      onCompleted: (cvv) {
        Navigator.pop(_context);
        state = state.copyWith(cvv: cvv);
        _createPayment();
      },
      input: input,
    );
  }

  Future<void> _createPayment() async {
    _logger.log(notifier, '_createPayment');

    state.loader.startLoadingImmediately();

    await _requestPayment(() async {
      await _requestPaymentInfo((url, onSuccess, onCancel, paymentId) {
        if (!mounted) return;
        navigatorPush(
          _context,
          Circle3dSecureWebView(
            url,
            input.amount,
            state.currencySymbol,
            onSuccess,
            onCancel,
            paymentId,
          ),
        );
        state.loader.finishLoadingImmediately();
      }, '',);
    });
    await setLastUsedPaymentMethod();
  }

  Future<void> setLastUsedPaymentMethod() async {
    _logger.log(notifier, 'setLastUsedPaymentMethod');

    try {
      await read(keyValueNotipod.notifier).addToKeyValue(
        KeyValueRequestModel(
          keys: [
            KeyValueResponseModel(
              key: lastUsedPaymentMethodKey,
              value: jsonEncode('bankCard'),
            )
          ],
        ),
      );
    } catch (e) {
      _logger.log(stateFlow, 'setLastUsedPaymentMethod', e);
    }
  }

  Future<void> _requestPayment(void Function() onSuccess) async {
    _logger.log(notifier, '_requestPayment');

    final bankCardService = read(cardBuyServicePod);

    try {
      var base64Encoded = '';
      if (input.encData != null) {
        final rsa = RsaKeyHelper();
        final key1 = rsa.parsePublicKeyFromPem(input.encData);
        final encrypted = base64Encoded = encrypt(
          '{"cardNumber":"${input.cardNumber}","cvv":"${state.cvv}"}',
          key1,
        );
        base64Encoded = base64Encode(encrypted.codeUnits);
      }
      final response = await bankCardService.encryptionKey(
        _intl.localeName,
      );
      final rsa = RsaKeyHelper();
      final key1 = rsa.parsePublicKeyFromPem(response.key);
      final encryptedCvv = encrypt('"cvv":"${state.cvv}"}', key1);
      final base64EncodedCvv = base64Encode(encryptedCvv.codeUnits);
      final model = input.cardId != null ? CardBuyExecuteRequestModel(
        paymentId: state.paymentId,
        paymentMethod: CirclePaymentMethod.bankCard,
        cardPaymentData: BankCardPaymentDataExecuteModel(
          cardId: input.cardId ?? '',
          encKeyId: response.keyId,
          encData: base64EncodedCvv,
        ),
      ) : CardBuyExecuteRequestModel(
        paymentId: state.paymentId,
        paymentMethod: CirclePaymentMethod.bankCard,
        cardPaymentData: BankCardPaymentDataExecuteModel(
          cardId: input.cardId ?? '',
          encKeyId: input.encKeyId,
          encData: base64Encoded,
          expMonth: input.expMonth,
          expYear: input.expYear,
          isActive: input.isActive,
        ),
      );

      await read(cardBuyServicePod).cardBuyExecutePayment(
        model,
        _intl.localeName,
      );

      onSuccess();
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, '_requestPayment', error.cause);

      _showFailureScreen(error.cause);
    } catch (error) {
      _logger.log(stateFlow, '_requestPayment', error);

      _showFailureScreen(_intl.something_went_wrong);
    }
  }

  Future<void> _requestPaymentInfo(
      Function(
        String,
        Function(String, String),
        Function(String),
        String,
      ) onAction,
      String lastAction,
    ) async {
    _logger.log(notifier, '_requestPaymentInfo');
    try {
      final model = CardBuyInfoRequestModel(
        paymentId: state.paymentId,
      );

      final response = await read(cardBuyServicePod).cardBuyInfo(
        model,
        _intl.localeName,
      );

      final pending = response.status == CardBuyPaymentStatus.inProcess ||
          response.status == CardBuyPaymentStatus.preview ||
          response.status == CardBuyPaymentStatus.waitForPayment;
      final complete = response.status == CardBuyPaymentStatus.success;
      final failed = response.status == CardBuyPaymentStatus.fail;
      final actionRequired =
          response.status == CardBuyPaymentStatus.requireAction;
      if (state.isWaitingSkipped) {
        return;
      }

      if (pending ||
          (actionRequired && lastAction == response.clientAction!.checkoutUrl)
      ) {
        await Future.delayed(const Duration(seconds: 1));
        await _requestPaymentInfo(onAction, lastAction);
      } else if (complete) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (state.isWaitingSkipped) {
          return;
        }
        _showSuccessScreen();
      } else if (failed) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (state.isWaitingSkipped) {
          return;
        }
        throw Exception();
      } else if (actionRequired) {
        onAction(
          response.clientAction!.checkoutUrl ?? '',
          (payment, lastAction) {
            Navigator.pop(_context);
            state = state.copyWith(
              paymentId: payment,
              wasAction: true,
            );
            state.loader.startLoadingImmediately();
            _requestPaymentInfo(onAction, lastAction);
          },
          (payment) {
            navigateToRouter(_context.read);
            read(navigationStpod).state = 1;
          },
          state.paymentId,
        );
      }
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, '_requestPaymentInfo', error.cause);

      _showFailureScreen(error.cause);
    } catch (error) {
      _logger.log(stateFlow, '_requestPaymentInfo', error);

      if (!error.toString().contains('Bad state:')) {
        _showFailureScreen(_intl.something_went_wrong);
      }
    }
  }

  void _showSuccessScreen() {
    return SuccessScreen.push(
      context: _context,
      secondaryText: '${_intl.buyWithCircle_paymentWillBeProcessed} \n'
          ' ≈ 10-30 ${_intl.buyWithCircle_minutes}',
      then: () {
        read(navigationStpod).state = 1;
      },
      buttonText: _intl.previewBuyWithUmlimint_saveCard,
      showProgressBar: true,
    );
  }

  void _showFailureScreen(String error) {
    return FailureScreen.push(
      context: _context,
      primaryText: _intl.previewBuyWithAsset_failure,
      secondaryText: error,
      primaryButtonName: _intl.previewBuyWithAsset_editOrder,
      onPrimaryButtonTap: () {
        Navigator.pop(_context);
        Navigator.pop(_context);
      },
      secondaryButtonName: _intl.previewBuyWithAsset_close,
      onSecondaryButtonTap: () => navigateToRouter(read),
    );
  }

  Future<void> _isChecked() async {
    try {
      final storage = read(localStorageServicePod);
      final status = await storage.getValue(checkedBankCard);
      if (status != null) {
        state = state.copyWith(
          isChecked: true,
        );
      }
    } catch (e) {
      _logger.log(notifier, '_isChecked');
    }
  }

  Future<void> pasteCode() async {
    _logger.log(notifier, 'pasteCode');

    final data = await Clipboard.getData('text/plain');
    final code = data?.text?.trim() ?? '';

    if (code.length == 3) {
      try {
        int.parse(code);
        state = state.copyWith(cvv: code);
        if (!mounted) return;
        Navigator.pop(_context);
        await _createPayment();
      } catch (e) {
        return;
      }
    }
  }

  void checkSetter() {
    state = state.copyWith(isChecked: !state.isChecked);
  }

  void skippedWaiting() {
    state = state.copyWith(isWaitingSkipped: true);
  }
}
