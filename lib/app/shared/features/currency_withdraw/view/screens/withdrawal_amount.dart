import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/helpers/widget_size_from.dart';
import '../../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../helpers/format_currency_string_amount.dart';
import '../../../../helpers/formatting/formatting.dart';
import '../../../../helpers/input_helpers.dart';
import '../../../../helpers/short_address_form.dart';
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
    final deviceSize = useProvider(deviceSizePod);
    final intl = useProvider(intlPod);
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
          deviceSize.when(
            small: () => const SizedBox(),
            medium: () => const Spacer(),
          ),
          SizedBox(
            height: deviceSize.when(
              small: () => 116,
              medium: () => 152,
            ),
            child: Column(
              children: [
                Baseline(
                  baseline: deviceSize.when(
                    small: () => 32,
                    medium: () => 60,
                  ),
                  baselineType: TextBaseline.alphabetic,
                  child: SActionPriceField(
                    widgetSize: widgetSizeFrom(deviceSize),
                    price: formatCurrencyStringAmount(
                      prefix: currency.prefixSymbol,
                      value: state.amount,
                      symbol: currency.symbol,
                    ),
                    helper: '≈ ${marketFormat(
                      accuracy: state.baseCurrency!.accuracy,
                      prefix: state.baseCurrency!.prefix,
                      decimal: Decimal.parse(state.baseConversionValue),
                      symbol: state.baseCurrency!.symbol,
                    )}',
                    error: state.inputError == InputError.enterHigherAmount
                        ? '${intl.enterMoreThan} '
                        '${currency.withdrawalFeeWithSymbol}'
                        : state.inputError.value,
                    isErrorActive: state.inputError.isActive,
                  ),
                ),
                Baseline(
                  baseline: deviceSize.when(
                    small: () => -36,
                    medium: () => 20,
                  ),
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    '${intl.available}: ${currency.volumeAssetBalance}',
                    style: sSubtitle3Style.copyWith(
                      color: colors.grey2,
                    ),
                  ),
                ),
                Baseline(
                  baseline: deviceSize.when(
                    small: () => -6,
                    medium: () => 30,
                  ),
                  baselineType: TextBaseline.alphabetic,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SFeeAlertIcon(),
                      const SpaceW10(),
                      Text(
                        _feeDescription(
                          state.addressIsInternal,
                          state.amount,
                          context,
                        ),
                        style: sCaptionTextStyle.copyWith(
                          color: colors.grey2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SPaymentSelectAsset(
            widgetSize: widgetSizeFrom(deviceSize),
            icon: SWalletIcon(
              color: colors.black,
            ),
            name: shortAddressForm(state.address),
            description: '${currency.symbol} ${intl.wallet}',
          ),
          deviceSize.when(
            small: () => const Spacer(),
            medium: () => const SpaceH20(),
          ),
          SNumericKeyboardAmount(
            widgetSize: widgetSizeFrom(deviceSize),
            preset1Name: '25%',
            preset2Name: '50%',
            preset3Name: intl.max,
            selectedPreset: state.selectedPreset,
            onPresetChanged: (preset) {
              notifier.selectPercentFromBalance(preset);
            },
            onKeyPressed: (value) {
              notifier.updateAmount(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: state.valid,
            submitButtonName: '${intl.preview} ${withdrawal.dictionary.verb}',
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

  String _feeDescription(
    bool isInternal,
    String amount,
    BuildContext context,
  ) {
    final currency = withdrawal.currency;
    final intl = context.read(intlPod);

    final result = userWillreceive(
      amount: amount,
      currency: currency,
      addressIsInternal: isInternal,
    );

    final youWillReceive = '${intl.youWillReceive}: $result';

    if (isInternal) {
      return '${intl.noFee} / $youWillReceive';
    } else {
      return '${intl.fee}: ${currency.withdrawalFeeWithSymbol} / $youWillReceive';
    }
  }
}
