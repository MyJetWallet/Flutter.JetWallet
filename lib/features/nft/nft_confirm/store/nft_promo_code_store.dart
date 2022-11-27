import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/nft/nft_confirm/model/nft_promo_code_union.dart';
import 'package:mobx/mobx.dart';

import '../model/nft_promo_code_union.dart';

part 'nft_promo_code_store.g.dart';

class NFTPromoCodeStore = _NFTPromoCodeStoreBase with _$NFTPromoCodeStore;

abstract class _NFTPromoCodeStoreBase with Store {
  Timer _timer = Timer(Duration.zero, () {});

  @observable
  int timer = 0;

  @observable
  String? promoCode;

  @observable
  Decimal? discount;

  @observable
  String? bottomSheetReferralCode;

  @observable
  NftPromoCodeUnion promoStatus = const NftPromoCodeUnion.input();

  @observable
  bool isInputError = false;

  @observable
  bool saved = false;
  @action
  void setSaved(bool value) => saved = value;

  @observable
  TextEditingController promoCodeController = TextEditingController();

  @action
  Future<void> init() async {
    promoCode = null;
    discount = null;
    promoStatus = const NftPromoCodeUnion.input();
    isInputError = false;
    promoCodeController..text = '';

    saved = false;

    final promoCodeStorage = await sLocalStorageService.getValue(nftPromoCode);

    if (promoCodeStorage != null) {
      promoCodeController = TextEditingController()..text = promoCodeStorage;
      _moveCursorAtTheEnd();

      await validatePromoCode(promoCodeStorage, isInit: true);

      saved = true;
    }
  }

  @action
  Future<void> pasteCodePromoLink() async {
    final copiedText = await _copiedText();

    promoCodeController.text = copiedText;

    _moveCursorAtTheEnd();

    if (copiedText.isNotEmpty) {
      await updatePromoCode(copiedText);
    }
  }

  @action
  Future<void> updatePromoCode(String code) async {
    _timer.cancel();

    if (code.isEmpty) {
      //bottomSheetReferralCodeValidation = const Input();
      promoStatus = const NftPromoCodeUnion.input();

      resetBottomSheetPromoCodeValidation();
    }

    timer = 0;

    _timer = Timer.periodic(
      const Duration(milliseconds: 600),
      (tr) {
        if (timer == 1 && code.length > 2) {
          tr.cancel();
          //bottomSheetReferralCodeValidation = const Loading();
          validatePromoCode(code);
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
  Future<void> validatePromoCode(String code, {bool isInit = false}) async {
    promoStatus = const NftPromoCodeUnion.loading();
    discount = null;
    //bottomSheetReferralCodeValidation = const Loading();

    try {
      final request = await getIt
          .get<SNetwork>()
          .simpleNetworking
          .getWalletModule()
          .getNFTMarketIsValidPromo(code);

      request.pick(
        onData: (data) {
          if (data.isValid!) {
            discount = data.discount;

            promoStatus = const NftPromoCodeUnion.valid();
            promoCode = code;

            if (promoStatus is Valid && code.isNotEmpty) {
              promoCodeController.text = code;
            }

            _moveCursorAtTheEnd();
          } else {
            if (isInit) {
              promoCodeController = TextEditingController()..text = '';
              promoStatus = const NftPromoCodeUnion.input();
            } else {
              promoStatus = const NftPromoCodeUnion.invalid();
              isInputError = true;
            }
          }
        },
        onError: (error) {
          promoStatus = const NftPromoCodeUnion.invalid();
          isInputError = true;

          _triggerErrorOfReferralCodeField();
        },
      );
    } catch (error) {
      promoStatus = const NftPromoCodeUnion.invalid();
      isInputError = true;

      _triggerErrorOfReferralCodeField();
    }
  }

  @action
  void _triggerErrorOfReferralCodeField() {
    isInputError = true;
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
  void _moveCursorAtTheEnd() {
    promoCodeController.selection = TextSelection.fromPosition(
      TextPosition(offset: promoCodeController.text.length),
    );
  }

  @action
  Future<void> clearBottomSheetPromoCode() async {
    promoCode = null;
    discount = null;
    promoStatus = const NftPromoCodeUnion.input();
    isInputError = false;
    promoCodeController..text = '';

    bottomSheetReferralCode = null;
    unawaited(updatePromoCode(''));
    resetBottomSheetPromoCodeValidation();

    await sLocalStorageService.setString(nftPromoCode, null);
  }

  @action
  void resetBottomSheetPromoCodeValidation() {
    //bottomSheetReferralCodeValidation = const Input();
    isInputError = false;
    promoCodeController = TextEditingController()..text = promoCode ?? '';
  }

  Future<String> _copiedText() async {
    final data = await Clipboard.getData('text/plain');

    return (data?.text ?? '').replaceAll(' ', '');
  }
}
