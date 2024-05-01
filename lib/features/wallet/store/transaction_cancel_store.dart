import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/modules/shared/simple_show_alert_popup.dart';
import 'package:simple_kit/utils/constants.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer_cancel/transfer_cancel_request_model.dart';

part 'transaction_cancel_store.g.dart';

class TransactionCancelStore = _TransactionCancelStoreBase
    with _$TransactionCancelStore;

abstract class _TransactionCancelStoreBase with Store {
  static final _logger = Logger('TransactionCancelStore');

  @observable
  bool loading = false;

  @action
  Future<void> cancelTransaction(String? transferId) async {
    _logger.log(notifier, 'cancelTransaction');
    loading = true;

    try {
      final response = await sNetwork.getWalletModule().postTransferCancel(
            TransferCancelRequestModel(
              transferId: transferId,
            ),
          );

      response.pick(
        onData: (data) {
          if (data.isSuccess) {
            _showSuccessScreen();
          } else {
            _showFailureScreen();
          }
        },
        onError: (error) {
          _logger.log(stateFlow, 'cancelTransaction', error);
          _showFailureScreen();
        },
      );
    } catch (error) {
      _logger.log(stateFlow, 'cancelTransaction', error);
      _showFailureScreen();
    }

    loading = false;
  }

  @action
  void _showSuccessScreen() {
    sRouter.maybePop();

    sShowAlertPopup(
      sRouter.navigatorKey.currentContext!,
      willPopScope: false,
      primaryText: intl.cancel_transfer_dialog_text,
      primaryButtonName: intl.cancel_transfer_dialog_btn_gotIt,
      image: Image.asset(
        ellipsisAsset,
        width: 80,
        height: 80,
        package: 'simple_kit',
      ),
      onPrimaryButtonTap: () {
        Navigator.pop(sRouter.navigatorKey.currentContext!);
        Navigator.maybePop(sRouter.navigatorKey.currentContext!);
      },
    );
  }

  @action
  void _showFailureScreen() {
    sNotification.showError(
      intl.cancel_transfer_we_could_not_cancel,
    );
  }
}
