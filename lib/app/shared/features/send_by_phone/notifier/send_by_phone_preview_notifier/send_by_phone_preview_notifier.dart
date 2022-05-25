import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/transfer/model/tranfer_by_phone/transfer_by_phone_request_model.dart';
import '../../../../../../service/shared/models/server_reject_exception.dart';
import '../../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../../shared/helpers/decompose_phone_number.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../screens/navigation/provider/navigation_stpod.dart';
import '../../../../models/currency_model.dart';
import '../../view/screens/send_by_phone_amount.dart';
import '../../view/screens/send_by_phone_confirm.dart';
import '../send_by_phone_amount_notifier/send_by_phone_amount_notipod.dart';
import 'send_by_phone_preview_state.dart';

class SendByPhonePreviewNotifier
    extends StateNotifier<SendByPhonePreviewState> {
  SendByPhonePreviewNotifier(
    this.read,
    this.currency,
  ) : super(const SendByPhonePreviewState()) {
    final amount = read(sendByPhoneAmountNotipod(currency));

    state = state.copyWith(
      amount: amount.amount,
      pickedContact: amount.pickedContact,
    );

    _context = read(sNavigatorKeyPod).currentContext!;
  }

  final Reader read;
  final CurrencyModel currency;

  late BuildContext _context;

  static final _logger = Logger('SendByPhonePreviewNotifier');

  Future<void> send() async {
    _logger.log(notifier, 'send');

    state = state.copyWith(loading: true);

    try {
      final number = await decomposePhoneNumber(
        state.pickedContact!.phoneNumber,
      );

      final model = TransferByPhoneRequestModel(
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        assetSymbol: currency.symbol,
        amount: Decimal.parse(state.amount),
        toPhoneBody: number.body,
        toPhoneCode: number.dialCode,
        toPhoneIso: number.isoCode,
        locale: read(intlPod).localeName,
      );

      final intl = read(intlPod);
      final response = await read(transferServicePod).transferByPhone(
        model,
        intl.localeName,
      );

      _updateOperationId(response.operationId);
      _updateReceiverIsRegistered(response.receiverIsRegistered);

      _showSendByPhoneConfirm();
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

  void _showSendByPhoneConfirm() {
    navigatorPush(
      _context,
      SendByPhoneConfirm(
        currency: currency,
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
      primaryText: intl.sendByPhonePreview_failure,
      secondaryText: error.cause,
      primaryButtonName: intl.sendByPhonePreview_editOrder,
      onPrimaryButtonTap: () {
        Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(
            builder: (_) => SendByPhoneAmount(currency: currency),
          ),
          (route) => route.isFirst,
        );
      },
      secondaryButtonName: intl.sendByPhonePreview_close,
      onSecondaryButtonTap: () => navigateToRouter(read),
    );
  }
}
