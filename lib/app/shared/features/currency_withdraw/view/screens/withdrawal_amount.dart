import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../../shared/components/spacers.dart';
import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../components/asset_input_error.dart';
import '../../../../components/asset_input_field.dart';
import '../../../../components/asset_tile/asset_tile.dart';
import '../../../../components/balance_selector/view/percent_selector.dart';
import '../../../../components/number_keyboard/number_keyboard_amount.dart';
import '../../../../components/text/asset_conversion_text.dart';
import '../../../../helpers/input_helpers.dart';
import '../../../../helpers/short_address_form.dart';
import '../../helper/minimum_amount.dart';
import '../../helper/user_will_receive.dart';
import '../../model/withdrawal_model.dart';
import '../../notifier/withdrawal_amount_notifier/withdrawal_amount_notipod.dart';
import 'withdrawal_preview.dart';

class WithdrawalAmount extends HookWidget {
  const WithdrawalAmount({
    Key? key,
    required this.withdrawal,
  }) : super(key: key);

  final WithdrawalModel withdrawal;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(withdrawalAmountNotipod(withdrawal));
    final notifier = useProvider(withdrawalAmountNotipod(withdrawal).notifier);

    final currency = withdrawal.currency;

    return PageFrame(
      header: '${withdrawal.dictionary.verb} '
          '${currency.description} (${currency.symbol})',
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
            AssetConversionText(
              text: _feeDescription(state.addressIsInternal, state.amount),
            ),
          ],
          const Spacer(),
          AssetTile(
            headerColor: Colors.black,
            firstColumnHeader: shortAddressForm(state.address),
            firstColumnSubheader: '${currency.symbol} wallet',
            enableBalanceColumn: false,
            currency: currency,
          ),
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
                  WithdrawalPreview(
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

  String _feeDescription(bool isInternal, String amount) {
    final currency = withdrawal.currency;

    final result = userWillreceive(
      amount: amount,
      currency: currency,
      addressIsInternal: isInternal,
    );

    final youWillReceive = 'You will receive: $result';

    if (isInternal) {
      return 'No ${withdrawal.dictionary.noun} fee! / $youWillReceive';
    } else {
      return 'Your fee is: ${currency.withdrawaFeeWithSymbol} / $youWillReceive';
    }
  }
}
