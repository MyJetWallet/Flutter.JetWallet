import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_confirm_union.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_preview_store.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/validation_api/models/validation/verify_withdrawal_verification_code_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdrawal_resend/withdrawal_resend_request.dart';

part 'withdrawal_confirm_store.g.dart';

class WithdrawalConfirmStore extends _WithdrawalConfirmStoreBase
    with _$WithdrawalConfirmStore {
  WithdrawalConfirmStore(WithdrawalModel withdrawal) : super(withdrawal);

  static _WithdrawalConfirmStoreBase of(BuildContext context) =>
      Provider.of<WithdrawalConfirmStore>(context, listen: false);
}

abstract class _WithdrawalConfirmStoreBase with Store {
  _WithdrawalConfirmStoreBase(this.withdrawal) {
    _operationId = WithdrawalPreviewStore(withdrawal).operationId;
    _verb = withdrawal.dictionary.verb.toLowerCase();
  }

  final WithdrawalModel withdrawal;

  TextEditingController controller = TextEditingController();

  @observable
  WithdrawalConfirmUnion union = const WithdrawalConfirmUnion.input();

  @observable
  bool isResending = false;

  @observable
  late String _operationId;

  @observable
  late String _verb;

  static final _logger = Logger('WithdrawalConfirmStore');

  FocusNode focusNode = FocusNode();

  @action
  void updateCode(String code, String operationId) {
    _logger.log(notifier, 'updateCode');

    if (operationId == _operationId) {
      controller.text = code;
    } else {
      sNotification.showError(
        intl.showError_youHaveConfirmed,
        id: 1,
      );
    }
  }

  @action
  Future<void> withdrawalResend({required Function() onSuccess}) async {
    _logger.log(notifier, 'withdrawalResend');

    union = const WithdrawalConfirmUnion.loading();

    _updateIsResending(true);

    try {
      final model = WithdrawalResendRequestModel(
        operationId: _operationId,
      );

      final _ = await sNetwork.getWalletModule().postWithdrawalResend(model);

      _updateIsResending(false);
      onSuccess();
    } catch (error) {
      _logger.log(stateFlow, 'withdrawalResend', error);
      _updateIsResending(false);

      sNotification.showError(
        '${intl.withdrawalConfirm_failedToResend}!',
        id: 1,
      );
    }
  }

  @action
  Future<void> verifyCode() async {
    _logger.log(notifier, 'verifyCode');

    union = const WithdrawalConfirmUnion.loading();

    try {
      final model = VerifyWithdrawalVerificationCodeRequestModel(
        operationId: _operationId,
        code: controller.text,
        brand: 'simple',
      );

      final _ = sNetwork
          .getValidationModule()
          .postVerifyWithdrawalVerificationCode(model);

      union = const WithdrawalConfirmUnion.input();

      sAnalytics.sendSuccess(type: 'By phone');
      _showSuccessScreen();
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'verifyCode', error.cause);

      union = WithdrawalConfirmUnion.error(error.cause);
    } catch (error) {
      _logger.log(stateFlow, 'verifyCode', error);

      union = WithdrawalConfirmUnion.error(error);

      _showFailureScreen();
    }
  }

  @action
  void _updateIsResending(bool value) {
    isResending = value;
  }

  @action
  void _showSuccessScreen() {
    sRouter
        .push(
          SuccessScreenRouter(
            secondaryText:
                '${intl.withdrawalConfirm_your} ${withdrawal.currency.symbol}'
                ' $_verb '
                '${intl.withdrawalConfirm_requestHasBeenSubmitted}',
          ),
        )
        .then(
          (value) => sRouter.navigate(
            const HomeRouter(
              children: [
                PortfolioRouter(),
              ],
            ),
          ),
        );
  }

  @action
  void _showFailureScreen() {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.withdrawalConfirm_failure,
        secondaryText: '${intl.withdrawalConfirm_failedTo} $_verb',
        primaryButtonName: intl.withdrawalConfirm_editOrder,
        onPrimaryButtonTap: () {
          sRouter.navigate(
            WithdrawalAmountRouter(
              withdrawal: withdrawal,
              network: '',
            ),
          );
        },
        secondaryButtonName: intl.withdrawalConfirm_close,
        onSecondaryButtonTap: () => sRouter.popUntilRoot(),
      ),
    );
  }

  @action
  void dispose() {
    focusNode.dispose();
  }
}
