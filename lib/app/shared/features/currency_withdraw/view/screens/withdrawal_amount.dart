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
import '../../../../components/number_keyboard/number_keyboard.dart';
import '../../../../components/text/asset_conversion_text.dart';
import '../../../../helpers/input_helpers.dart';
import '../../../../helpers/short_address_form.dart';
import '../../../../models/currency_model.dart';
import '../../helper/minimum_amount.dart';
import '../../helper/user_will_receive.dart';
import '../../notifier/withdrawal_amount_notifier/withdrawal_amount_notipod.dart';
import 'withdrawal_preview.dart';

class WithdrawalAmount extends HookWidget {
  const WithdrawalAmount({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(withdrawalAmountNotipod(currency));
    final notifier = useProvider(withdrawalAmountNotipod(currency).notifier);

    return PageFrame(
      header: 'Withdraw ${currency.description} (${currency.symbol})',
      onBackButton: () => Navigator.pop(context),
      resizeToAvoidBottomInset: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          AssetInputField(
            value: fieldValue(state.amount, currency.symbol),
          ),
          const SpaceH10(),
          if (state.inputError.isActive)
            if (state.inputError == InputError.enterHigherAmount)
              AssetInputError(
                text: '${state.inputError.value}. ${minAmount(currency)}',
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
              text: 'Available: ${currency.assetBalance} '
                  '${currency.symbol}',
            ),
            const SpaceH20(),
            AssetConversionText(
              text: 'Your fee is: ${currency.withdrawalFeeSize} '
                  '${currency.fees.withdrawalFee?.assetSymbol} / '
                  'You will recive: ${userWillreceive(state.amount, currency)}',
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
          NumberKeyboard(
            onKeyPressed: (value) => notifier.updateAmount(value),
          ),
          const SpaceH20(),
          AppButtonSolid(
            name: 'Preview Withdrawal',
            active: state.valid,
            onTap: () {
              if (state.valid) {
                navigatorPush(
                  context,
                  WithdrawalPreview(
                    currency: currency,
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
