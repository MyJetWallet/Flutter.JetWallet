import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/send_by_phone/model/contact_model.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_amount_store.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_preview_store.dart';
import 'package:jetwallet/features/send_by_phone/ui/send_by_phone_input/send_by_phone_input.dart';
import 'package:jetwallet/features/withdrawal/helper/minimum_amount.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'SendByPhoneAmountRouter')
class SendByPhoneAmount extends StatelessWidget {
  const SendByPhoneAmount({
    super.key,
    required this.currency,
    this.pickedContact,
    this.activeDialCode,
  });

  final CurrencyModel currency;
  final ContactModel? pickedContact;
  final SPhoneNumber? activeDialCode;

  @override
  Widget build(BuildContext context) {
    return Provider<SendByPhoneAmmountStore>(
      create: (context) => SendByPhoneAmmountStore(
        currency,
        pickedContact,
        activeDialCode,
      ),
      builder: (context, child) => _SendByPhoneAmountBody(
        currency: currency,
      ),
    );
  }
}

class _SendByPhoneAmountBody extends StatelessObserverWidget {
  const _SendByPhoneAmountBody({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final state = SendByPhoneAmmountStore.of(context);

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: '${intl.sendByPhoneAmount_send} ${currency.description}',
        ),
      ),
      child: Column(
        children: [
          deviceSize.when(
            small: () => const SizedBox(),
            medium: () => const Spacer(),
          ),
          if (state.baseCurrency != null) ...[
            SActionPriceField(
              widgetSize: widgetSizeFrom(deviceSize),
              price: formatCurrencyStringAmount(
                prefix: currency.prefixSymbol,
                value: state.amount,
                symbol: currency.symbol,
              ),
              helper: '≈ ${volumeFormat(
                accuracy: state.baseCurrency!.accuracy,
                prefix: state.baseCurrency!.prefix,
                decimal: Decimal.parse(state.baseConversionValue),
                symbol: state.baseCurrency!.symbol,
              )}',
              error: state.inputError == InputError.enterHigherAmount
                  ? '${state.inputError.value}. '
                      '${minimumAmount(currency)}'
                  : state.inputError.value(),
              isErrorActive: state.inputError.isActive,
            ),
          ],
          Baseline(
            baseline: deviceSize.when(
              small: () => -36,
              medium: () => 19,
            ),
            baselineType: TextBaseline.alphabetic,
            child: Text(
              '${intl.sendByPhoneAmount_available}: '
              '${volumeFormat(
                decimal: Decimal.parse(
                  '${currency.assetBalance.toDouble() - currency.cardReserve.toDouble()}',
                ),
                accuracy: currency.accuracy,
                symbol: currency.symbol,
              )}',
              style: sSubtitle3Style.copyWith(
                color: colors.grey2,
              ),
            ),
          ),
          const Spacer(),
          if (state.pickedContact?.isContactWithName ?? false)
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
              state.tapPreset(
                preset.index == 0
                    ? '25%'
                    : preset.index == 1
                        ? '50%'
                        : 'Max',
              );
              state.selectPercentFromBalance(preset);
            },
            onKeyPressed: (value) {
              state.updateAmount(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: state.valid,
            submitButtonName: intl.sendByPhoneAmount_previewSend,
            onSubmitPressed: () {
              sRouter.push(
                SendByPhonePreviewRouter(
                  currency: currency,
                  amountStoreAmount: state.amount,
                  pickedContact: state.pickedContact!,
                  activeDialCode: state.activeDialCode!,
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
