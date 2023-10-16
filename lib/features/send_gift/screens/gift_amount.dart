import 'package:auto_route/annotations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/send_gift/model/send_gift_info_model.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/l10n/i10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/device_size/device_size.dart';
import '../../../utils/helpers/input_helpers.dart';
import '../../../utils/helpers/widget_size_from.dart';
import '../store/gift_send_amount_store.dart';
import '../widgets/gift_send_type.dart';

@RoutePage(name: 'GiftAmountRouter')
class GiftAmount extends StatefulObserverWidget {
  const GiftAmount({super.key, required this.sendGiftInfo});

  final SendGiftInfoModel sendGiftInfo;

  @override
  State<GiftAmount> createState() => _GiftAmountState();
}

class _GiftAmountState extends State<GiftAmount> {
  late GeftSendAmountStore geftSendAmountStore;

  @override
  void initState() {
    sAnalytics.sendGiftAmountScreenView(
      giftSubmethod: widget.sendGiftInfo.selectedContactType?.name ?? '',
      asset: widget.sendGiftInfo.currency?.symbol ?? '',
    );
    geftSendAmountStore = GeftSendAmountStore()
      ..init(
        widget.sendGiftInfo.currency ?? CurrencyModel.empty(),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final sColors = sKit.colors;

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.send_gift_title,
          subTitle: '${intl.send_gift_available}: ${volumeFormat(
            decimal: geftSendAmountStore.availableCurrency,
            accuracy: widget.sendGiftInfo.currency?.accuracy ?? 0,
            symbol: widget.sendGiftInfo.currency?.symbol ?? '',
          )}',
          subTitleStyle: sBodyText2Style.copyWith(
            color: sColors.grey1,
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
                    value: geftSendAmountStore.withAmount,
                    symbol: geftSendAmountStore.selectedCurrency.symbol,
                  ),
                  helper: '≈ ${marketFormat(
                    accuracy: geftSendAmountStore.baseCurrency.accuracy,
                    decimal: Decimal.parse(
                      geftSendAmountStore.baseConversionValue,
                    ),
                    symbol: geftSendAmountStore.baseCurrency.symbol,
                  )}',
                  error: geftSendAmountStore.withAmmountInputError == InputError.limitError
                      ? geftSendAmountStore.limitError
                      : geftSendAmountStore.withAmmountInputError.value(),
                  isErrorActive: geftSendAmountStore.withAmmountInputError.isActive,
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
                onKeyPressed: (value) {
                  geftSendAmountStore.updateAmount(value);
                  if (geftSendAmountStore.withAmmountInputError != InputError.none) {
                    sAnalytics.errorSendLimitExceeded(
                      asset: geftSendAmountStore.selectedCurrency.symbol,
                      giftSubmethod: widget.sendGiftInfo.selectedContactType?.name ?? '',
                      errorText: geftSendAmountStore.withAmmountInputError == InputError.limitError
                          ? geftSendAmountStore.limitError
                          : geftSendAmountStore.withAmmountInputError.value(),
                    );
                  }
                },
                buttonType: SButtonType.primary2,
                submitButtonActive:
                    geftSendAmountStore.withAmmountInputError == InputError.none && geftSendAmountStore.withValid,
                submitButtonName: intl.addCircleCard_continue,
                onSubmitPressed: () {
                  final tempSendGiftInfo = widget.sendGiftInfo.copyWith(
                    amount: Decimal.tryParse(geftSendAmountStore.withAmount),
                  );

                  sAnalytics.tapOnTheButtonContinueWithSendGiftAmountScreen(
                    asset: geftSendAmountStore.selectedCurrency.symbol,
                    giftSubmethod: tempSendGiftInfo.selectedContactType?.name ?? '',
                    totalSendAmount: tempSendGiftInfo.amount.toString(),
                    preset: 'false',
                  );
                  sAnalytics.orderSummarySendScreenView(
                    giftSubmethod: tempSendGiftInfo.selectedContactType?.name ?? '',
                  );
                  sRouter.push(
                    GiftOrderSummuryRouter(
                      sendGiftInfo: tempSendGiftInfo,
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
