import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../../service/services/blockchain/model/withdrawal_info/withdrawal_info_request_model.dart';
import '../../../../../../service/services/blockchain/model/withdrawal_info/withdrawal_info_response_model.dart';
import '../../../../../../service/services/blockchain/model/withdrawal_resend/withdrawal_resend_request.dart';
import '../../../../../../shared/components/result_screens/failure_screens/failure_screen.dart';
import '../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/helpers/show_plain_snackbar.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/other/navigator_key_pod.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../models/currency_model.dart';
import '../../view/screens/withdrawal_amount.dart';
import '../withdrawal_preview_notifier/withdrawal_preview_notipod.dart';

const _retryTime = 5; // in seconds

/// Queries withdrawalInfo every [n] seconds and acts acording to response
/// 1. If withdrawal is pending continue querying
/// 2. If withdrawal is successful redirects to SuccessScreen
/// 3. If withdrawal is failed redirects to FailureScreen
class WithdrawalConfirmNotifier extends StateNotifier<void> {
  WithdrawalConfirmNotifier(
    this.read,
    this.currency,
  ) : super(null) {
    _operationId = read(withdrawalPreviewNotipod(currency)).operationId;
    _context = read(navigatorKeyPod).currentContext!;
    _requestWithdrawalInfo();
  }

  final Reader read;
  final CurrencyModel currency;

  Timer? _timer;
  late int retryTime;
  late BuildContext _context;
  late String _operationId;

  static final _logger = Logger('WithdrawalConfirmNotifier');

  Future<void> withdrawalResend({required Function() then}) async {
    _logger.log(notifier, 'withdrawalResend');

    try {
      final service = read(blockchainServicePod);

      final model = WithdrawalResendRequestModel(
        operationId: _operationId,
      );

      await service.withdrawalResend(model);

      if (!mounted) return;
      then();
    } catch (error) {
      _logger.log(stateFlow, 'withdrawalResend', error);
      showPlainSnackbar(_context, 'Failed to resend. Try again!');
    }
  }

  Future<void> _requestWithdrawalInfo() async {
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
      } else {
        _showFailureScreen();
      }
    } catch (error) {
      _logger.log(stateFlow, '_withdrawalInfo', error);

      _refreshTimer();
    }
  }

  void _refreshTimer() {
    _timer?.cancel();
    retryTime = _retryTime;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (retryTime == 0) {
          timer.cancel();
          _requestWithdrawalInfo();
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
    navigatorPush(
      _context,
      SuccessScreen(
        description: 'Your ${currency.symbol} withdraw '
            'request has been submitted',
      ),
    );
  }

  void _showFailureScreen() {
    navigatorPush(
      _context,
      FailureScreen(
        description: 'Failed to withdraw',
        firstButtonName: 'Edit Order',
        onFirstButton: () {
          Navigator.pushAndRemoveUntil(
            _context,
            MaterialPageRoute(
              builder: (_) => WithdrawalAmount(
                currency: currency,
              ),
            ),
            (route) => route.isFirst,
          );
        },
        secondButtonName: 'Close',
        onSecondButton: () => navigateToRouter(read(navigatorKeyPod)),
      ),
    );
  }
}
