import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../../shared/components/spacers.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../components/asset_input_error.dart';
import '../../../../components/asset_input_field.dart';
import '../../../../components/balance_selector/view/percent_selector.dart';
import '../../../../components/number_keyboard/number_keyboard_amount.dart';
import '../../../../components/text/asset_conversion_text.dart';
import '../../../../helpers/input_helpers.dart';
import '../../../currency_withdraw/helper/minimum_amount.dart';
import '../../../currency_withdraw/model/withdrawal_model.dart';
import '../../notifier/send_amount_notifier/send_amount_notipod.dart';
import '../../notifier/send_input_phone_number/send_input_phone_number_notipod.dart';
import '../components/phone_card.dart';
import 'send_preview.dart';

class SendInputAmount extends HookWidget {
  const SendInputAmount({
    Key? key,
    required this.withdrawal,
  }) : super(key: key);

  final WithdrawalModel withdrawal;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(sendAmountNotipod(withdrawal));
    final notifier = useProvider(sendAmountNotipod(withdrawal).notifier);
    final inputPhoneNumberState = useProvider(sendInputPhoneNumberNotipod);
    final currency = withdrawal.currency;

    return PageFrame(
      header: '${withdrawal.dictionary.verb} '
          '${currency.description} by phone',
      onBackButton: () => Navigator.pop(context),
      resizeToAvoidBottomInset: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          AssetInputField(
            value: '${state.amount} ${currency.symbol}',
          ),
          const SpaceH10(),
          if (state.inputError.isActive)
            if (state.inputError == InputError.enterHigherAmount)
              AssetInputError(
                text: '${state.inputError.value}. ${minimumAmount(currency)}',
              )
            else
              AssetInputError(
                text: state.inputError.value,
              )
          else ...[
            CenterAssetConversionText(
              text: '≈ ${state.baseConversionValue} '
                  '${state.baseCurrency!.symbol}',
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            CenterAssetConversionText(
              text: 'Available: ${currency.assetBalance} ${currency.symbol}',
            ),
            const SpaceH20(),
          ],
          const Spacer(),
          PhoneCard(phoneNumber: inputPhoneNumberState.phoneNumber,),
          const SpaceH10(),
          PercentSelector(
            disabled: false,
            onSelection: (value) {
              notifier.selectPercentFromBalance(value);
            },
          ),
          const SpaceH10(),
          NumberKeyboardAmount(
            onKeyPressed: (value) => notifier.updateAmount(value),
          ),
          const SpaceH20(),
          AppButtonSolid(
            name: 'Preview ${withdrawal.dictionary.noun}',
            active: state.valid,
            onTap: () {
              if (state.valid) {
                navigatorPush(
                  context,
                  SendPreview(
                    withdrawal: withdrawal,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
