import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/iban/iban_send/iban_send_amount/store/iban_send_amount_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
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
          SizedBox(
            height: deviceSize.when(
              small: () => 116,
              medium: () => 152,
            ),
            child: Column(
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
                    error: store.withAmmountInputError ==
                            InputError.enterHigherAmount
                        ? '${intl.withdrawalAmount_enterMoreThan} '
                        : store.withAmmountInputError.value(),
                    isErrorActive: store.withAmmountInputError.isActive,
                  ),
                ),
                Baseline(
                  baseline: deviceSize.when(
                    small: () => -36,
                    medium: () => 24,
                  ),
                  baselineType: TextBaseline.alphabetic,
                  //eurCurrency.volumeBaseBalance(baseCurrency),
                  child: Text(
                    store.eurCurrency
                        .volumeBaseBalance(sSignalRModules.baseCurrency),
                    style: sSubtitle3Style.copyWith(
                      color: colors.grey2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SPaymentSelectAsset(
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
