import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/transfer/model/transfer_resend_request_model/transfer_resend_request_model.dart';
import 'package:simple_networking/services/validation/model/verify_withdrawal_verification_code_request_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';

import '../../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../screens/navigation/provider/navigation_stpod.dart';
import '../../../../models/currency_model.dart';
import '../../view/screens/send_by_phone_amount.dart';
import '../../view/screens/send_by_phone_notify_recipient.dart';
import '../send_by_phone_preview_notifier/send_by_phone_preview_notipod.dart';
import 'send_by_phone_confirm_state.dart';
import 'send_by_phone_confirm_union.dart';

class SendByPhoneConfirmNotifier
    extends StateNotifier<SendByPhoneConfirmState> {
  SendByPhoneConfirmNotifier(
    this.read,
    this.currency,
  ) : super(SendByPhoneConfirmState(controller: TextEditingController())) {
    final preview = read(sendByPhonePreviewNotipod(currency));
    _operationId = preview.operationId;
    _receiverIsRegistered = preview.receiverIsRegistered;
    _context = read(sNavigatorKeyPod).currentContext!;
    _toPhoneNumber = preview.pickedContact?.phoneNumber ?? '';
  }

  final Reader read;
  final CurrencyModel currency;

  late BuildContext _context;
  late String _operationId;
  late bool _receiverIsRegistered;
  late String _toPhoneNumber;

  static final _logger = Logger('SendByPhoneConfirmNotifier');

  void updateCode(String code, String operationId) {
    _logger.log(notifier, 'updateCode');

    final intl = read(intlPod);

    if (operationId == _operationId) {
      state.controller.text = code;
    } else {
      read(sNotificationNotipod.notifier).showError(
        intl.showError_youHaveConfirmed,
        id: 1,
      );
    }
  }

  Future<void> transferResend({required Function() onSuccess}) async {
    _logger.log(notifier, 'transferResend');

    state = state.copyWith(union: const Loading());

    _updateIsResending(true);

    try {
      final service = read(transferServicePod);

      final model = TransferResendRequestModel(
        operationId: _operationId,
      );

      final intl = read(intlPod);
      await service.transferResend(model, intl.localeName);

      if (!mounted) return;
      _updateIsResending(false);
      onSuccess();
    } catch (error) {
      _logger.log(stateFlow, 'transferResend', error);
      _updateIsResending(false);

      final intl = read(intlPod);

      read(sNotificationNotipod.notifier).showError(
        '${intl.sendByPhoneConfirm_failedToResend}!',
        id: 1,
      );
    }
  }

  Future<void> verifyCode() async {
    _logger.log(notifier, 'verifyCode');

    state = state.copyWith(union: const Loading());

    try {
      final service = read(validationServicePod);
      final intl = read(intlPod);

      final model = VerifyWithdrawalVerificationCodeRequestModel(
        operationId: _operationId,
        code: state.controller.text,
        brand: 'simple',
      );

      await service.verifyTransferVerificationCode(model, intl.localeName);

      state = state.copyWith(union: const Input());

      if (!mounted) return;

      sAnalytics.sendSuccess(type: 'By phone');
      _showSuccessScreen();
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'verifyCode', error.cause);

      state = state.copyWith(union: Error(error.cause));
    } catch (error) {
      _logger.log(stateFlow, 'verifyCode', error);

      state = state.copyWith(union: Error(error));

      if (!mounted) return;

      _showFailureScreen();
    }
  }

  void _updateIsResending(bool value) {
    state = state.copyWith(isResending: value);
  }

  void _showSuccessScreen() {
    final intl = read(intlPod);

    return SuccessScreen.push(
      context: _context,
      secondaryText:
          '${intl.sendByPhoneConfirm_your} ${currency.symbol}'
              ' ${intl.sendByPhoneConfirm_send} '
              '${intl.sendByPhoneConfirm_requestHasBeenSubmitted}',
      then: () {
        if (!_receiverIsRegistered) {
          navigatorPush(
            _context,
            SendByPhoneNotifyRecipient(
              toPhoneNumber: _toPhoneNumber,
            ),
          );
        }
        read(navigationStpod).state = 1;
      },
    );
  }

  void _showFailureScreen() {
    final intl = read(intlPod);

    return FailureScreen.push(
      context: _context,
      primaryText: intl.sendByPhoneConfirm_failure,
      secondaryText: '${intl.sendByPhoneConfirm_failedTo}'
          ' ${intl.sendByPhoneConfirm_send}',
      primaryButtonName: intl.sendByPhoneConfirm_editOrder,
      onPrimaryButtonTap: () {
        Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(
            builder: (_) => SendByPhoneAmount(
              currency: currency,
            ),
          ),
          (route) => route.isFirst,
        );
      },
      secondaryButtonName: intl.sendByPhoneConfirm_close,
      onSecondaryButtonTap: () => navigateToRouter(read),
    );
  }
}
