import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/credentials_service/credentials_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/auth/register/models/referral_code_link_union.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:jetwallet/utils/enum.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/auth_api/models/validate_referral_code/validate_referral_code_request_model.dart';

part 'referral_code_store.g.dart';

class ReferallCodeStore extends _ReferallCodeStoreBase
    with _$ReferallCodeStore {
  ReferallCodeStore() : super();

  static _ReferallCodeStoreBase of(BuildContext context) =>
      Provider.of<ReferallCodeStore>(context, listen: false);
}

abstract class _ReferallCodeStoreBase with Store {
  static final _logger = Logger('ReferralCodeLinkNotifier');

  Timer _timer = Timer(Duration.zero, () {});

  @observable
  String? referralCode;

  @observable
  String? bottomSheetReferralCode;

  @observable
  ReferralCodeLinkUnion referralCodeValidation = const Input();

  @observable
  ReferralCodeLinkUnion bottomSheetReferralCodeValidation = const Input();

  @observable
  int timer = 0;

  @observable
  TextEditingController referralCodeController = TextEditingController();

  @observable
  bool isInputError = false;

  @observable
  Key qrKey = GlobalKey();

  @computed
  bool get enableContinueButton {
    return bottomSheetReferralCodeValidation is Valid;
  }

  @action
  Future<void> init() async {
    final storage = getIt.get<LocalStorageService>();
    final refCode = await storage.getValue(referralCodeKey);

    if (refCode != null) {
      referralCode = refCode;
      referralCodeValidation = const Loading();
      referralCodeController.text = refCode;

      await _validateReferralCode(refCode, null);
    }
  }

  @action
  Future<void> updateReferralCode(String code, String? jwCode) async {
    _timer.cancel();

    if (code.isEmpty) {
      bottomSheetReferralCodeValidation = const Input();
      referralCodeValidation = const Input();

      resetBottomSheetReferralCodeValidation();
    }

    bottomSheetReferralCode = code;
    timer = 0;

    _timer = Timer.periodic(
      const Duration(milliseconds: 600),
      (tr) {
        if (timer == 1 && code.length > 2) {
          tr.cancel();
          bottomSheetReferralCodeValidation = const Loading();
          _validateReferralCode(code, jwCode);
        } else {
          if (timer == 0) {
            timer = timer + 1;
          } else {
            _timer.cancel();
          }
        }
      },
    );
  }

  @action
  void resetBottomSheetReferralCodeValidation({bool isOpening = false}) {
    if (!isOpening || isInputError) {
      referralCodeController.text = '';
    }
    bottomSheetReferralCodeValidation = const Input();
    isInputError = false;
  }

  @action
  Future<void> pasteCodeReferralLink() async {
    _logger.log(notifier, 'pasteCodeReferralLink');

    final copiedText = await _copiedText();

    referralCodeController.text = copiedText;

    _moveCursorAtTheEnd(referralCodeController);

    bottomSheetReferralCode = copiedText;

    if (copiedText.isNotEmpty) {
      final command = _refCode(copiedText);

      await updateReferralCode(copiedText, command);
    }
  }

  @action
  Future<void> scanAddressQr(BuildContext context) async {
    _logger.log(notifier, 'scanAddressQr');

    final status = await _checkCameraStatusAction();

    if (status == CameraStatus.permanentlyDenied) {
      _pushAllowCamera(context);
    } else if (status == CameraStatus.granted) {
      final result = await _pushQrView(
        context: context,
      );

      if (result is Barcode) {
        final command = _refCode(result.rawValue ?? '');

        referralCodeController.text = command ?? '';

        _moveCursorAtTheEnd(referralCodeController);

        bottomSheetReferralCode = referralCodeController.text;

        await updateReferralCode(command!, null);
      }
    }
  }

  @action
  Future<void> _validateReferralCode(String code, String? jwCode) async {
    referralCodeValidation = const Loading();
    bottomSheetReferralCodeValidation = const Loading();

    try {
      final model = ValidateReferralCodeRequestModel(
        referralCode: code,
      );

      final request = await getIt
          .get<SNetwork>()
          .simpleNetworking
          .getAuthModule()
          .postValidateReferralCode(model);

      request.pick(
        onData: (data) {
          final shortCode = _refCode(jwCode ?? code);

          referralCodeValidation = const Valid();
          bottomSheetReferralCodeValidation = const Valid();
          referralCode =
              shortCode?.replaceFirst('https://join.simple.app/', '');

          getIt.get<CredentialsService>().setReferralCode(shortCode ?? '');

          if (bottomSheetReferralCodeValidation is Valid &&
              (jwCode != null || code.isNotEmpty)) {
            isInputError = false;
            referralCodeController.text =
                shortCode!.replaceFirst('https://join.simple.app/', '');
          }

          _moveCursorAtTheEnd(referralCodeController);
        },
        onError: (error) {
          referralCodeValidation = const Invalid();
          bottomSheetReferralCodeValidation = const Invalid();

          sAnalytics.signInFlowPersonaReferralLinkError(errorCode: error.cause);

          _triggerErrorOfReferralCodeField();
        },
      );
    } catch (error) {
      _logger.log(stateFlow, 'validateReferralCode', error);

      sAnalytics.signInFlowPersonaReferralLinkError(
          errorCode: error.toString());

      referralCodeValidation = const Invalid();
      bottomSheetReferralCodeValidation = const Invalid();

      _triggerErrorOfReferralCodeField();
    }
  }

  @action
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

  @action
  void _pushAllowCamera(BuildContext context) {
    getIt.get<AppRouter>().push(
          AllowCameraRoute(
            permissionDescription: intl.referralCodeLink_pushAllowCamera,
            then: () {
              _pushQrView(context: context, fromSettings: true);
            },
          ),
        );
  }

  @action
  Future _pushQrView({
    bool fromSettings = false,
    required BuildContext context,
  }) {
    final colors = sKit.colors;
    isRedirectedFromQr = false;

    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: 200,
      height: 200,
    );

    final qrPageRoute = MaterialPageRoute(
      builder: (context) {
        return Stack(
          children: [
            MobileScanner(
              key: qrKey,
              scanWindow: scanWindow,
              onDetect: (c) => _onQRScanned(c, context),
            ),
            CustomPaint(
              painter: ScannerOverlay(scanWindow),
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

    return fromSettings
        ? Navigator.pushReplacement(context, qrPageRoute)
        : Navigator.push(context, qrPageRoute);
  }

  var isRedirectedFromQr = false;
  @action
  void _onQRScanned(BarcodeCapture capture, BuildContext context) {
    if (isRedirectedFromQr) return;

    isRedirectedFromQr = true;
    Navigator.pop(context, capture.barcodes.first);
  }

  @action
  Future<CameraStatus> _checkCameraStatusAction() async {
    final storage = getIt.get<LocalStorageService>();
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

    await storage.setString(
      cameraStatusKey,
      'triggered',
    );

    return CameraStatus.denied;
  }

  @action
  void clearBottomSheetReferralCode() {
    bottomSheetReferralCode = null;
    updateReferralCode('', null);
    resetBottomSheetReferralCodeValidation();
  }

  Future<String> _copiedText() async {
    final data = await Clipboard.getData('text/plain');

    return (data?.text ?? '').replaceAll(' ', '');
  }

  @action
  void _triggerErrorOfReferralCodeField() {
    isInputError = true;
  }

  @action
  void _moveCursorAtTheEnd(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  @action
  void dispose() {
    _timer.cancel();
  }
}
