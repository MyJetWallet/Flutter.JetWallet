import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/transfer/model/tranfer_by_phone/transfer_by_phone_request_model.dart';
import '../../../../../../service/shared/models/server_reject_exception.dart';
import '../../../../../../shared/components/result_screens/failure_screens/failure_screen.dart';
import '../../../../../../shared/components/result_screens/failure_screens/no_response_from_server.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../screens/navigation/provider/navigation_stpod.dart';
import '../../../currency_withdraw/model/withdrawal_model.dart';
import '../../view/screens/send_confirm.dart';
import '../../view/screens/send_input_amount.dart';
import '../send_amount_notifier/send_amount_notipod.dart';
import '../send_input_phone_number/send_input_phone_number_notipod.dart';
import 'send_preview_state.dart';

class SendPreviewNotifier extends StateNotifier<SendPreviewState> {
  SendPreviewNotifier(
    this.read,
    this.withdrawal,
  ) : super(const SendPreviewState()) {
    final amount = read(sendAmountNotipod(withdrawal));
    final phoneNumber = read(sendInputPhoneNumberNotipod);

    state = state.copyWith(
      amount: amount.amount,
      phoneNumber: phoneNumber.phoneNumber,
    );

    _context = read(sNavigatorKeyPod).currentContext!;
  }

  final Reader read;
  final WithdrawalModel withdrawal;

  late BuildContext _context;

  static final _logger = Logger('SendPreviewNotifier');

  Future<void> send() async {
    _logger.log(notifier, 'send');

    state = state.copyWith(loading: true);

    try {
      final model = TransferByPhoneRequestModel(
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        assetSymbol: withdrawal.currency.symbol,
        amount: double.parse(state.amount),
        lang: read(intlPod).localeName,
        toPhoneNumber: state.phoneNumber.substring(1),
      );

      final response = await read(transferServicePod).transferByPhone(model);

      _updateOperationId(response.operationId);
      _updateReceiverIsRegistered(response.receiverIsRegistered);

      _showSendConfirm();
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'send', error.cause);

      _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'send', error);

      _showNoResponseScreen();
    }

    state = state.copyWith(loading: false);
  }

  void _updateOperationId(String value) {
    state = state.copyWith(operationId: value);
  }

  void _updateReceiverIsRegistered(bool value) {
    state = state.copyWith(receiverIsRegistered: value);
  }

  void _showSendConfirm() {
    navigatorPush(
      _context,
      SendConfirm(
        withdrawal: withdrawal,
      ),
    );
  }

  void _showNoResponseScreen() {
    navigatorPush(
      _context,
      NoResponseFromServer(
        description: 'Failed to place Order',
        onOk: () {
          read(navigationStpod).state = 1; // Portfolio
          navigateToRouter(read);
        },
      ),
    );
  }

  void _showFailureScreen(ServerRejectException error) {
    navigatorPush(
      _context,
      FailureScreen(
        description: error.cause,
        firstButtonName: 'Edit Order',
        onFirstButton: () {
          Navigator.pushAndRemoveUntil(
            _context,
            MaterialPageRoute(
              builder: (_) => SendInputAmount(withdrawal: withdrawal),
            ),
            (route) => route.isFirst,
          );
        },
        secondButtonName: 'Close',
        onSecondButton: () => navigateToRouter(read),
      ),
    );
  }
}
