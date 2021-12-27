import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/transfer/model/tranfer_by_phone/transfer_by_phone_request_model.dart';
import '../../../../../../service/shared/models/server_reject_exception.dart';
import '../../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
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

    // final info = await PhoneNumber.getRegionInfoFromPhoneNumber(
    //   state.pickedContact!.phoneNumber,
    // );

    // final phoneNumber = PhoneNumber(
    //   phoneNumber: info.phoneNumber,
    //   isoCode: info.isoCode,
    // );

    // final parsable = await PhoneNumber.getParsableNumber(phoneNumber);

    // 1. ISO: info.isoCode
    // 2. COUNTRY CODE: +${info.dialCode}
    // 3. NUMBER: final number = parsable.replaceAll(' ', '');

    state = state.copyWith(loading: true);

    try {
      final model = TransferByPhoneRequestModel(
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        assetSymbol: currency.symbol,
        amount: double.parse(state.amount),
        // TODO refactor to function when backend will be ready
        toPhoneNumber: state.pickedContact!.phoneNumber
            .replaceAll(' ', '')
            .replaceAll('(', '')
            .replaceAll(')', '')
            .replaceAll('-', ''),
        lang: read(intlPod).localeName,
      );

      final response = await read(transferServicePod).transferByPhone(model);

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
    return FailureScreen.push(
      context: _context,
      primaryText: 'No Response From Server',
      secondaryText: 'Failed to place Order',
      primaryButtonName: 'OK',
      onPrimaryButtonTap: () {
        read(navigationStpod).state = 1; // Portfolio
        navigateToRouter(read);
      },
    );
  }

  void _showFailureScreen(ServerRejectException error) {
    return FailureScreen.push(
      context: _context,
      primaryText: 'Failure',
      secondaryText: error.cause,
      primaryButtonName: 'Edit Order',
      onPrimaryButtonTap: () {
        Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(
            builder: (_) => SendByPhoneAmount(currency: currency),
          ),
          (route) => route.isFirst,
        );
      },
      secondaryButtonName: 'Close',
      onSecondaryButtonTap: () => navigateToRouter(read),
    );
  }
}
