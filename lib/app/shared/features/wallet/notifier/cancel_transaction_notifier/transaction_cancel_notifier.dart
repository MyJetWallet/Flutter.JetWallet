import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/transfer/model/transfer_cancel/transfer_cancel_request_model.dart';

import '../../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import 'transaction_cancel_state.dart';

class TransactionCancelNotifier extends StateNotifier<TransactionCancelState> {
  TransactionCancelNotifier(
    this.read,
  ) : super(const TransactionCancelState()) {
    _context = read(sNavigatorKeyPod).currentContext!;
  }

  final Reader read;

  late BuildContext _context;

  static final _logger = Logger('TransactionCancelNotifier');

  Future<void> cancelTransaction(String? transferId) async {
    _logger.log(notifier, 'cancelTransaction');
    state = state.copyWith(loading: true);

    try {
      final intl = read(intlPod);
      final response = await read(transferServicePod).transferCancel(
        TransferCancelRequestModel(transferId:transferId,),
        intl.localeName,
      );
      if (response.isSuccess) {
        _showSuccessScreen();
      } else {
        _showFailureScreen();
      }
    } catch (error) {
      _logger.log(stateFlow, 'cancelTransaction', error);
      _showFailureScreen();
    }
    state = state.copyWith(loading: false);
  }

  void _showSuccessScreen() {
    final intl = read(intlPod);
    return FailureScreen.push(
      context: _context,
      primaryText: intl.cancel_transfer_dialog_text,
      primaryButtonName: intl.cancel_transfer_dialog_btn_gotIt,
      onPrimaryButtonTap: () {
        Navigator.pop(_context);
        Navigator.pop(_context);
        Navigator.maybePop(_context);

      },
    );
  }

  void _showFailureScreen() {
    final intl = read(intlPod);
    read(sNotificationNotipod.notifier).showError(
      intl.cancel_transfer_we_could_not_cancel,
    );
  }
}
