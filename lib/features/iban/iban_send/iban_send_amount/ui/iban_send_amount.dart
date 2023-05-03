import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/iban/iban_send/iban_send_amount/store/iban_send_amount_store.dart';
import 'package:jetwallet/features/iban/iban_send/iban_send_limits/iban_send_limits.dart';
import 'package:jetwallet/features/payment_methods/ui/widgets/card_limits_bottom_sheet.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';

@RoutePage(name: 'IbanSendAmountRouter')
class IbanSendAmount extends StatelessWidget {
  const IbanSendAmount({
    super.key,
    required this.contact,
  });

  final AddressBookContactModel contact;

  @override
  Widget build(BuildContext context) {
    return Provider<IbanSendAmountStore>(
      create: (context) => IbanSendAmountStore()..init(contact),
      builder: (context, child) => const IbanSendAmountBody(),
    );
  }
}

class IbanSendAmountBody extends StatelessObserverWidget {
  const IbanSendAmountBody({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final store = IbanSendAmountStore.of(context);

    return SPageFrame(
      loading: store.loader,
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: '${intl.iban_out_send} ${store.eurCurrency.symbol}',
          subTitle: '${intl.withdrawalAmount_available}: ${volumeFormat(
            decimal: Decimal.parse(
              '${store.eurCurrency.assetBalance.toDouble() - store.eurCurrency.cardReserve.toDouble()}',
            ),
            accuracy: store.eurCurrency.accuracy,
            symbol: store.eurCurrency.symbol,
          )}',
          subTitleStyle: sSubtitle3Style.copyWith(
            color: colors.grey2,
          ),
        ),
      ),
      child: Column(
        children: [
          deviceSize.when(
            small: () => const SizedBox(),
            medium: () => const Spacer(),
          ),
          Column(
            children: [
              Baseline(
                baseline: deviceSize.when(
                  small: () => 20,
                  medium: () => 45,
                ),
                baselineType: TextBaseline.alphabetic,
                child: SActionPriceField(
                  widgetSize: widgetSizeFrom(deviceSize),
                  price: formatCurrencyStringAmount(
                    prefix: store.eurCurrency.prefixSymbol,
                    value: store.withAmount,
                    symbol: store.eurCurrency.symbol,
                  ),
                  helper: '',
                  error: store.withAmmountInputError == InputError.limitError
                      ? store.limitError
                      : store.withAmmountInputError.value(),
                  isErrorActive: store.withAmmountInputError.isActive,
                ),
              ),
            ],
          ),
          const Spacer(),
          /*SPaymentSelectCreditCard(
            widgetSize: widgetSizeFrom(deviceSize),
            icon: SAccountIcon(
              color: colors.black,
            ),
            name: store.contact?.name ?? '',
            description: store.contact?.iban ?? '',
            //limit: isLimitBlock ? 100 : state.limitByAsset?.barProgress ?? 0,
            limit: 0,
            onTap: () => showLimits(),
          ),
          */
          SPaymentSelectAsset(
            onTap: () {
              showIbanSendLimits(
                context: context,
                cardLimits: store.limits!,
                currency: store.eurCurrency,
              );
            },
            widgetSize: widgetSizeFrom(deviceSize),
            icon: SAccountIcon(
              color: colors.black,
            ),
            name: store.contact?.name ?? '',
            description: store.contact?.iban ?? '',
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
            selectedPreset: store.selectedPreset,
            onPresetChanged: (preset) {
              store.tapPreset(
                preset.index == 0
                    ? '25%'
                    : preset.index == 1
                        ? '50%'
                        : 'Max',
              );
              store.selectPercentFromBalance(preset);
            },
            onKeyPressed: (value) {
              store.updateAmount(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: store.withValid,
            submitButtonName: intl.addCircleCard_continue,
            onSubmitPressed: () {
              store.loadPreview();
            },
          ),
        ],
      ),
    );
  }
}
