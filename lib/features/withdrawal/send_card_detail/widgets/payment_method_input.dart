import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/features/add_circle_card/helper/masked_text_input_formatter.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/store/send_card_detail_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/global_send_methods_model.dart';

// ignore: avoid_classes_with_only_static_members
class PaymentMethodInput {
  static Widget cardNumber(GlobalSendMethod method) =>
      PaymentMethodCardNumber(method: method);
  static Widget iban(GlobalSendMethod method) =>
      PaymentMethodRecipientName(method: method);
  static Widget phoneNumber(GlobalSendMethod method) =>
      PaymentMethodNumbers(method: method);
  static Widget recipientName(GlobalSendMethod method) =>
      PaymentMethodRecipientName(method: method);
  static Widget panNumber(GlobalSendMethod method) =>
      PaymentMethodRecipientName(method: method);
  static Widget upiAddress(GlobalSendMethod method) =>
      PaymentMethodRecipientName(method: method);
  static Widget accountNumber(GlobalSendMethod method) =>
      PaymentMethodRecipientName(method: method);
  static Widget beneficiaryName(GlobalSendMethod method) =>
      PaymentMethodRecipientName(method: method);
  static Widget bankName(GlobalSendMethod method) =>
      PaymentMethodRecipientName(method: method);
  static Widget ifscCode(GlobalSendMethod method) =>
      PaymentMethodRecipientName(method: method);
  static Widget bankAccount(GlobalSendMethod method) =>
      PaymentMethodRecipientName(method: method);

  static Widget getInput(GlobalSendMethod method) {
    switch (method.info.fieldId) {
      case FieldInfoId.cardNumber:
        return cardNumber(method);
      case FieldInfoId.iban:
        return iban(method);
      case FieldInfoId.phoneNumber:
        return phoneNumber(method);
      case FieldInfoId.recipientName:
        return recipientName(method);
      case FieldInfoId.panNumber:
        return panNumber(method);
      case FieldInfoId.upiAddress:
        return upiAddress(method);
      case FieldInfoId.accountNumber:
        return accountNumber(method);
      case FieldInfoId.beneficiaryName:
        return beneficiaryName(method);
      case FieldInfoId.bankName:
        return bankName(method);
      case FieldInfoId.bankAccount:
        return bankAccount(method);
      case FieldInfoId.ifscCode:
        return ifscCode(method);
      default:
        return const SizedBox.shrink();
    }
  }
}

class PaymentMethodRecipientName extends StatelessWidget {
  const PaymentMethodRecipientName({super.key, required this.method});

  final GlobalSendMethod method;

  @override
  Widget build(BuildContext context) {
    return _Input(
      controller: method.controller,
      labalText: method.info.fieldName!,
      isError: method.isError,
      onErase: () {
        SendCardDetailStore.of(context).onErase(method.id);
      },
      paste: () {
        SendCardDetailStore.of(context).paste(method.id);
      },
      onChanged: (val) {
        SendCardDetailStore.of(context).onChanged(method.id, val);
      },
      inputType: TextInputType.name,
    );
  }
}

class PaymentMethodNumbers extends StatelessWidget {
  const PaymentMethodNumbers({super.key, required this.method});

  final GlobalSendMethod method;

  @override
  Widget build(BuildContext context) {
    return _Input(
      controller: method.controller,
      labalText: method.info.fieldName!,
      isError: method.isError,
      onErase: () {
        SendCardDetailStore.of(context).onErase(method.id);
      },
      paste: () {
        SendCardDetailStore.of(context).paste(method.id);
      },
      onChanged: (val) {
        SendCardDetailStore.of(context).onChanged(method.id, val);
      },
      inputType: TextInputType.number,
    );
  }
}

class PaymentMethodCardNumber extends StatefulWidget {
  const PaymentMethodCardNumber({super.key, required this.method});

  final GlobalSendMethod method;

  @override
  State<PaymentMethodCardNumber> createState() =>
      _PaymentMethodCardNumberState();
}

class _PaymentMethodCardNumberState extends State<PaymentMethodCardNumber> {
  @override
  Widget build(BuildContext context) {
    return _Input(
      inputFormatters: [
        MaskedTextInputFormatter(
          mask: 'xxxx\u{2005}xxxx\u{2005}xxxx\u{2005}xxxx',
          separator: '\u{2005}',
        ),
        FilteringTextInputFormatter.allow(
          RegExp(r'[0-9\u2005]'),
        ),
      ],
      controller: widget.method.controller,
      labalText: widget.method.info.fieldName!,
      isError: widget.method.isError,
      onErase: () {
        SendCardDetailStore.of(context).onErase(widget.method.id);
      },
      paste: () {
        SendCardDetailStore.of(context).paste(widget.method.id);
      },
      onChanged: (val) {
        SendCardDetailStore.of(context).onChanged(
          widget.method.id,
          val,
          isCard: true,
        );
        setState(() {});
      },
      inputType: TextInputType.number,
    );
  }
}

class _Input extends StatefulWidget {
  const _Input({
    super.key,
    this.inputFormatters,
    required this.controller,
    required this.labalText,
    required this.isError,
    required this.onErase,
    required this.paste,
    required this.onChanged,
    required this.inputType,
  });

  final List<TextInputFormatter>? inputFormatters;

  final TextEditingController controller;
  final String labalText;
  final bool isError;
  final Function() onErase;
  final Function() paste;
  final Function(String) onChanged;
  final TextInputType inputType;

  @override
  State<_Input> createState() => _InputState();
}

class _InputState extends State<_Input> {
  @override
  Widget build(BuildContext context) {
    return SFieldDividerFrame(
      child: SStandardField(
        controller: widget.controller,
        labelText: widget.labalText,
        keyboardType: widget.inputType,
        isError: widget.isError,
        disableErrorOnChanged: false,
        hideSpace: true,
        onErase: () {
          widget.onErase();
        },
        suffixIcons: [
          SIconButton(
            onTap: () {
              widget.paste();
            },
            defaultIcon: const SPasteIcon(),
            pressedIcon: const SPastePressedIcon(),
          ),
        ],
        inputFormatters: widget.inputFormatters,
        onChanged: (str) {
          widget.onChanged(str);
          setState(() {});
        },
      ),
    );
  }
}
