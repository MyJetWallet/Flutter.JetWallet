import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/credentials_service/credentials_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/auth/register/models/referral_code_link_union.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/auth_api/models/validate_referral_code/validate_referral_code_request_model.dart';

part 'referral_code_store.g.dart';

class ReferallCodeStore extends _ReferallCodeStoreBase with _$ReferallCodeStore {
  ReferallCodeStore() : super();

  static _ReferallCodeStoreBase of(BuildContext context) => Provider.of<ReferallCodeStore>(context, listen: false);
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
  Future<void> _validateReferralCode(String code, String? jwCode) async {
    referralCodeValidation = const Loading();
    bottomSheetReferralCodeValidation = const Loading();

    try {
      final model = ValidateReferralCodeRequestModel(
        referralCode: code,
      );

      final request = await getIt.get<SNetwork>().simpleNetworking.getAuthModule().postValidateReferralCode(model);

      request.pick(
        onData: (data) {
          final shortCode = _refCode(jwCode ?? code);

          referralCodeValidation = const Valid();
          bottomSheetReferralCodeValidation = const Valid();
          referralCode = shortCode?.replaceFirst('https://join.simple.app/', '');

          getIt.get<CredentialsService>().setReferralCode(shortCode ?? '');

          if (bottomSheetReferralCodeValidation is Valid && (jwCode != null || code.isNotEmpty)) {
            isInputError = false;
            referralCodeController.text = shortCode!.replaceFirst('https://join.simple.app/', '');
          }

          _moveCursorAtTheEnd(referralCodeController);
        },
        onError: (error) {
          referralCodeValidation = const Invalid();
          bottomSheetReferralCodeValidation = const Invalid();

          _triggerErrorOfReferralCodeField();
        },
      );
    } catch (error) {
      _logger.log(stateFlow, 'validateReferralCode', error);

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
  void clearBottomSheetReferralCode() {
    bottomSheetReferralCode = null;
    updateReferralCode('', null);
    resetBottomSheetReferralCodeValidation();
  }

  @action
  void clearReferralCode() {
    referralCode = null;
    updateReferralCode('', null);
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
