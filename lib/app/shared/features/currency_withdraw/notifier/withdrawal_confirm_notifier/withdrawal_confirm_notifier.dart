import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/blockchain/model/withdrawal_info/withdrawal_info_request_model.dart';
import '../../../../../../service/services/blockchain/model/withdrawal_info/withdrawal_info_response_model.dart';
import '../../../../../../service/services/blockchain/model/withdrawal_resend/withdrawal_resend_request.dart';
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

/// How often we check withdraw request status
const _retryTime = 5; // in seconds

/// Queries withdrawalInfo every [n] seconds and acts acording to response
/// 1. If withdrawal is pending continue querying
/// 2. If withdrawal is successful redirects to SuccessScreen
/// 3. If withdrawal is failed redirects to FailureScreen
class WithdrawalConfirmNotifier extends StateNotifier<WithdrawalConfirmState> {
  WithdrawalConfirmNotifier(
    this.read,
    this.withdrawal,
  ) : super(const WithdrawalConfirmState()) {
    _operationId = read(withdrawalPreviewNotipod(withdrawal)).operationId;
    _context = read(sNavigatorKeyPod).currentContext!;
    _verb = withdrawal.dictionary.verb.toLowerCase();
    requestWithdrawalInfo();
  }

  final Reader read;
  final WithdrawalModel withdrawal;

  Timer? _timer;
  late int retryTime;
  late BuildContext _context;
  late String _operationId;
  late String _verb;

  static final _logger = Logger('WithdrawalConfirmNotifier');

  Future<void> withdrawalResend({required Function() onSuccess}) async {
    _logger.log(notifier, 'withdrawalResend');

    _updateIsResending(true);

    try {
      final service = read(blockchainServicePod);

      final model = WithdrawalResendRequestModel(
        operationId: _operationId,
      );

      await service.withdrawalResend(model);

      if (!mounted) return;
      _updateIsResending(false);
      onSuccess();
    } catch (error) {
      _logger.log(stateFlow, 'withdrawalResend', error);
      _updateIsResending(false);
      sShowErrorNotification(
        read(sNotificationQueueNotipod.notifier),
        'Failed to resend. Try again!',
      );
    }
  }

  Future<void> requestWithdrawalInfo() async {
    _logger.log(notifier, 'requestWithdrawalInfo');

    if (!state.isRequesting) {
      await _requestWithdrawalInfo();
    }
  }

  Future<void> _requestWithdrawalInfo() async {
    _updateIsRequesting(true);

    try {
      final service = read(blockchainServicePod);

      final model = WithdrawalInfoRequestModel(
        operationId: _operationId,
      );

      final response = await service.withdrawalInfo(model);

      if (response.status == WithdrawalStatus.pendingApproval) {
        _refreshTimer();
      } else if (response.status == WithdrawalStatus.success) {
        _showSuccessScreen();
        _timer?.cancel();
      } else {
        _showFailureScreen();
        _timer?.cancel();
      }
    } catch (error) {
      _logger.log(stateFlow, '_requestWithdrawalInfo', error);

      _refreshTimer();
    }

    _updateIsRequesting(false);
  }

  void _updateIsResending(bool value) {
    state = state.copyWith(isResending: value);
  }

  void _updateIsRequesting(bool value) {
    state = state.copyWith(isRequesting: value);
  }

  void _refreshTimer() {
    _timer?.cancel();
    retryTime = _retryTime;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (retryTime == 0) {
          timer.cancel();
          requestWithdrawalInfo();
        } else {
          retryTime -= 1;
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showSuccessScreen() {
    return SuccessScreen.push(
      context: _context,
      secondaryText: 'Your ${withdrawal.currency.symbol} $_verb '
          'request has been submitted',
      then: () {
        read(navigationStpod).state = 1;
      },
    );
  }

  void _showFailureScreen() {
    return FailureScreen.push(
      context: _context,
      primaryText: 'Failure',
      secondaryText: 'Failed to $_verb',
      primaryButtonName: 'Edit Order',
      onPrimaryButtonTap: () {
        Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(
            builder: (_) => WithdrawalAmount(
              withdrawal: withdrawal,
            ),
          ),
          (route) => route.isFirst,
        );
      },
      secondaryButtonName: 'Close',
      onSecondaryButtonTap: () => navigateToRouter(read),
    );
  }
}
