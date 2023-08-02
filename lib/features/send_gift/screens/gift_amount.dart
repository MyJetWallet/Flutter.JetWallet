import 'package:auto_route/annotations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
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
class GiftAmount extends StatelessObserverWidget {
  const GiftAmount({super.key, required this.sendGiftStore});

  final GeneralSendGiftStore sendGiftStore;

  @override
  Widget build(BuildContext context) {
    final geftSendAmountStore = GeftSendAmountStore()
      ..init(
        sendGiftStore.currency,
      );
    geftSendAmountStore.selectedCurrency = sendGiftStore.currency;
    final deviceSize = sDeviceSize;

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.send_gift_title,
          subTitle: '${intl.send_gift_available}:${volumeFormat(
            prefix: sendGiftStore.currency.prefixSymbol,
            decimal: sendGiftStore.currency.assetBalance,
            accuracy: sendGiftStore.currency.accuracy,
            symbol: sendGiftStore.currency.symbol,
          )}',
          subTitleStyle: const TextStyle(
            color: Color(0xFF777C85),
            fontSize: 14,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w500,
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
              baseline: deviceSize.when(
                small: () => 32,
                medium: () => 31,
              ),
              baselineType: TextBaseline.alphabetic,
            child: Observer(
              builder: (context) {
                return SActionPriceField(
                  widgetSize: widgetSizeFrom(deviceSize),
                  price: volumeFormat(
                    prefix: geftSendAmountStore.selectedCurrency.prefixSymbol,
                    decimal: Decimal.parse(geftSendAmountStore.withAmount),
                    symbol: geftSendAmountStore.selectedCurrency.symbol,
                    accuracy: sendGiftStore.currency.accuracy,
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
          const SpaceH20(),
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
                },
                buttonType: SButtonType.primary2,
                submitButtonActive: geftSendAmountStore.withValid,
                submitButtonName: intl.addCircleCard_continue,
                onSubmitPressed: () {
                  sendGiftStore.updateAmount(geftSendAmountStore.withAmount);
                  sRouter.push(
                    GiftOrderSummuryRouter(
                      sendGiftStore: sendGiftStore,
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
