import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../helpers/format_currency_string_amount.dart';
import '../../../../helpers/input_helpers.dart';
import '../../../../models/currency_model.dart';
import '../../../currency_withdraw/helper/minimum_amount.dart';
import '../../notifier/send_by_phone_amount_notifier/send_by_phone_amount_notipod.dart';
import '../../notifier/send_by_phone_input_notifier/send_by_phone_input_notipod.dart';
import 'send_by_phone_preview.dart';

class SendByPhoneAmount extends HookWidget {
  const SendByPhoneAmount({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final input = useProvider(sendByPhoneInputNotipod);
    final amount = useProvider(sendByPhoneAmountNotipod(currency));
    final amountN = useProvider(sendByPhoneAmountNotipod(currency).notifier);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: 'Send ${currency.description}',
        ),
      ),
      child: Column(
        children: [
          SActionPriceField(
            price: formatCurrencyStringAmount(
              prefix: currency.prefixSymbol,
              value: amount.amount,
              symbol: currency.symbol,
            ),
            helper: '≈ ${amount.baseConversionValue} '
                '${amount.baseCurrency!.symbol}',
            error: amount.inputError == InputError.enterHigherAmount
                ? '${amount.inputError.value}. ${minimumAmount(currency)}'
                : amount.inputError.value,
            isErrorActive: amount.inputError.isActive,
          ),
          SBaselineChild(
            baseline: 24.0,
            child: Text(
              'Available: ${currency.formattedAssetBalance}',
              style: sSubtitle3Style.copyWith(
                color: colors.grey2,
              ),
            ),
          ),
          const Spacer(),
          const SpaceH10(),
          if (input.contactName != input.fullNumber)
            SPaymentSelectContact(
              name: input.contactName,
              phone: input.fullNumber,
            )
          else
            SPaymentSelectContactWithoutName(
              phone: input.fullNumber,
            ),
          const SpaceH20(),
          SNumericKeyboardAmount(
            preset1Name: '25%',
            preset2Name: '50%',
            preset3Name: 'MAX',
            selectedPreset: amount.selectedPreset,
            onPresetChanged: (preset) {
              amountN.selectPercentFromBalance(preset);
            },
            onKeyPressed: (value) {
              amountN.updateAmount(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: amount.valid,
            submitButtonName: 'Preview Send',
            onSubmitPressed: () {
              navigatorPush(
                context,
                SendByPhonePreview(
                  currency: currency,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
