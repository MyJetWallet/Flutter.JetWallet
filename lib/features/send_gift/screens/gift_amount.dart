import 'package:auto_route/annotations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/l10n/i10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/device_size/device_size.dart';
import '../../../utils/helpers/input_helpers.dart';
import '../../../utils/helpers/widget_size_from.dart';
import '../store/general_send_gift_store.dart';
import '../store/gift_send_amount_store.dart';
import '../widgets/gift_send_type.dart';

@RoutePage(name: 'GiftAmountRouter')
class GiftAmount extends StatefulObserverWidget {
  const GiftAmount({super.key, required this.sendGiftStore});

  final GeneralSendGiftStore sendGiftStore;

  @override
  State<GiftAmount> createState() => _GiftAmountState();
}

class _GiftAmountState extends State<GiftAmount> {
  late GeftSendAmountStore geftSendAmountStore;

  @override
  void initState() {
    sAnalytics.sendGiftAmountScreenView(
      giftSubmethod: widget.sendGiftStore.selectedContactType.name,
      asset: widget.sendGiftStore.currency.symbol,
    );
    geftSendAmountStore = GeftSendAmountStore()
      ..init(
        widget.sendGiftStore.currency,
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;

    final availableCurrency = currencyFrom(
      sSignalRModules.currenciesList,
      widget.sendGiftStore.currency.symbol,
    );

    final availableBalance = Decimal.parse(
      '''${availableCurrency.assetBalance.toDouble() - availableCurrency.cardReserve.toDouble()}''',
    );

    geftSendAmountStore.init(
      availableCurrency,
    );

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.send_gift_title,
          subTitle: '${intl.send_gift_available}: ${volumeFormat(
            prefix: widget.sendGiftStore.currency.prefixSymbol,
            decimal: availableBalance,
            accuracy: widget.sendGiftStore.currency.accuracy,
            symbol: widget.sendGiftStore.currency.symbol,
          )}',
          subTitleStyle: const TextStyle(
            color: Color(0xFF777C85),
            fontSize: 14,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w500,
            height: 1.50,
          ),
        ),
      ),
      child: Column(
        children: [
          deviceSize.when(
            small: () => const SizedBox(),
            medium: () => const Spacer(),
          ),
          Baseline(
            baseline: 45,
            baselineType: TextBaseline.alphabetic,
            child: Observer(
              builder: (context) {
                return SActionPriceField(
                  widgetSize: widgetSizeFrom(deviceSize),
                  price: formatCurrencyStringAmount(
                    prefix: geftSendAmountStore.selectedCurrency.prefixSymbol,
                    value: geftSendAmountStore.withAmount,
                    symbol: geftSendAmountStore.selectedCurrency.symbol,
                  ),
                  helper: '',
                  error: geftSendAmountStore.withAmmountInputError ==
                          InputError.limitError
                      ? geftSendAmountStore.limitError
                      : geftSendAmountStore.withAmmountInputError.value(),
                  isErrorActive:
                      geftSendAmountStore.withAmmountInputError.isActive,
                );
              },
            ),
          ),
          const Spacer(),
          const GiftSendType(),
          deviceSize.when(
            small: () => const Spacer(),
            medium: () => const SpaceH20(),
          ),
          Observer(
            builder: (context) {
              return SNumericKeyboardAmount(
                widgetSize: widgetSizeFrom(deviceSize),
                preset1Name: '25%',
                preset2Name: '50%',
                preset3Name: intl.max,
                selectedPreset: geftSendAmountStore.selectedPreset,
                onPresetChanged: (preset) {
                  geftSendAmountStore.tapPreset(
                    preset.index == 0
                        ? '25%'
                        : preset.index == 1
                            ? '50%'
                            : 'Max',
                  );
                  geftSendAmountStore.selectPercentFromBalance(preset);
                },
                onKeyPressed: (value) {
                  geftSendAmountStore.updateAmount(value);
                  if (geftSendAmountStore.withAmmountInputError !=
                      InputError.none) {
                    sAnalytics.errorSendLimitExceeded(
                      asset: geftSendAmountStore.selectedCurrency.symbol,
                      giftSubmethod:
                          widget.sendGiftStore.selectedContactType.name,
                      errorText: geftSendAmountStore.withAmmountInputError ==
                              InputError.limitError
                          ? geftSendAmountStore.limitError
                          : geftSendAmountStore.withAmmountInputError.value(),
                    );
                  }
                },
                buttonType: SButtonType.primary2,
                submitButtonActive: geftSendAmountStore.withAmmountInputError ==
                        InputError.none &&
                    geftSendAmountStore.withValid,
                submitButtonName: intl.addCircleCard_continue,
                onSubmitPressed: () {
                  widget.sendGiftStore
                      .updateAmount(geftSendAmountStore.withAmount);
                  dynamic preset;
                  switch (geftSendAmountStore.selectedPreset) {
                    case SKeyboardPreset.preset1:
                      preset = '25%';
                      break;
                    case SKeyboardPreset.preset2:
                      preset = '50%';
                      break;
                    case SKeyboardPreset.preset3:
                      preset = '100%';
                      break;
                    default:
                      preset = false;
                  }

                  sAnalytics.tapOnTheButtonContinueWithSendGiftAmountScreen(
                    asset: geftSendAmountStore.selectedCurrency.symbol,
                    giftSubmethod:
                        widget.sendGiftStore.selectedContactType.name,
                    totalSendAmount: widget.sendGiftStore.amount.toString(),
                    preset: preset,
                  );
                  sAnalytics.orderSummarySendScreenView(
                    giftSubmethod:
                        widget.sendGiftStore.selectedContactType.name,
                  );
                  sRouter.push(
                    GiftOrderSummuryRouter(
                      sendGiftStore: widget.sendGiftStore,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
