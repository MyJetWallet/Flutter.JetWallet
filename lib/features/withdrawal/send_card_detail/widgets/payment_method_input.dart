import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/features/add_circle_card/helper/masked_text_input_formatter.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/store/send_card_detail_store.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/global_send_methods_model.dart';

// ignore: avoid_classes_with_only_static_members
class PaymentMethodInput {
  static Widget cardNumber(GlobalSendMethod method) => PaymentMethodCardNumber(method: method);

  static Widget iban(GlobalSendMethod method) => PaymentMethodIban(method: method);

  static Widget phoneNumber(GlobalSendMethod method) => PaymentMethodNumbers(method: method);

  static Widget recipientName(GlobalSendMethod method) => PaymentMethodRecipientName(method: method);

  static Widget panNumber(GlobalSendMethod method) => PaymentMethodString(method: method);

  static Widget upiAddress(GlobalSendMethod method) => PaymentMethodString(method: method);

  static Widget accountNumber(GlobalSendMethod method) => PaymentMethodString(method: method);

  static Widget beneficiaryName(GlobalSendMethod method) => PaymentMethodString(method: method);

  static Widget bankName(GlobalSendMethod method) => PaymentMethodString(method: method);

  static Widget ifscCode(GlobalSendMethod method) => PaymentMethodString(method: method);

  static Widget bankAccount(GlobalSendMethod method) => PaymentMethodString(method: method);

  static Widget wise(GlobalSendMethod method) => PaymentMethodString(method: method);

  static Widget tin(GlobalSendMethod method) => PaymentMethodString(method: method);

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
      case FieldInfoId.wise:
        return wise(method);
      case FieldInfoId.tin:
        return tin(method);
      default:
        return const SizedBox.shrink();
    }
  }
}

class PaymentMethodIban extends StatelessWidget {
  const PaymentMethodIban({super.key, required this.method});

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
      paste: () async {
        await SendCardDetailStore.of(context).paste(method.id);

        final data = await Clipboard.getData('text/plain');
        final copiedText = (data?.text ?? '').replaceAll(' ', '');

        method.controller.text = copiedText;

        final ibanMask = MaskTextInputFormatter(
          mask: '#### #### #### #### #### #### ####',
          initialText: method.controller.text,
          filter: {
            '#': RegExp('[a-zA-Z0-9]'),
          },
          type: MaskAutoCompletionType.eager,
        );
        method.controller.text = ibanMask.maskText(method.controller.text);

        method.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: method.controller.text.length),
        );
      },
      onChanged: (val) {
        SendCardDetailStore.of(context).onChanged(method.id, val);
      },
      inputType: TextInputType.name,
      inputFormatters: [
        MaskTextInputFormatter(
          mask: '#### #### #### #### #### #### ####',
          initialText: method.controller.text,
          filter: {
            '#': RegExp('[a-zA-Z0-9]'),
          },
          type: MaskAutoCompletionType.eager,
        ),
      ],
    );
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
        SendCardDetailStore.of(context).paste(
          method.id,
          isRecipientName: true,
        );
      },
      onChanged: (val) {
        SendCardDetailStore.of(context).onChanged(method.id, val);
      },
      inputType: TextInputType.name,
    );
  }
}

class PaymentMethodString extends StatelessWidget {
  const PaymentMethodString({super.key, required this.method});

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
      inputType: TextInputType.text,
    );
  }
}

class PaymentMethodCardNumber extends StatefulWidget {
  const PaymentMethodCardNumber({super.key, required this.method});

  final GlobalSendMethod method;

  @override
  State<PaymentMethodCardNumber> createState() => _PaymentMethodCardNumberState();
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
        setState(() {});
      },
      paste: () {
        SendCardDetailStore.of(context).paste(
          widget.method.id,
          isCard: true,
        );
        setState(() {});
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
          setState(() {});
        },
        suffixIcons: [
          SIconButton(
            onTap: () {
              widget.paste();
              setState(() {});
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
