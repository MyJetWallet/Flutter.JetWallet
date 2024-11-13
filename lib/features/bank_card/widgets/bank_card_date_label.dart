import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/bank_card/helper/masked_text_input_formatter.dart';
import 'package:jetwallet/features/bank_card/store/bank_card_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

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
            child: SFieldDividerFrame(
              child: SStandardField(
                labelText: intl.addCircleCard_expiryMonth,
                focusNode: store.monthNode,
                keyboardType: TextInputType.number,
                isError: store.expiryMonthError,
                disableErrorOnChanged: false,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  CardMonthInputFormatter(),
                ],
                controller: store.expiryMonthController,
                onChanged: store.updateExpiryMonth,
                hideClearButton: store.cardStoreMode == BankCardStoreMode.edit,
                readOnly: store.cardStoreMode == BankCardStoreMode.edit,
                grayLabel: store.cardStoreMode == BankCardStoreMode.edit,
              ),
            ),
          ),
        ),
        if (showLabel) ...[
          Container(
            width: 1.0,
            height: 88.0,
            color: SColorsLight().gray4,
          ),
          Expanded(
            child: SFieldDividerFrame(
              child: SStandardField(
                maxLines: 1,
                maxLength: 30,
                labelText: intl.addCircleCard_label,
                focusNode: store.labelNode,
                isError: store.labelError,
                enableInteractiveSelection: false,
                disableErrorOnChanged: false,
                controller: store.cardLabelController,
                onChanged: store.setCardLabel,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
