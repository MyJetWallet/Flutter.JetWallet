import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/bank_card/helper/masked_text_input_formatter.dart';
import 'package:jetwallet/features/bank_card/store/bank_card_store.dart';

class BankCardDateLabel extends StatelessObserverWidget {
  const BankCardDateLabel({
    super.key,
    this.showLabel = true,
  });

  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final store = BankCardStore.of(context);

    return Row(
      children: [
        Expanded(
          child: Focus(
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                store.validExpiry();
              }
            },
            child: SInput(
              label: intl.addCircleCard_expiryMonth,
              focusNode: store.monthNode,
              keyboardType: TextInputType.number,
              hasErrorIcon: store.expiryMonthError,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
                CardMonthInputFormatter(),
              ],
              controller: store.expiryMonthController,
              onChanged: store.updateExpiryMonth,
              hasCloseIcon: store.cardStoreMode != BankCardStoreMode.edit,
              isDisabled: store.cardStoreMode == BankCardStoreMode.edit,
            ),
          ),
        ),
        if (showLabel) ...[
          Container(
            width: 1.0,
            height: 80.0,
            color: SColorsLight().gray4,
          ),
          Expanded(
            child: SInput(
              label: intl.addCircleCard_label,
              focusNode: store.labelNode,
              hasErrorIcon: store.labelError,
              hasCloseIcon: store.cardLabel.isNotEmpty,
              controller: store.cardLabelController,
              onChanged: store.setCardLabel,
              maxLength: 30,
            ),
          ),
        ],
      ],
    );
  }
}
