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
import '../../../../models/currency_model.dart';
import '../../../currency_withdraw/helper/minimum_amount.dart';
import '../../notifier/send_by_phone_amount_notifier/send_by_phone_amount_notipod.dart';
import 'send_by_phone_input/send_by_phone_input.dart';
import 'send_by_phone_preview.dart';

class SendByPhoneAmount extends HookWidget {
  const SendByPhoneAmount({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final deviceSize = useProvider(deviceSizePod);
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final state = useProvider(sendByPhoneAmountNotipod(currency));
    final notifier = useProvider(sendByPhoneAmountNotipod(currency).notifier);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: '${intl.send} ${currency.description}',
        ),
      ),
      child: Column(
        children: [
          deviceSize.when(
            small: () => const SizedBox(),
            medium: () => const Spacer(),
          ),
          SActionPriceField(
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
                ? '${state.inputError.value}. ${minimumAmount(currency, context)}'
                : state.inputError.value,
            isErrorActive: state.inputError.isActive,
          ),
          Baseline(
            baseline: deviceSize.when(
              small: () => -36,
              medium: () => 19,
            ),
            baselineType: TextBaseline.alphabetic,
            child: Text(
              '${intl.available}: ${currency.volumeAssetBalance}',
              style: sSubtitle3Style.copyWith(
                color: colors.grey2,
              ),
            ),
          ),
          const Spacer(),
          if (state.pickedContact!.isContactWithName)
            _navigatePushAndRemoveUntil(
              context,
              SPaymentSelectContact(
                widgetSize: widgetSizeFrom(deviceSize),
                name: state.pickedContact!.name,
                phone: state.pickedContact!.phoneNumber,
              ),
            )
          else
            _navigatePushAndRemoveUntil(
              context,
              SPaymentSelectContactWithoutName(
                widgetSize: widgetSizeFrom(deviceSize),
                phone: state.pickedContact!.phoneNumber,
              ),
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
            submitButtonName: intl.previewSend,
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

  Widget _navigatePushAndRemoveUntil(
    BuildContext context,
    Widget child,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => SendByPhoneInput(currency: currency),
          ),
          (route) => route.isFirst,
        );
      },
      child: child,
    );
  }
}
