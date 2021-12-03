import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../helpers/format_currency_string_amount.dart';
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
    final colors = useProvider(sColorPod);
    final state = useProvider(withdrawalAmountNotipod(withdrawal));
    final notifier = useProvider(withdrawalAmountNotipod(withdrawal).notifier);

    final currency = withdrawal.currency;

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: '${withdrawal.dictionary.verb} ${currency.description}',
        ),
      ),
      child: Column(
        children: [
          SActionPriceField(
            price: formatCurrencyStringAmount(
              prefix: currency.prefixSymbol,
              value: state.amount,
              symbol: currency.symbol,
            ),
            helper: '≈ ${state.baseConversionValue} '
                '${state.baseCurrency!.symbol}',
            error: state.inputError == InputError.enterHigherAmount
                ? '${state.inputError.value}. ${minimumAmount(currency)}'
                : state.inputError.value,
            isErrorActive: state.inputError.isActive,
          ),
          SBaselineChild(
            baseline: 24.h,
            child: Text(
              'Available: ${currency.formattedAssetBalance}',
              style: sSubtitle3Style.copyWith(
                color: colors.grey2,
              ),
            ),
          ),
          SBaselineChild(
            baseline: 36.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SBigArrowPositiveIcon(),
                Text(
                  _feeDescription(state.addressIsInternal, state.amount),
                  style: sCaptionTextStyle.copyWith(
                    color: colors.grey2,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SpaceH10(),
          SPaymentSelectAsset(
            icon: const SGiftIcon(),
            name: shortAddressForm(state.address),
            description: '${currency.symbol} wallet',
          ),
          const SpaceH20(),
          SNumericKeyboardAmount(
            preset1Name: '25%',
            preset2Name: '50%',
            preset3Name: 'MAX',
            selectedPreset: state.selectedPreset,
            onPresetChanged: (preset) {
              notifier.selectPercentFromBalance(preset);
            },
            onKeyPressed: (value) {
              notifier.updateAmount(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: state.valid,
            submitButtonName: 'Preview ${withdrawal.dictionary.noun}',
            onSubmitPressed: () {
              navigatorPush(
                context,
                WithdrawalPreview(
                  withdrawal: withdrawal,
                ),
              );
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
      return 'Fee: ${currency.withdrawalFeeWithSymbol} / $youWillReceive';
    }
  }
}
