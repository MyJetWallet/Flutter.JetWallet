import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/blockchain/model/withdraw/withdraw_request_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';

import '../../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../screens/navigation/provider/navigation_stpod.dart';
import '../../model/withdrawal_model.dart';
import '../../view/screens/withdrawal_amount.dart';
import '../../view/screens/withdrawal_confirm.dart';
import '../withdrawal_amount_notifier/withdrawal_amount_notipod.dart';
import 'withdrawal_preview_state.dart';

/// Performs withdrawal operation and process response
class WithdrawalPreviewNotifier extends StateNotifier<WithdrawalPreviewState> {
  WithdrawalPreviewNotifier(
    this.read,
    this.withdrawal,
  ) : super(const WithdrawalPreviewState()) {
    final amount = read(withdrawalAmountNotipod(withdrawal));

    state = state.copyWith(
      tag: amount.tag,
      address: amount.address,
      amount: amount.amount,
      addressIsInternal: amount.addressIsInternal,
      blockchain: amount.blockchain,
    );

    _context = read(sNavigatorKeyPod).currentContext!;
  }

  final Reader read;
  final WithdrawalModel withdrawal;

  late BuildContext _context;

  static final _logger = Logger('WithdrawalPreviewNotifier');

  Future<void> withdraw() async {
    _logger.log(notifier, 'withdraw');

    final intl = read(intlPod);
    state = state.copyWith(loading: true);

    try {
      final model = WithdrawRequestModel(
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        assetSymbol: withdrawal.currency.symbol,
        amount: Decimal.parse(state.amount),
        toAddress: state.address,
        blockchain: state.blockchain.id,
      );

      final response = await read(blockchainServicePod).withdraw(
        model,
        intl.localeName,
      );

      _updateOperationId(response.operationId);

      _showWithdrawConfirm();
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'withdraw', error.cause);

      _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'withdraw', error);

      _showNoResponseScreen();
    }

    state = state.copyWith(loading: false);
  }

  void _updateOperationId(String value) {
    state = state.copyWith(operationId: value);
  }

  void _showWithdrawConfirm() {
    navigatorPush(
      _context,
      WithdrawalConfirm(
        withdrawal: withdrawal,
      ),
    );
  }

  void _showNoResponseScreen() {
    final intl = read(intlPod);

    return FailureScreen.push(
      context: _context,
      primaryText: intl.showNoResponseScreen_text,
      secondaryText: intl.showNoResponseScreen_text2,
      primaryButtonName: intl.serverCode0_ok,
      onPrimaryButtonTap: () {
        read(navigationStpod).state = 1; // Portfolio
        navigateToRouter(read);
      },
    );
  }

  void _showFailureScreen(ServerRejectException error) {
    final intl = read(intlPod);

    return FailureScreen.push(
      context: _context,
      primaryText: intl.withdrawalPreview_failure,
      secondaryText: error.cause,
      primaryButtonName: intl.withdrawalPreview_editOrder,
      onPrimaryButtonTap: () {
        Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(
            builder: (_) => WithdrawalAmount(
              withdrawal: withdrawal,
              network: state.blockchain.id,
            ),
          ),
          (route) => route.isFirst,
        );
      },
      secondaryButtonName: intl.withdrawalPreview_close,
      onSecondaryButtonTap: () => navigateToRouter(read),
    );
  }
}
