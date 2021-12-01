import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/transfer/model/transfer_info/transfer_info_request_model.dart';
import '../../../../../../service/services/transfer/model/transfer_info/transfer_info_response_model.dart';
import '../../../../../../service/services/transfer/model/transfer_resend_request_model/transfer_resend_request_model.dart';
import '../../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/helpers/show_plain_snackbar.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../currency_withdraw/model/withdrawal_model.dart';
import '../../view/screens/send_input_amount.dart';
import '../../view/screens/send_notify_friend.dart';
import '../send_preview_notifier/send_preview_notipod.dart';

/// How often we check withdraw request status
const _retryTime = 5; // in seconds

/// Queries withdrawalInfo every [n] seconds and acts acording to response
/// 1. If withdrawal is pending continue querying
/// 2. If withdrawal is successful redirects to SuccessScreen
/// 3. If withdrawal is failed redirects to FailureScreen
class SendConfirmNotifier extends StateNotifier<void> {
  SendConfirmNotifier(
    this.read,
    this.withdrawal,
  ) : super(null) {
    final sendPreview = read(sendPreviewNotipod(withdrawal));
    _operationId = sendPreview.operationId;
    _receiverIsRegistered = sendPreview.receiverIsRegistered;
    _context = read(sNavigatorKeyPod).currentContext!;
    _verb = withdrawal.dictionary.verb.toLowerCase();
    _requestSendInfo();
  }

  final Reader read;
  final WithdrawalModel withdrawal;

  Timer? _timer;
  late int retryTime;
  late BuildContext _context;
  late String _operationId;
  late bool _receiverIsRegistered;
  late String _verb;

  static final _logger = Logger('SendConfirmNotifier');

  Future<void> resendTransfer({required Function() then}) async {
    _logger.log(notifier, 'resendTransfer');

    try {
      final service = read(transferServicePod);

      final model = TransferResendRequestModel(
        operationId: _operationId,
      );

      await service.resendTransfer(model);

      if (!mounted) return;
      then();
    } catch (error) {
      _logger.log(stateFlow, 'resendTransfer', error);
      showPlainSnackbar(_context, 'Failed to resend. Try again!');
    }
  }

  Future<void> _requestSendInfo() async {
    try {
      final model = TransferInfoRequestModel(
        transferId: _operationId,
      );

      final response = await read(transferServicePod).transferInfo(model);

      if (response.status == TransferInfoStatus.pendingApproval) {
        _refreshTimer();
      } else if (response.status == TransferInfoStatus.success) {
        _showSuccessScreen();
      } else {
        _showFailureScreen();
      }
    } catch (error) {
      _logger.log(stateFlow, '_requestSendInfo', error);

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
          _requestSendInfo();
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
        if (!_receiverIsRegistered) {
          navigatorPush(_context, const SendNotifyFriend());
        }
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
            builder: (_) => SendInputAmount(
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
