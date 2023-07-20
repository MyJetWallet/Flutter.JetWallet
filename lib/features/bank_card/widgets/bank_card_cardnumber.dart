import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/add_circle_card/helper/masked_text_input_formatter.dart';
import 'package:jetwallet/features/bank_card/store/bank_card_store.dart';
import 'package:simple_kit/simple_kit.dart';

class BankCardCardnumber extends StatefulObserverWidget {
  const BankCardCardnumber({super.key});

  @override
  State<BankCardCardnumber> createState() => _BankCardCardnumberState();
}

class _BankCardCardnumberState extends State<BankCardCardnumber> {
  @override
  Widget build(BuildContext context) {
    final store = BankCardStore.of(context);

    return SFieldDividerFrame(
      child: SStandardField(
        labelText: intl.addCircleCard_cardNumber,
        keyboardType: TextInputType.number,
        isError: store.cardNumberError,
        disableErrorOnChanged: false,
        // In formatting \u2005 is used instead of \u0020
        // to avoid \u0020 input from the user
        inputFormatters: [
          MaskedTextInputFormatter(
            mask: 'xxxx\u{2005}xxxx\u{2005}xxxx\u{2005}xxxx',
            separator: '\u{2005}',
          ),
          FilteringTextInputFormatter.allow(
            RegExp(r'[0-9\u2005]'),
          ),
        ],
        focusNode: store.cardNode,
        controller: store.cardNumberController,
        onChanged: store.updateCardNumber,
        suffixIcons: store.cardStoreMode == BankCardStoreMode.ADD
            ? [
                SIconButton(
                  onTap: () {
                    setState(() {
                      store.pasteCode();
                    });

                    Future.delayed(const Duration(milliseconds: 150), () {
                      setState(() {});
                    });
                  },
                  defaultIcon: const SPasteIcon(),
                ),
              ]
            : null,
        onErase: () {
          store.onEraseCardNumber();
        },
        hideClearButton: store.cardStoreMode == BankCardStoreMode.EDIT,
        readOnly: store.cardStoreMode == BankCardStoreMode.EDIT,
        grayLabel: store.cardStoreMode == BankCardStoreMode.EDIT,
      ),
    );
  }
}
