import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_confirm_union.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_address_store.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_preview_store.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/fields/standard_field/base/standard_field_error_notifier.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/validation_api/models/validation/verify_withdrawal_verification_code_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdraw/withdraw_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdrawal_resend/withdrawal_resend_request.dart';

part 'withdrawal_confirm_store.g.dart';

class WithdrawalConfirmStore extends _WithdrawalConfirmStoreBase
    with _$WithdrawalConfirmStore {
  WithdrawalConfirmStore() : super();

  static _WithdrawalConfirmStoreBase of(BuildContext context) =>
      Provider.of<WithdrawalConfirmStore>(context, listen: false);
}

abstract class _WithdrawalConfirmStoreBase with Store {
  _WithdrawalConfirmStoreBase();

  @observable
  TextEditingController controller = TextEditingController();

  WithdrawalModel? withdrawal;
  WithdrawalPreviewStore? previewStore;
  WithdrawalAddressStore? addressStore;

  @action
  void setNewOperation(
    WithdrawalModel w,
    WithdrawalPreviewStore p,
    WithdrawalAddressStore a,
  ) {
    loader = StackLoaderStore();
    pinError = StandardFieldErrorNotifier();

    withdrawal = w;
    previewStore = p;
    addressStore = a;

    _operationId = previewStore!.operationId;
    _verb = withdrawal!.dictionary.verb.toLowerCase();
  }

  @observable
  WithdrawalConfirmUnion union = const WithdrawalConfirmUnion.input();

  @observable
  bool isResending = false;

  @observable
  String _operationId = '';

  @observable
  String _verb = '';

  @observable
  bool isProcessing = false;

  static final _logger = Logger('WithdrawalConfirmStore');

  FocusNode focusNode = FocusNode();

  StackLoaderStore loader = StackLoaderStore();
  StandardFieldErrorNotifier pinError = StandardFieldErrorNotifier();

  @action
  void clear() {
    updateCode('', _operationId);

    loader = StackLoaderStore();
    pinError = StandardFieldErrorNotifier();
  }

  @action
  void updateCode(String code, String operationId) {
    _logger.log(notifier, 'updateCode');

    if (code.isEmpty) {
      return;
    }

    if (operationId == _operationId) {
      controller.text = code;

      verifyCode();
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

    if (union is Loading) {
      return;
    }

    union = const WithdrawalConfirmUnion.loading();

    try {
      final model = VerifyWithdrawalVerificationCodeRequestModel(
        operationId: _operationId,
        code: controller.text,
        brand: 'simple',
      );

      final resp = await sNetwork
          .getValidationModule()
          .postVerifyWithdrawalVerificationCode(model);

      if (resp.hasError) {
        _logger.log(stateFlow, 'verifyCode', resp.error);

        union = WithdrawalConfirmUnion.error(resp.error);

        _showFailureScreen();
      } else {
        union = const WithdrawalConfirmUnion.input();

        if (withdrawal!.currency != null) {
          _showSuccessScreen();
        } else {
          await sRouter.push(
            SuccessScreenRouter(
              secondaryText: intl.nft_send_confirm,
              showProgressBar: true,
              onSuccess: (context) {
                sRouter.replaceAll([
                  const HomeRouter(
                    children: [
                      PortfolioRouter(),
                    ],
                  ),
                ]);
              },
            ),
          );
        }
      }
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'verifyCode', error.cause);

      union = WithdrawalConfirmUnion.error(error.cause);
    } catch (error) {
      print(error);
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
    sRouter.push(
      SuccessScreenRouter(
        secondaryText:
            '${intl.withdrawalConfirm_your} ${withdrawal!.currency!.symbol}'
            ' $_verb '
            '${intl.withdrawalConfirm_requestHasBeenSubmitted}',
        onSuccess: (context) {
          addressStore!.clearData();

          sRouter.replaceAll([
            const HomeRouter(
              children: [
                PortfolioRouter(),
              ],
            ),
          ]);
        },
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
          /*sRouter.push(
            WithdrawalAmountRouter(
              withdrawal: withdrawal!,
              network: '',
              addressStore: addressStore!,
            ),
          );*/
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
