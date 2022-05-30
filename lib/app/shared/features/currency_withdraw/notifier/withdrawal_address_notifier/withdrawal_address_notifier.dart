import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/blockchain/model/validate_address/validate_address_request_model.dart';
import 'package:simple_networking/services/signal_r/model/blockchains_model.dart';

import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../../shared/services/local_storage_service.dart';
import '../../../../models/currency_model.dart';
import '../../../kyc/view/components/allow_camera/allow_camera.dart';
import '../../model/withdrawal_model.dart';
import '../../view/screens/withdrawal_amount.dart';
import 'address_validation_union.dart';
import 'withdrawal_address_state.dart';

enum CameraStatus { permanentlyDenied, denied, granted }

/// Responsible for input and validation of withdrawal address and tag
class WithdrawalAddressNotifier extends StateNotifier<WithdrawalAddressState> {
  WithdrawalAddressNotifier(
    this.read,
    this.withdrawal,
  ) : super(
          WithdrawalAddressState(
            addressErrorNotifier: StandardFieldErrorNotifier(),
            tagErrorNotifier: StandardFieldErrorNotifier(),
            networkController: TextEditingController(),
            addressController: TextEditingController(),
            tagController: TextEditingController(),
            addressFocus: FocusNode(),
            tagFocus: FocusNode(),
            qrKey: GlobalKey(),
          ),
        ) {
    currency = withdrawal.currency;
    if (currency.isSingleNetwork) {
      updateNetwork(currency.withdrawalBlockchains[0]);
    }
    state = state.copyWith(currency: currency);
  }

  final Reader read;
  final WithdrawalModel withdrawal;

  late CurrencyModel currency;

  static final _logger = Logger('WithdrawalAddressNotifier');

  void updateQrController(QRViewController controller) {
    _logger.log(notifier, 'updateQrController');

    controller.resumeCamera();

    state = state.copyWith(qrController: controller);
  }

  void updateNetwork(BlockchainModel network) {
    _logger.log(notifier, 'updateNetwork');

    state.networkController.text = network.description;
    state = state.copyWith(network: network);
  }

  void updateAddress(String address) {
    if (address != state.address) {
      _logger.log(notifier, 'updateAddress');

      _updateAddressValidation(const Hide());
      state = state.copyWith(address: address);
    }
  }

  void updateTag(String tag) {
    if (tag != state.tag) {
      _logger.log(notifier, 'updateTag');

      _updateTagValidation(const Hide());
      state = state.copyWith(tag: tag);
    }
  }

  void eraseAddress() {
    _logger.log(notifier, 'eraseAddress');

    state.addressController.text = '';
    updateAddress('');
    state.addressFocus.unfocus();
    _updateAddressValidation(const Hide());
  }

  void eraseTag() {
    _logger.log(notifier, 'eraseTag');

    state.tagController.text = '';
    updateTag('');
    state.tagFocus.unfocus();
    _updateTagValidation(const Hide());
  }

  Future<void> pasteAddress() async {
    _logger.log(notifier, 'pasteAddress');

    final copiedText = await _copiedText();
    state.addressController.text = copiedText;
    _moveCursorAtTheEnd(state.addressController);
    state.addressFocus.requestFocus();
    updateAddress(copiedText);
    await _validateAddressOrTag(
      _updateAddressValidation,
      _triggerErrorOfAddressField,
    );
  }

  Future<void> pasteTag() async {
    _logger.log(notifier, 'pasteTag');

    final copiedText = await _copiedText();
    state.tagController.text = copiedText;
    _moveCursorAtTheEnd(state.tagController);
    state.tagFocus.requestFocus();
    updateTag(copiedText);
    await _validateAddressOrTag(
      _updateTagValidation,
      _triggerErrorOfTagField,
    );
  }

  Future<void> scanAddressQr(BuildContext context) async {
    _logger.log(notifier, 'scanAddressQr');

    final status = await _checkCameraStatusAction();

    if (status == CameraStatus.permanentlyDenied) {
      if (!mounted) return;
      _pushAllowCamera(context);
    } else if (status == CameraStatus.granted) {
      final result = await _pushQrView(
        context: context,
      );

      if (result is Barcode) {
        state.addressController.text = result.code ?? '';
        _moveCursorAtTheEnd(state.addressController);
        state.addressFocus.requestFocus();
        updateAddress(result.code ?? '');
        await _validateAddressOrTag(
          _updateAddressValidation,
          _triggerErrorOfAddressField,
        );
      }
    }
  }

  Future<void> scanTagQr(BuildContext context) async {
    _logger.log(notifier, 'scanTagQr');

    final status = await _checkCameraStatusAction();

    if (status == CameraStatus.permanentlyDenied) {
      if (!mounted) return;
      _pushAllowCamera(context);
    } else if (status == CameraStatus.granted) {
      final result = await _pushQrView(
        context: context,
      );

      if (result is Barcode) {
        state.tagController.text = result.code ?? '';
        _moveCursorAtTheEnd(state.tagController);
        state.tagFocus.requestFocus();
        updateTag(result.code ?? '');
        await _validateAddressOrTag(
          _updateTagValidation,
          _triggerErrorOfTagField,
        );
      }
    }
  }

  Future<CameraStatus> _checkCameraStatusAction() async {
    final storage = read(localStorageServicePod);
    final storageStatus = await storage.getValue(cameraStatusKey);
    final permissionStatus = await Permission.camera.request();

    if (permissionStatus == PermissionStatus.denied ||
        permissionStatus == PermissionStatus.permanentlyDenied) {
      if (storageStatus != null) {
        return CameraStatus.permanentlyDenied;
      }
    } else if (permissionStatus == PermissionStatus.granted) {
      return CameraStatus.granted;
    }

    await read(localStorageServicePod).setString(
      cameraStatusKey,
      'triggered',
    );

    return CameraStatus.denied;
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

  Future _pushQrView({
    bool fromSettings = false,
    required BuildContext context,
  }) {
    final colors = read(sColorPod);
    final qrPageRoute = MaterialPageRoute(
      builder: (context) {
        return Stack(
          children: [
            QRView(
              key: state.qrKey,
              onQRViewCreated: (c) => _onQRViewCreated(c, context),
              overlay: QrScannerOverlayShape(),
            ),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 28.0,
                    top: 68.0,
                  ),
                  width: 24,
                  height: 24,
                  child: SCloseIcon(
                    color: colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (fromSettings) {
      return Navigator.pushReplacement(context, qrPageRoute);
    } else {
      return Navigator.push(context, qrPageRoute);
    }
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

  Future<void> _validateAddressOrTag(
    void Function(AddressValidationUnion) updateValidation,
    void Function() triggerErrorOfField,
  ) async {
    updateValidation(const Loading());

    try {
      final model = ValidateAddressRequestModel(
        assetSymbol: currency.symbol,
        toAddress: state.address,
        toTag: state.tag,
        assetNetwork: state.network.id,
      );

      final service = read(blockchainServicePod);
      final intl = read(intlPod);
      final response = await service.validateAddress(model, intl.localeName);

      if (!mounted) return;

      _updateAddressIsInternal(response.isInternal);

      if (response.isValid) {
        updateValidation(const Valid());
      } else {
        updateValidation(const Invalid());
        triggerErrorOfField();
      }
    } catch (error) {
      if (!mounted) return;
      _logger.log(stateFlow, '_validateAddressOrTag', error);
      updateValidation(const Invalid());
      triggerErrorOfField();
    }
  }

  Future<void> validateOnContinue(BuildContext context) async {
    _logger.log(notifier, 'validateAddressAndTag');

    if (state.credentialsValid) {
      _pushWithdrawalAmount(context);
      return;
    }

    _updateValidationOfBothFields(const Loading());

    try {
      final model = ValidateAddressRequestModel(
        assetSymbol: currency.symbol,
        toAddress: state.address,
        toTag: state.tag,
        assetNetwork: state.network.id,
      );

      final service = read(blockchainServicePod);
      final intl = read(intlPod);

      final response = await service.validateAddress(model, intl.localeName);

      if (!mounted) return;

      _updateAddressIsInternal(response.isInternal);

      if (response.isValid) {
        _updateValidationOfBothFields(const Valid());
      } else {
        _updateValidationOfBothFields(const Invalid());
        _triggerErrorOfBothFields();
      }

      if (state.credentialsValid) {
        _pushWithdrawalAmount(context);
      }
    } catch (error) {
      if (!mounted) return;
      _logger.log(stateFlow, 'validateAddressAndTag', error);
      _updateValidationOfBothFields(const Invalid());
      _triggerErrorOfBothFields();
    }
  }

  void _updateValidationOfBothFields(AddressValidationUnion value) {
    _updateAddressValidation(value);
    if (currency.hasTag) {
      _updateTagValidation(value);
    }
  }

  void _triggerErrorOfBothFields() {
    _triggerErrorOfAddressField();
    if (currency.hasTag) {
      _triggerErrorOfTagField();
    }
  }

  void _triggerErrorOfAddressField() {
    state.addressErrorNotifier!.enableError();
  }

  void _triggerErrorOfTagField() {
    state.tagErrorNotifier!.enableError();
  }

  void _updateAddressValidation(AddressValidationUnion value) {
    state = state.copyWith(addressValidation: value);
  }

  void _updateTagValidation(AddressValidationUnion value) {
    state = state.copyWith(tagValidation: value);
  }

  void _updateAddressIsInternal(bool value) {
    state = state.copyWith(addressIsInternal: value);
  }

  void _pushWithdrawalAmount(BuildContext context) {
    navigatorPush(context, WithdrawalAmount(withdrawal: withdrawal));
  }

  void _pushAllowCamera(BuildContext context) {
    final intl = read(intlPod);

    AllowCamera.push(
      context: context,
      permissionDescription: intl.withdrawalAddress_pushAllowCamera,
      then: () {
        _pushQrView(context: context, fromSettings: true);
      },
    );
  }

  String get validationResult {
    final intl = read(intlPod);

    if (state.addressValidation is Loading || state.tagValidation is Loading) {
      return '${intl.withdrawalAddress_checking}...';
    } else if (state.addressValidation is Invalid) {
      return '${intl.withdrawalAddress_invalid} ${currency.symbol}'
          ' ${intl.withdrawalAddress_address}';
    } else if (state.tagValidation is Invalid) {
      return '${intl.withdrawalAddress_invalid} ${currency.symbol}'
          ' ${intl.tag}';
    } else if (state.addressValidation is Invalid &&
        state.tagValidation is Invalid) {
      return '${intl.withdrawalAddress_invalid} ${currency.symbol}'
          ' ${intl.withdrawalAddress_address} & ${intl.tag}';
    } else if (state.addressValidation is Valid &&
        state.tagValidation is Valid) {
      return '${intl.valid} ${currency.symbol}'
          ' ${intl.withdrawalAddress_address} & ${intl.tag}';
    } else if (state.addressValidation is Valid) {
      return '${intl.valid} ${currency.symbol}'
          ' ${intl.withdrawalAddress_address}';
    } else if (state.tagValidation is Valid) {
      return '${intl.valid} ${currency.symbol} ${intl.tag}';
    } else {
      return intl.withdrawalAddress_error;
    }
  }

  String get withdrawHint {
    final intl = read(intlPod);

    if (state.isReadyToContinue) {
      return '${intl.withdrawHint_text1}.';
    } else {
      return '${intl.withdrawHint_text2}.';
    }
  }

  @override
  void dispose() {
    state.addressFocus.dispose();
    state.tagFocus.dispose();
    state.addressController.dispose();
    state.tagController.dispose();
    state.qrController?.dispose();
    super.dispose();
  }
}
