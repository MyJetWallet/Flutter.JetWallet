import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
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
import '../../model/preview_buy_with_unlimint_input.dart';
import '../../view/screens/preview_buy_with_circle/circle_3d_secure_web_view/circle_3d_secure_web_view.dart';
import 'preview_buy_with_unlimint_state.dart';

class PreviewBuyWithUnlimintNotifier
    extends StateNotifier<PreviewBuyWithUnlimintState> {
  PreviewBuyWithUnlimintNotifier(
    this.input,
    this.read,
  ) : super(PreviewBuyWithUnlimintState(loader: StackLoaderNotifier())) {
    _context = read(sNavigatorKeyPod).currentContext!;
    _intl = read(intlPod);
    _initState();
    _requestPreview();
  }

  final Reader read;
  final PreviewBuyWithUnlimintInput input;

  late BuildContext _context;
  late AppLocalizations _intl;

  static final _logger = Logger('PreviewBuyWithUnlimintNotifier');

  void _initState() {
    state = state.copyWith(
      amountToGet: Decimal.parse(input.amount),
      amountToPay: Decimal.parse(input.amount),
    );
  }

  Future<void> _requestPreview() async {
    state.loader.startLoadingImmediately();

    final model = CardBuyCreateRequestModel(
      paymentMethod: CirclePaymentMethod.unlimint,
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
    storage.setString(checkedUnlimint, 'true');
    _createPayment();
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
              value: jsonEncode('unlimintCard'),
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

    try {
      final model = CardBuyExecuteRequestModel(
        paymentId: state.paymentId,
        paymentMethod: CirclePaymentMethod.unlimint,
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

      if (pending ||
          (actionRequired && lastAction == response.clientAction!.checkoutUrl)
      ) {
        await Future.delayed(const Duration(seconds: 1));
        await _requestPaymentInfo(onAction, lastAction);
      } else if (complete) {
        _showSuccessScreen();
      } else if (failed) {
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
      final status = await storage.getValue(checkedUnlimint);
      if (status != null) {
        state = state.copyWith(
          isChecked: true,
        );
      }
    } catch (e) {
      _logger.log(notifier, '_isChecked');
    }
  }

  void checkSetter() {
    state = state.copyWith(isChecked: !state.isChecked);
  }
}
