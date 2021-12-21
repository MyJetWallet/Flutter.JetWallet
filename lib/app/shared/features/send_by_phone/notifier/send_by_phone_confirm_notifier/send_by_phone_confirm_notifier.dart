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
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../screens/navigation/provider/navigation_stpod.dart';
import '../../../../models/currency_model.dart';
import '../../view/screens/send_by_phone_amount.dart';
import '../../view/screens/send_by_phone_notify_recipient.dart';
import '../send_by_phone_preview_notifier/send_by_phone_preview_notipod.dart';
import 'send_by_phone_confirm_state.dart';

/// How often we check transfer request status
const _retryTime = 5; // in seconds

/// Queries transferlInfo every [n] seconds and acts acording to response
/// 1. If transfer is pending continue querying
/// 2. If transfer is successful redirects to SuccessScreen
/// 3. If transfer is failed redirects to FailureScreen
class SendByPhoneConfirmNotifier
    extends StateNotifier<SendByPhoneConfirmState> {
  SendByPhoneConfirmNotifier(
    this.read,
    this.currency,
  ) : super(const SendByPhoneConfirmState()) {
    final preview = read(sendByPhonePreviewNotipod(currency));
    _operationId = preview.operationId;
    _receiverIsRegistered = preview.receiverIsRegistered;
    _context = read(sNavigatorKeyPod).currentContext!;
    requestTransferInfo();
  }

  final Reader read;
  final CurrencyModel currency;

  Timer? _timer;
  late int retryTime;
  late BuildContext _context;
  late String _operationId;
  late bool _receiverIsRegistered;
  late String toPhoneNumber;

  static final _logger = Logger('SendByPhoneConfirmNotifier');

  Future<void> transferResend({required Function() then}) async {
    _logger.log(notifier, 'transferResend');

    _updateIsResending(true);

    try {
      final service = read(transferServicePod);

      final model = TransferResendRequestModel(
        operationId: _operationId,
      );

      await service.transferResend(model);

      if (!mounted) return;
      _updateIsResending(false);
      then();
    } catch (error) {
      _logger.log(stateFlow, 'transferResend', error);
      _updateIsResending(false);
      sShowErrorNotification(
        read(sNotificationQueueNotipod.notifier),
        'Failed to resend. Try again!',
      );
    }
  }

  Future<void> requestTransferInfo() async {
    _logger.log(notifier, 'requestTransferInfo');

    if (!state.isRequesting) {
      await _requestTransferInfo();
    }
  }

  Future<void> _requestTransferInfo() async {
    _updateIsRequesting(true);

    try {
      final service = read(transferServicePod);

      final model = TransferInfoRequestModel(
        operationId: _operationId,
      );

      final response = await service.transferInfo(model);

      toPhoneNumber = response.toPhoneNumber;

      if (response.status == TransferStatus.pendingApproval) {
        _refreshTimer();
      } else if (response.status == TransferStatus.success) {
        _showSuccessScreen();
        _timer?.cancel();
      } else {
        _showFailureScreen();
        _timer?.cancel();
      }
    } catch (error) {
      _logger.log(stateFlow, '_requestTransferInfo', error);

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
          requestTransferInfo();
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
      secondaryText: 'Your ${currency.symbol} send '
          'request has been submitted',
      then: () {
        if (!_receiverIsRegistered) {
          navigatorPush(
            _context,
            SendByPhoneNotifyRecipient(
              toPhoneNumber: toPhoneNumber,
            ),
          );
        }
        read(navigationStpod).state = 1;
      },
    );
  }

  void _showFailureScreen() {
    return FailureScreen.push(
      context: _context,
      primaryText: 'Failure',
      secondaryText: 'Failed to send',
      primaryButtonName: 'Edit Order',
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
      secondaryButtonName: 'Close',
      onSecondaryButtonTap: () => navigateToRouter(read),
    );
  }
}
