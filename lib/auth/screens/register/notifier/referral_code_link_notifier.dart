import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/referral_code_service/model/validate_referral_code_request_model.dart';

import '../../../../app/shared/features/currency_withdraw/notifier/withdrawal_address_notifier/withdrawal_address_notifier.dart';
import '../../../../app/shared/features/kyc/view/components/allow_camera/allow_camera.dart';
import '../../../../shared/logging/levels.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../../shared/services/local_storage_service.dart';
import 'referral_code_link_state.dart';
import 'referral_code_link_union.dart';

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
  Timer _timer = Timer(Duration.zero, () {});

  static final _logger = Logger('ReferralCodeLinkNotifier');

  Future<void> _init() async {
    final storage = read(localStorageServicePod);
    final referralCode = await storage.getValue(referralCodeKey);

    if (referralCode != null) {
      state = state.copyWith(
        referralCode: referralCode,
        referralCodeValidation: const Loading(),
      );

      await _validateReferralCode(referralCode, null);
    }
  }

  Future<void> updateReferralCode(String code, String? jwCode) async {
    _timer.cancel();

    if (code.isEmpty) {
      state = state.copyWith(
        bottomSheetReferralCodeValidation: const Input(),
        referralCodeValidation: const Input(),
      );
    }

    state = state.copyWith(
      bottomSheetReferralCode: code,
      timer: 0,
    );

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state.timer == 1 && code.length > 2) {
          timer.cancel();
          _validateReferralCode(code, jwCode);
        } else {
          if (state.timer == 0) {
            state = state.copyWith(
              timer: state.timer + 1,
            );
          } else {
            _timer.cancel();
          }
        }
      },
    );
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

    if (copiedText.isNotEmpty) {
      final command = _refCode(copiedText);

      await updateReferralCode(copiedText, command);
    }
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
        final command = _refCode(result.code!);

        state.referralCodeController.text = command ?? '';
        _moveCursorAtTheEnd(state.referralCodeController);
        state = state.copyWith(
          bottomSheetReferralCode: state.referralCodeController.text,
        );

        await updateReferralCode(command!, null);
      }
    }
  }

  Future<void> _validateReferralCode(String code, String? jwCode) async {
    state = state.copyWith(
      referralCodeValidation: const Loading(),
      bottomSheetReferralCodeValidation: const Loading(),
    );

    try {
      final model = ValidateReferralCodeRequestModel(
        referralCode: code,
      );

      final service = read(referralCodeServicePod);
      final intl = read(intlPod);

      await service.validateReferralCode(model, intl.localeName);

      if (!mounted) return;

      final shortCode = _refCode(jwCode ?? code);

      state = state.copyWith(
        referralCodeValidation: const Valid(),
        bottomSheetReferralCodeValidation: const Valid(),
        referralCode: shortCode,
      );

      if (state.bottomSheetReferralCodeValidation is Valid &&
          (jwCode != null || code.isNotEmpty)) {
        state.referralCodeController.text = shortCode!;
      }

      _moveCursorAtTheEnd(state.referralCodeController);
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

  String? _refCode(String value) {
    final code = Uri.parse(value);
    final parameters = code.queryParameters;

    if (parameters['jw_code'] != null) {
      return parameters['jw_code'];
    } else if (parameters['code'] != null) {
      return parameters['code'];
    }
    return value;
  }

  void _pushAllowCamera(BuildContext context) {
    final intl = context.read(intlPod);

    AllowCamera.push(
      context: context,
      permissionDescription: intl.referralCodeLink_pushAllowCamera,
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

    controller.resumeCamera();

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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
