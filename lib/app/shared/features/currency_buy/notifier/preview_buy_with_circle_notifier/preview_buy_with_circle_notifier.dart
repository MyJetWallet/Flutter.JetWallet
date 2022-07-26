import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:openpgp/openpgp.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/card_buy/model/create/card_buy_create_request_model.dart';
import 'package:simple_networking/services/card_buy/model/execute/card_buy_execute_request_model.dart';
import 'package:simple_networking/services/card_buy/model/info/card_buy_info_request_model.dart';
import 'package:simple_networking/services/card_buy/model/info/card_buy_info_response_model.dart';
import 'package:simple_networking/services/circle/model/circle_card.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';

import '../../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../../screens/navigation/provider/navigation_stpod.dart';
import '../../../add_circle_card/view/add_circle_card.dart';
import '../../model/preview_buy_with_circle_input.dart';
import '../../view/screens/preview_buy_with_circle/circle_3d_secure_web_view/circle_3d_secure_web_view.dart';
import '../../view/screens/preview_buy_with_circle/show_circle_cvv_bottom_sheet.dart';
import 'preview_buy_with_circle_state.dart';

class PreviewBuyWithCircleNotifier
    extends StateNotifier<PreviewBuyWithCircleState> {
  PreviewBuyWithCircleNotifier(
    this.input,
    this.read,
  ) : super(PreviewBuyWithCircleState(loader: StackLoaderNotifier())) {
    _context = read(sNavigatorKeyPod).currentContext!;
    _intl = read(intlPod);
    _initState();
    _requestPreview();
    _requestCards();
  }

  final Reader read;
  final PreviewBuyWithCircleInput input;

  late BuildContext _context;
  late AppLocalizations _intl;

  static final _logger = Logger('PreviewBuyWithCircleNotifier');

  void _initState() {
    state = state.copyWith(
      amountToGet: Decimal.parse(input.amount),
      amountToPay: Decimal.parse(input.amount),
      card: input.card,
    );
  }

  Future<void> _requestPreview() async {
    state.loader.startLoadingImmediately();

    final model = CardBuyCreateRequestModel(
      paymentMethod: CirclePaymentMethod.circle,
      paymentAmount: state.amountToPay!,
      buyAsset: input.currency.symbol,
      paymentAsset: 'USD',
      circlePaymentData: CirclePaymentDataModel(
        cardId: state.card!.id,
      ),
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
    }
  }

  void onConfirm() {
    _logger.log(notifier, 'onConfirm');

    if (cvvEnabled) {
      sAnalytics.circleCVVView();
      showCircleCvvBottomSheet(
        context: _context,
        header: '${_intl.previewBuyWithCircle_enter} CVV '
            '${_intl.previewBuyWithCircle_for} '
            '${state.card?.network} •••• ${state.card?.last4}',
        onCompleted: (cvv) {
          Navigator.pop(_context);
          state = state.copyWith(cvv: cvv);
          _createPayment();
        },
        input: input,
      );
    } else {
      _createPayment();
    }
  }

  Future<void> _createPayment() async {
    _logger.log(notifier, '_createPayment');

    state.loader.startLoadingImmediately();

    await _requestPayment(() async {
      await _requestPaymentInfo((url, onSuccess, paymentId) {
        if (!mounted) return;
        sAnalytics.circleRedirect();
        navigatorPush(
          _context,
          Circle3dSecureWebView(
            url,
            input.amount,
            state.currencySymbol,
            onSuccess,
            paymentId,
          ),
        );
        state.loader.finishLoadingImmediately();
      }, '',);
    });
  }

  Future<void> _requestCards() async {
    _logger.log(notifier, '_requestCards');
    try {
      final response = await read(circleServicePod).allCards();
      if (response.cards.isNotEmpty) {
        final actualCard = response.cards.where(
            (element) => element.id == state.card?.id,
        ).toList();
        if (actualCard.isNotEmpty) {
          state = state.copyWith(
            isPending: actualCard[0].status == CircleCardStatus.pending,
            wasPending: actualCard[0].status == CircleCardStatus.pending,
          );
        }
      }
    } catch (e) {
      await Future.delayed(const Duration(seconds: 5));
      await _requestCards();
    }
  }

  Future<void> _requestPayment(void Function() onSuccess) async {
    _logger.log(notifier, '_requestPayment');

    try {
      final encryption =
          await read(circleServicePod).encryptionKey(_intl.localeName);

      final base64Decoded = base64Decode(encryption.encryptionKey);
      final utf8Decoded = utf8.decode(base64Decoded);
      final encrypted = await OpenPGP.encrypt(
        state.cvv.isNotEmpty ? '{"cvv":"${state.cvv}"}' : '{}',
        utf8Decoded,
      );
      final utf8Encoded = utf8.encode(encrypted);
      final base64Encoded = base64Encode(utf8Encoded);

      final model = CardBuyExecuteRequestModel(
        paymentId: state.paymentId,
        paymentMethod: CirclePaymentMethod.circle,
        circlePaymentData: CirclePaymentDataExecuteModel(
          cardId: state.card!.id,
          keyId: encryption.keyId,
          encryptedData: base64Encoded,
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
      Function(String, Function(String, String), String) onAction,
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

      if (pending ||
          (actionRequired && lastAction == response.clientAction!.checkoutUrl)
      ) {
        await Future.delayed(const Duration(seconds: 5));
        await _requestPaymentInfo(onAction, lastAction);
      } else if (complete) {
        sAnalytics.circleSuccess(
          asset: input.currency.description,
          amount: input.amount,
          frequency: RecurringFrequency.oneTime,
        );
        _showSuccessScreen();
      } else if (failed) {
        throw Exception();
      } else if (actionRequired) {
        onAction(
          response.clientAction!.checkoutUrl ?? '',
          (payment, lastAction) {
            Navigator.pop(_context);
            state.copyWith(paymentId: payment);
            state.loader.startLoadingImmediately();
            _requestPaymentInfo(onAction, lastAction);
          },
          state.paymentId,
        );
      }
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, '_requestPaymentInfo', error.cause);

      _showFailureScreen(error.cause);
    } catch (error) {
      _logger.log(stateFlow, '_requestPaymentInfo', error);

      _showFailureScreen(_intl.something_went_wrong);
    }
  }

  void _showSuccessScreen() {
    sAnalytics.circleSuccess(
      asset: state.currencySymbol,
      amount: input.amount,
      frequency: RecurringFrequency.oneTime,
    );
    return SuccessScreen.push(
      context: _context,
      secondaryText: '${_intl.buyWithCircle_paymentWillBeProcessed} \n'
          ' ≈ 10-30 ${_intl.buyWithCircle_minutes}',
      then: () {
        read(navigationStpod).state = 1;
      },
    );
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

  void checkSetter() {
    state = state.copyWith(isChecked: !state.isChecked);
  }

  void setWasPending({required bool wasPending}) {
    state = state.copyWith(
      wasPending: wasPending,
    );
  }

  void setIsPending({required bool isPending}) {
    state = state.copyWith(
      isPending: isPending,
    );
  }

  void setFailureShowed({required bool failureShowed}) {
    state = state.copyWith(
      failureShowed: failureShowed,
    );
  }

  void showFailure() {
    final intl = read(intlPod);
    if (!mounted) return;
    if (!state.failureShowed) {
      setFailureShowed(failureShowed: true);
      sAnalytics.circleFailed();
      FailureScreen.push(
        context: _context,
        primaryText: intl.previewBuyWithCircle_failure,
        secondaryText: intl.previewBuyWithCircle_failureDescription,
        primaryButtonName: intl.previewBuyWithCircle_failureAnotherCard,
        onPrimaryButtonTap: () {
          sAnalytics.circleAdd();
          AddCircleCard.pushReplacement(
            context: _context,
            onCardAdded: (card) {
              Navigator.pop(_context);
              Navigator.pop(_context);
              Navigator.pop(_context);
            },
          );
        },
        secondaryButtonName: intl.previewBuyWithCircle_failureCancel,
        onSecondaryButtonTap: () {
          sAnalytics.circleCancel();
          Navigator.pop(_context);
          Navigator.pop(_context);
          Navigator.pop(_context);
        },
      );
    }
  }
}
