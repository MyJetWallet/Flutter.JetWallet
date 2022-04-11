import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../app/shared/features/kyc/view/components/allow_camera/allow_camera.dart';
import '../../../../service/services/referral_code_service/model/validate_referral_code_request_model.dart';
import '../../../../shared/logging/levels.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../../shared/services/local_storage_service.dart';
import 'referral_code_link_state.dart';
import 'referral_code_link_union.dart';

enum CameraStatus { permanentlyDenied, denied, granted }

/// Responsible for input and validation of withdrawal address and tag
class ReferralCodeLinkNotifier extends StateNotifier<ReferralCodeLinkState> {
  ReferralCodeLinkNotifier({
    required this.read,
  }) : super(
          ReferralCodeLinkState(
            referralCodeController: TextEditingController(),
            referralCodeErrorNotifier: StandardFieldErrorNotifier(),
            qrKey: GlobalKey(),
          ),
        ) {
    _init();
  }

  final Reader read;

  static final _logger = Logger('ReferralCodeLinkNotifier');

  Future<void> _init() async {
    final storage = read(localStorageServicePod);
    await storage.clearStorage();
    final referralCode = await storage.getString(referralCodeKey);

    if (referralCode != null) {
      state = state.copyWith(
        referralCode: referralCode,
        referralCodeValidation: const Loading(),
      );

      await validateReferralCode(referralCode);
    }
  }

  Future<void> validateReferralCode(String code) async {
    state = state.copyWith(
      referralCodeValidation: const Loading(),
      bottomSheetReferralCodeValidation: const Loading(),
    );
    try {
      final model = ValidateReferralCodeRequestModel(
        referralCode: code,
      );

      final service = read(referralCodeServicePod);

      await service.validateReferralCode(model);

      if (!mounted) return;

      state = state.copyWith(
        referralCodeValidation: const Valid(),
        bottomSheetReferralCodeValidation: const Valid(),
        referralCode: code,
      );
    } catch (error) {
      if (!mounted) return;

      _logger.log(stateFlow, 'validateReferralCode', error);

      state = state.copyWith(
        referralCodeValidation: const Invalid(),
        bottomSheetReferralCodeValidation: const Invalid(),
      );

      _triggerErrorOfReferralCodeField();
    }
  }

  void updateReferralCode(String code) {
    state = state.copyWith(bottomSheetReferralCode: code);
  }

  void resetBottomSheetReferralCodeValidation() {
    state = state.copyWith(
      bottomSheetReferralCodeValidation: const Input(),
      bottomSheetReferralCode: null,
      referralCodeController: TextEditingController(),
      referralCodeErrorNotifier: StandardFieldErrorNotifier(),
    );
  }

  Future<void> pasteCodeReferralLink() async {
    _logger.log(notifier, 'pasteCodeReferralLink');

    final copiedText = await _copiedText();
    state.referralCodeController.text = copiedText;
    _moveCursorAtTheEnd(state.referralCodeController);
    state = state.copyWith(bottomSheetReferralCode: copiedText);
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
        final code = Uri.parse(result.code!);
        final parameters = code.queryParameters;
        final command = parameters['code'];

        state.referralCodeController.text = command ?? '';
        _moveCursorAtTheEnd(state.referralCodeController);
        state = state.copyWith(
          bottomSheetReferralCode: state.referralCodeController.text,
        );
      }
    }
  }

  void _pushAllowCamera(BuildContext context) {
    AllowCamera.push(
      context: context,
      permissionDescription:
          'To scan the QR Code, give Simple permission to access your camera',
      then: () {
        _pushQrView(context: context, fromSettings: true);
      },
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

  Future<CameraStatus> _checkCameraStatusAction() async {
    final storage = read(localStorageServicePod);
    final storageStatus = await storage.getString(cameraStatusKey);
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

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    updateQrController(controller);

    controller.scannedDataStream.listen(
      (event) {
        controller.dispose();
        Navigator.pop(context, event);
      },
    );
  }

  void updateQrController(QRViewController controller) {
    _logger.log(notifier, 'updateQrController');

    state = state.copyWith(qrController: controller);
  }

  void clearBottomSheetReferralCode() {
    state = state.copyWith(bottomSheetReferralCode: null);
  }

  Future<String> _copiedText() async {
    final data = await Clipboard.getData('text/plain');
    return (data?.text ?? '').replaceAll(' ', '');
  }

  void _triggerErrorOfReferralCodeField() {
    state.referralCodeErrorNotifier!.enableError();
  }

  void _moveCursorAtTheEnd(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }
}
