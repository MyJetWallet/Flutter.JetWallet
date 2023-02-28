import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/send_by_phone/model/contact_model.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_amount_store.dart';
import 'package:jetwallet/utils/helpers/decompose_phone_number.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/account/phone_number/simple_number.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/tranfer_by_phone/transfer_by_phone_request_model.dart';

import '../../../core/di/di.dart';
import '../../../core/services/local_storage_service.dart';

part 'send_by_phone_preview_store.g.dart';

class SendByPreviewStore extends _SendByPreviewStoreBase
    with _$SendByPreviewStore {
  SendByPreviewStore(
    CurrencyModel currency,
    String amountStoreAmount,
    ContactModel pickedContact,
    SPhoneNumber activeDialCode,
  ) : super(currency, amountStoreAmount, pickedContact, activeDialCode);

  static _SendByPreviewStoreBase of(BuildContext context) =>
      Provider.of<SendByPreviewStore>(context, listen: false);
}

abstract class _SendByPreviewStoreBase with Store {
  _SendByPreviewStoreBase(
    this.currency,
    this.amountStoreAmount,
    this.pickedContact,
    this.activeDialCode,
  ) {
    amount = amountStoreAmount;
    pickedContact = pickedContact;
    activeDialCode = activeDialCode;
  }

  final CurrencyModel currency;

  final String amountStoreAmount;

  static final _logger = Logger('SendByPhonePreviewStore');

  final loader = StackLoaderStore();

  @observable
  ContactModel? pickedContact;

  @observable
  SPhoneNumber? activeDialCode;

  @observable
  String amount = '0';

  @observable
  bool receiverIsRegistered = false;

  /// Needed to track status of the operation on ConfirmScreen
  @observable
  String operationId = '';

  @observable
  bool loading = false;

  @action
  Future<void> send() async {
    _logger.log(notifier, 'send');

    loading = true;

    try {
      final number = await decomposePhoneNumber(
        pickedContact!.phoneNumber,
        isoCodeNumber: activeDialCode?.isoCode ?? '',
      );

      final model = TransferByPhoneRequestModel(
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        assetSymbol: currency.symbol,
        amount: Decimal.parse(amount),
        toPhoneBody: number.body.replaceAll(
          activeDialCode?.countryCode ?? '',
          '',
        ),
        toPhoneCode: activeDialCode?.countryCode ?? '',
        toPhoneIso: number.isoCode,
        locale: intl.localeName,
      );

      final response =
          await sNetwork.getWalletModule().postTransferByPhone(model);

      response.pick(
        onData: (data) {
          _updateOperationId(data.operationId);
          _updateReceiverIsRegistered(data.receiverIsRegistered);

          _showSendByPhoneConfirm();
        },
        onError: (error) {
          _logger.log(stateFlow, 'send', error.cause);

          _showFailureScreen(error);
        },
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'send', error.cause);

      _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'send', error);

      _showNoResponseScreen();
    }

    loading = false;
  }

  @action
  void _updateOperationId(String value) {
    operationId = value;
  }

  @action
  void _updateReceiverIsRegistered(bool value) {
    receiverIsRegistered = value;
  }

  @action
  void _showSendByPhoneConfirm() {
    final storageService = getIt.get<LocalStorageService>();
    storageService.setString(lastAssetSend, currency.symbol);

    sRouter.push(
      SendByPhoneConfirmRouter(
        currency: currency,
        operationId: operationId,
        receiverIsRegistered: receiverIsRegistered,
        amountStoreAmount: amount,
        pickedContact: pickedContact!,
        activeDialCode: activeDialCode!,
      ),
    );
  }

  @action
  void _showNoResponseScreen() {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.showNoResponseScreen_text,
        secondaryText: intl.showNoResponseScreen_text2,
        primaryButtonName: intl.serverCode0_ok,
        onPrimaryButtonTap: () {
          sRouter.navigate(
            const HomeRouter(
              children: [
                PortfolioRouter(),
              ],
            ),
          );
        },
      ),
    );
  }

  @action
  void _showFailureScreen(ServerRejectException error) {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.sendByPhonePreview_failure,
        secondaryText: error.cause,
        primaryButtonName: intl.sendByPhonePreview_editOrder,
        onPrimaryButtonTap: () {
          sRouter.replace(
            SendByPhoneAmountRouter(
              currency: currency,
              pickedContact: pickedContact,
            ),
          );
        },
        secondaryButtonName: intl.sendByPhonePreview_close,
        onSecondaryButtonTap: () => navigateToRouter(),
      ),
    );
  }
}
