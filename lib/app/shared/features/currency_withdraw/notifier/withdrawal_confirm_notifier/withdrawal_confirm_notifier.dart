import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/blockchain/model/withdrawal_resend/withdrawal_resend_request.dart';
import 'package:simple_networking/services/validation/model/verify_withdrawal_verification_code_request_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';

import '../../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../screens/navigation/provider/navigation_stpod.dart';
import '../../model/withdrawal_model.dart';
import '../../view/screens/withdrawal_amount.dart';
import '../withdrawal_preview_notifier/withdrawal_preview_notipod.dart';
import 'withdrawal_confirm_state.dart';
import 'withdrawal_confirm_union.dart';

class WithdrawalConfirmNotifier extends StateNotifier<WithdrawalConfirmState> {
  WithdrawalConfirmNotifier(
    this.read,
    this.withdrawal,
  ) : super(WithdrawalConfirmState(controller: TextEditingController())) {
    _operationId = read(withdrawalPreviewNotipod(withdrawal)).operationId;
    _context = read(sNavigatorKeyPod).currentContext!;
    _verb = withdrawal.dictionary.verb.toLowerCase();
  }

  final Reader read;
  final WithdrawalModel withdrawal;

  late BuildContext _context;
  late String _operationId;
  late String _verb;

  static final _logger = Logger('WithdrawalConfirmNotifier');

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

  Future<void> withdrawalResend({required Function() onSuccess}) async {
    _logger.log(notifier, 'withdrawalResend');

    final intl = read(intlPod);

    state = state.copyWith(union: const Loading());

    _updateIsResending(true);

    try {
      final service = read(blockchainServicePod);
      final intl = read(intlPod);

      final model = WithdrawalResendRequestModel(
        operationId: _operationId,
      );

      await service.withdrawalResend(model, intl.localeName);

      if (!mounted) return;
      _updateIsResending(false);
      onSuccess();
    } catch (error) {
      _logger.log(stateFlow, 'withdrawalResend', error);
      _updateIsResending(false);
      read(sNotificationNotipod.notifier).showError(
        '${intl.withdrawalConfirm_failedToResend}!',
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

      await service.verifyWithdrawalVerificationCode(model, intl.localeName);

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
          '${intl.withdrawalConfirm_your} ${withdrawal.currency.symbol}'
              ' $_verb '
              '${intl.withdrawalConfirm_requestHasBeenSubmitted}',
      then: () {
        read(navigationStpod).state = 1;
      },
    );
  }

  void _showFailureScreen() {
    final intl = read(intlPod);

    return FailureScreen.push(
      context: _context,
      primaryText: intl.withdrawalConfirm_failure,
      secondaryText: '${intl.withdrawalConfirm_failedTo} $_verb',
      primaryButtonName: intl.withdrawalConfirm_editOrder,
      onPrimaryButtonTap: () {
        Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(
            builder: (_) => WithdrawalAmount(
              withdrawal: withdrawal,
              network: '',
            ),
          ),
          (route) => route.isFirst,
        );
      },
      secondaryButtonName: intl.withdrawalConfirm_close,
      onSecondaryButtonTap: () => navigateToRouter(read),
    );
  }
}
