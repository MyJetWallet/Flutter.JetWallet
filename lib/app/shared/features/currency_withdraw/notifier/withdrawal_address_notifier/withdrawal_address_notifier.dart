import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../../../../service/services/blockchain/model/validate_address/validate_address_request_model.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../models/currency_model.dart';
import 'address_validation_union.dart';
import 'withdrawal_address_state.dart';

/// Responsible for input and validation of withdrawal address and tag
class WithdrawalAddressNotifier extends StateNotifier<WithdrawalAddressState> {
  WithdrawalAddressNotifier(
    this.read,
    this.currency,
  ) : super(
          WithdrawalAddressState(
            addressController: TextEditingController(),
            tagController: TextEditingController(),
            addressFocus: FocusNode(),
            tagFocus: FocusNode(),
            qrKey: GlobalKey(),
          ),
        ) {
    state.addressFocus.addListener(_rebuild);
    state.tagFocus.addListener(_rebuild);
  }

  final Reader read;
  final CurrencyModel currency;

  static final _logger = Logger('WithdrawalAddressNotifier');

  void updateQrController(QRViewController controller) {
    _logger.log(notifier, 'updateQrController');

    state = state.copyWith(qrController: controller);
  }

  void updateAddress(String address) {
    _logger.log(notifier, 'updateAddress');

    state = state.copyWith(address: address);
    _validateAddress();
  }

  void updateTag(String tag) {
    _logger.log(notifier, 'updateTag');

    state = state.copyWith(tag: tag);
    _validateAddress();
  }

  void eraseAddress() {
    _logger.log(notifier, 'eraseAddress');

    state.addressController.text = '';
    updateAddress('');
    state.addressFocus.unfocus();
  }

  void eraseTag() {
    _logger.log(notifier, 'eraseTag');

    state.tagController.text = '';
    updateTag('');
    state.tagFocus.unfocus();
  }

  Future<void> pasteAddress() async {
    _logger.log(notifier, 'pasteAddress');

    final copiedText = await _copiedText();
    state.addressController.text = copiedText;
    _moveCursorAtTheEnd(state.addressController);
    updateAddress(copiedText);
  }

  Future<void> pasteTag() async {
    _logger.log(notifier, 'pasteTag');

    final copiedText = await _copiedText();
    state.tagController.text = copiedText;
    _moveCursorAtTheEnd(state.tagController);
    updateTag(copiedText);
  }

  Future<void> scanAddressQr(BuildContext context) async {
    _logger.log(notifier, 'scanAddressQr');

    final result = await _pushQrView(context);

    if (result is Barcode) {
      state.addressController.text = result.code;
      _moveCursorAtTheEnd(state.addressController);
      updateAddress(result.code);
    }
  }

  Future<void> scanTagQr(BuildContext context) async {
    _logger.log(notifier, 'scanTagQr');

    final result = await _pushQrView(context);

    if (result is Barcode) {
      state.tagController.text = result.code;
      _moveCursorAtTheEnd(state.tagController);
      updateTag(result.code);
    }
  }

  Future<String> _copiedText() async {
    final data = await Clipboard.getData('text/plain');
    return (data?.text ?? '').replaceAll(' ', '');
  }

  void _moveCursorAtTheEnd(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  Future _pushQrView(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return QRView(
            key: state.qrKey,
            onQRViewCreated: (c) => _onQRViewCreated(c, context),
            overlay: QrScannerOverlayShape(),
          );
        },
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    updateQrController(controller);

    controller.scannedDataStream.listen(
      (event) {
        controller.dispose();
        Navigator.pop(context, event);
      },
    );
  }

  Future<void> _validateAddress() async {
    state = state.copyWith(validation: const Loading());

    try {
      final model = ValidateAddressRequestModel(
        assetSymbol: currency.symbol,
        toAddress: state.address,
        toTag: state.tag,
      );

      final service = read(blockchainServicePod);

      final response = await service.validateAddress(model);

      if (!mounted) return;
      state = state.copyWith(
        validation: response.isValid ? const Valid() : const Invalid(),
      );
    } catch (error) {
      if (!mounted) return;
      _logger.log(stateFlow, '_validateAddress', error);
      state = state.copyWith(validation: const Invalid());
    }
  }

  void _rebuild() => state = state;

  @override
  void dispose() {
    state.addressFocus.removeListener(_rebuild);
    state.tagFocus.removeListener(_rebuild);
    state.addressFocus.dispose();
    state.tagFocus.dispose();
    state.addressController.dispose();
    state.tagController.dispose();
    state.qrController?.dispose();
    super.dispose();
  }
}
