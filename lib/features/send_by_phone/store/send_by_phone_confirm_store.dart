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
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
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
  SendByPhoneConfirmStore() : super();

  static _SendByPhoneConfirmStoreBase of(BuildContext context) =>
      Provider.of<SendByPhoneConfirmStore>(context, listen: false);
}

abstract class _SendByPhoneConfirmStoreBase with Store {
  _SendByPhoneConfirmStoreBase() {
    loader.finishLoadingImmediately();
  }

  CurrencyModel? currency;

  SendByPhoneConfirmInput? input;

  final loader = StackLoaderStore();

  @action
  void initStore(
    CurrencyModel c,
    SendByPhoneConfirmInput i,
  ) {
    currency = c;
    input = i;

    _operationId = input!.operationId;
    _receiverIsRegistered = input!.receiverIsRegistered;
    _toPhoneNumber = input!.toPhoneNumber;

    redirectedToSuccess = false;
  }

  @action
  void clear() {
    updateCode('', _operationId);
    loader.finishLoadingImmediately();
    controller.text = '';
    union = const SendByPhoneConfirmUnion.input();
  }

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
  void updateCode(String code, String operationId, {bool isDeepLink = false}) {
    _logger.log(notifier, 'updateCode');

    if (code.isEmpty) {
      return;
    }

    if (operationId == _operationId) {
      controller.text = code;
      if (isDeepLink) {
        verifyCode();
      }
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

      union = const SendByPhoneConfirmUnion.input();
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

    loader.startLoading();

    if (union is Loading) {
      return;
    }

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

      if (response.hasError) {
        _logger.log(stateFlow, 'verifyCode', response.error!.cause);

        union = SendByPhoneConfirmUnion.error(response.error!.cause);
      } else {
        union = const SendByPhoneConfirmUnion.input();

        _showSuccessScreen();
        clear();

        loader.finishLoadingImmediately();
      }
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

  var redirectedToSuccess = false;

  @action
  void _showSuccessScreen() {
    if (redirectedToSuccess) return;

    redirectedToSuccess = true;
    sRouter
        .push(
      SuccessScreenRouter(
        secondaryText: '${intl.sendByPhoneConfirm_your} ${currency!.symbol}'
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
              currency: currency!,
            ),
          );
        },
        secondaryButtonName: intl.sendByPhoneConfirm_close,
        onSecondaryButtonTap: () => navigateToRouter(),
      ),
    );
  }
}
