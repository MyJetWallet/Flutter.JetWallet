import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/global_send_methods_model.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_request_model.dart';
import 'package:uuid/uuid.dart';

part 'send_card_detail_store.g.dart';

class GlobalSendMethod {
  GlobalSendMethod(
    this.id,
    this.controller,
    this.info,
    this.isError,
    this.value,
  );

  final String id;

  final TextEditingController controller;
  final FieldInfo info;
  bool isError;

  String value;
}

class SendCardDetailStore extends _SendCardDetailStoreBase
    with _$SendCardDetailStore {
  SendCardDetailStore() : super();

  static SendCardDetailStore of(BuildContext context) =>
      Provider.of<SendCardDetailStore>(context, listen: false);
}

abstract class _SendCardDetailStoreBase with Store {
  @observable
  ObservableList<GlobalSendMethod> methodList = ObservableList.of([]);

  @observable
  GlobalSendMethodsModelDescription? methods;

  @observable
  bool isContinueAvailable = false;
  @action
  void checkContinueButton() {
    final isAnyEmpty = methodList
        .where(
          (element) => element.info.fieldId == FieldInfoId.cardNumber
              ? element.value.length != 19
              : element.value.isEmpty,
        )
        .isEmpty;

    final isAnyError = methodList
        .where(
          (element) => element.isError,
        )
        .isEmpty;

    isContinueAvailable = isAnyEmpty && isAnyError;
  }

  String countryCode = '';
  String currency = '';
  GlobalSendMethodsModelMethods? method;

  @action
  void init(GlobalSendMethodsModelMethods m, String code, String cur) {
    sAnalytics.globalSendReceiverDetails(
      destCountry: code,
      paymentMethod: m.name ?? '',
      asset: cur,
      sendMethodType: '1',
    );

    method = m;

    methods = sSignalRModules.globalSendMethods!.descriptions!.firstWhere(
      (element) => element.type == m.type,
    );
    methods!.fields!.sort((a, b) => a.weight!.compareTo(b.weight!));

    countryCode = code;
    currency = cur;

    const uuid = Uuid();
    for (var i = 0; i < methods!.fields!.length; i++) {
      methodList.add(
        GlobalSendMethod(
          uuid.v1(),
          TextEditingController(),
          methods!.fields![i],
          false,
          '',
        ),
      );
    }
  }

  @action
  Future<void> pasteCardNumber(TextEditingController controller) async {
    final copiedText = await _copiedText();
    //updateCardNumber(copiedText);
    controller.text = copiedText;

    _moveCursorAtTheEnd(controller);
  }

  Future<String> _copiedText() async {
    final data = await Clipboard.getData('text/plain');
    final code = data?.text?.trim() ?? '';

    return code.replaceAll(' ', '');
  }

  @action
  void _moveCursorAtTheEnd(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  @action
  void onErase(String methodId) {
    final ind = methodList.indexWhere((element) => element.id == methodId);

    if (ind != -1) {
      methodList[ind].controller.clear();
    }

    checkContinueButton();
  }

  @action
  Future<void> paste(
    String methodId, {
    bool isCard = false,
  }) async {
    final ind = methodList.indexWhere((element) => element.id == methodId);

    if (ind != -1) {
      final copiedText = await _copiedText();

      try {
        if (copiedText.length == 16) {
          final buffer = StringBuffer();

          for (var i = 0; i < copiedText.length; i++) {
            buffer.write(copiedText[i]);
            final nonZeroIndex = i + 1;
            if (nonZeroIndex % 4 == 0 &&
                nonZeroIndex != copiedText.length &&
                nonZeroIndex != (copiedText.length - 1)) {
              buffer.write(' ');
            }
          }

          methodList[ind].controller.text = buffer.toString();
          onChanged(methodId, buffer.toString(), isCard: isCard);
        } else {
          methodList[ind].controller.text = copiedText;
          onChanged(methodId, copiedText, isCard: isCard);
        }
      } catch (e) {
        return;
      }

      _moveCursorAtTheEnd(methodList[ind].controller);
    }

    checkContinueButton();
  }

  @action
  void onChanged(
    String methodId,
    String value, {
    bool isCard = false,
  }) {
    final ind = methodList.indexWhere((element) => element.id == methodId);

    if (ind != -1) {
      methodList[ind].value = value;

      if (isCard) {
        validateCard(ind);
      }
    }

    checkContinueButton();
  }

  @action
  void validateCard(int index) {
    methodList[index].isError = methodList[index].value.length == 19
        ? !CreditCardValidator().validateCCNum(methodList[index].value).isValid
        : methodList[index].value.length > 19;
  }

  void submit() {
    String? cardNumber;
    String? iban;
    String? phoneNumber;
    String? recipientName;
    String? panNumber;
    String? upiAddress;
    String? accountNumber;
    String? beneficiaryName;
    String? bankName;
    String? ifscCode;
    String? bankAccount;
    String? wise;

    for (var i = 0; i < methodList.length; i++) {
      switch (methodList[i].info.fieldId) {
        case FieldInfoId.cardNumber:
          cardNumber = methodList[i].value.replaceAll(' ', '');
          break;
        case FieldInfoId.iban:
          iban = methodList[i].value;
          break;
        case FieldInfoId.phoneNumber:
          phoneNumber = methodList[i].value;
          break;
        case FieldInfoId.recipientName:
          recipientName = methodList[i].value;
          break;
        case FieldInfoId.panNumber:
          panNumber = methodList[i].value;
          break;
        case FieldInfoId.upiAddress:
          upiAddress = methodList[i].value;
          break;
        case FieldInfoId.accountNumber:
          accountNumber = methodList[i].value;
          break;
        case FieldInfoId.beneficiaryName:
          beneficiaryName = methodList[i].value;
          break;
        case FieldInfoId.bankName:
          bankName = methodList[i].value;
          break;
        case FieldInfoId.bankAccount:
          bankAccount = methodList[i].value;
          break;
        case FieldInfoId.ifscCode:
          ifscCode = methodList[i].value;
          break;
        case FieldInfoId.wise:
          wise = methodList[i].value;
          break;
        default:
          break;
      }
    }

    final model = SendToBankRequestModel(
      countryCode: countryCode,
      asset: currency,
      cardNumber: cardNumber,
      iban: iban,
      phoneNumber: phoneNumber,
      recipientName: recipientName,
      panNumber: panNumber,
      upiAddress: upiAddress,
      accountNumber: accountNumber,
      beneficiaryName: beneficiaryName,
      bankName: bankName,
      ifscCode: ifscCode,
      bankAccount: bankAccount,
      wise: wise,
      pin: '',
    );

    sRouter.push(
      SendGloballyAmountRouter(
        data: model,
        method: method!,
      ),
    );
  }
}
