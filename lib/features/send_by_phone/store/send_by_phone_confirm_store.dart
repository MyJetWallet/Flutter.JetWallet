import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/send_by_phone/model/send_by_phone_confirm_union.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_preview_store.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/validation_api/models/validation/verify_withdrawal_verification_code_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer_resend_request_model/transfer_resend_request_model.dart';
part 'send_by_phone_confirm_store.g.dart';

class SendByPhoneConfirmInput {
  SendByPhoneConfirmInput({
    required this.operationId,
    required this.receiverIsRegistered,
    required this.toPhoneNumber,
  });

  final String operationId;
  final bool receiverIsRegistered;
  final String toPhoneNumber;
}

class SendByPhoneConfirmStore extends _SendByPhoneConfirmStoreBase
    with _$SendByPhoneConfirmStore {
  SendByPhoneConfirmStore(
    CurrencyModel currency,
    SendByPhoneConfirmInput input,
  ) : super(currency, input);

  static _SendByPhoneConfirmStoreBase of(BuildContext context) =>
      Provider.of<SendByPhoneConfirmStore>(context, listen: false);
}

abstract class _SendByPhoneConfirmStoreBase with Store {
  _SendByPhoneConfirmStoreBase(
    this.currency,
    this.input,
  ) {
    _operationId = input.operationId;
    _receiverIsRegistered = input.receiverIsRegistered;
    _toPhoneNumber = input.toPhoneNumber;

    //sendByPhonePreviewStore.pickedContact?.phoneNumber ?? '';
  }

  final CurrencyModel currency;

  final SendByPhoneConfirmInput input;

  late String _operationId;
  late bool _receiverIsRegistered;
  late String _toPhoneNumber;

  static final _logger = Logger('SendByPhoneConfirmStore');

  @observable
  SendByPhoneConfirmUnion union = const SendByPhoneConfirmUnion.input();

  @observable
  bool isResending = false;

  @observable
  TextEditingController controller = TextEditingController();

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
  Future<void> transferResend({required Function() onSuccess}) async {
    _logger.log(notifier, 'transferResend');

    union = const SendByPhoneConfirmUnion.loading();

    _updateIsResending(true);

    try {
      final model = TransferResendRequestModel(
        operationId: _operationId,
      );

      final _ = await sNetwork.getWalletModule().postTransferResend(model);

      _updateIsResending(false);
      onSuccess();
    } catch (error) {
      _logger.log(stateFlow, 'transferResend', error);
      _updateIsResending(false);

      sNotification.showError(
        '${intl.sendByPhoneConfirm_failedToResend}!',
        id: 1,
      );
    }
  }

  @action
  Future<void> verifyCode() async {
    _logger.log(notifier, 'verifyCode');

    union = const SendByPhoneConfirmUnion.loading();

    try {
      final model = VerifyWithdrawalVerificationCodeRequestModel(
        operationId: _operationId,
        code: controller.text,
        brand: 'simple',
      );

      final response = await sNetwork
          .getValidationModule()
          .postVerifyTransferVerificationCode(model);

      response.pick(
        onNoData: () {
          union = const SendByPhoneConfirmUnion.input();

          sAnalytics.sendSuccess(type: 'By phone');
          _showSuccessScreen();
        },
        onData: (data) {
          union = const SendByPhoneConfirmUnion.input();

          sAnalytics.sendSuccess(type: 'By phone');
          _showSuccessScreen();
        },
        onError: (error) {
          _logger.log(stateFlow, 'verifyCode', error.cause);

          union = SendByPhoneConfirmUnion.error(error.cause);
        },
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'verifyCode', error.cause);

      union = SendByPhoneConfirmUnion.error(error.cause);
    } catch (error) {
      _logger.log(stateFlow, 'verifyCode', error);

      union = SendByPhoneConfirmUnion.error(error);

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
        secondaryText: '${intl.sendByPhoneConfirm_your} ${currency.symbol}'
            ' ${intl.sendByPhoneConfirm_send} '
            '${intl.sendByPhoneConfirm_requestHasBeenSubmitted}',
      ),
    )
        .then(
      (value) {
        if (!_receiverIsRegistered) {
          sRouter.push(
            SendByPhoneNotifyRecipientRouter(
              toPhoneNumber: _toPhoneNumber,
            ),
          );
        }
      },
    );
  }

  @action
  void _showFailureScreen() {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.sendByPhoneConfirm_failure,
        secondaryText: '${intl.sendByPhoneConfirm_failedTo}'
            ' ${intl.sendByPhoneConfirm_send}',
        primaryButtonName: intl.sendByPhoneConfirm_editOrder,
        onPrimaryButtonTap: () {
          sRouter.navigate(
            SendByPhoneAmountRouter(
              currency: currency,
            ),
          );
        },
        secondaryButtonName: intl.sendByPhoneConfirm_close,
        onSecondaryButtonTap: () => navigateToRouter(),
      ),
    );
  }
}
