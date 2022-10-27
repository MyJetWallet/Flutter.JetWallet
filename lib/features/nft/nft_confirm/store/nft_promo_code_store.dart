import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

part 'nft_promo_code_store.g.dart';

class NFTPromoCodeStore = _NFTPromoCodeStoreBase with _$NFTPromoCodeStore;

abstract class _NFTPromoCodeStoreBase with Store {
  @observable
  String? referralCode;

  @observable
  String? bottomSheetReferralCode;

  @observable
  bool isInputError = false;

  @observable
  TextEditingController promoCodeController = TextEditingController();

  @action
  Future<void> pasteCodeReferralLink() async {
    final copiedText = await _copiedText();

    promoCodeController.text = copiedText;

    _moveCursorAtTheEnd(promoCodeController);

    if (copiedText.isNotEmpty) {
      final command = _refCode(copiedText);

      //await updateReferralCode(copiedText, command);
    }
  }

  @action
  Future<void> updateReferralCode(String code, String? jwCode) async {}

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
  void _moveCursorAtTheEnd(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  @action
  void clearBottomSheetReferralCode() {
    bottomSheetReferralCode = null;
    updateReferralCode('', null);
    resetBottomSheetReferralCodeValidation();
  }

  @action
  void resetBottomSheetReferralCodeValidation() {
    //bottomSheetReferralCodeValidation = const Input();
    isInputError = false;
    promoCodeController = TextEditingController()..text = referralCode ?? '';
  }

  Future<String> _copiedText() async {
    final data = await Clipboard.getData('text/plain');

    return (data?.text ?? '').replaceAll(' ', '');
  }
}
