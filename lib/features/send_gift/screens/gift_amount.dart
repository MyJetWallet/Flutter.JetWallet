import 'package:auto_route/annotations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';
import 'package:jetwallet/features/send_gift/model/send_gift_info_model.dart';
import 'package:jetwallet/features/send_gift/store/receiver_datails_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/device_size/device_size.dart';
import '../../../utils/helpers/input_helpers.dart';
import '../../../utils/helpers/widget_size_from.dart';
import '../../app/store/app_store.dart';
import '../store/gift_send_amount_store.dart';

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
          subTitle:
              '${intl.send_gift_available}: ${getIt<AppStore>().isBalanceHide ? '**** ${widget.sendGiftInfo.currency?.symbol ?? ''}' : geftSendAmountStore.availableCurrency.toFormatCount(
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
          SNumericLargeInput(
            primaryAmount: formatCurrencyStringAmount(
              value: geftSendAmountStore.withAmount,
            ),
            primarySymbol: geftSendAmountStore.selectedCurrency.symbol,
            secondaryAmount: '${intl.earn_est} ${Decimal.parse(geftSendAmountStore.baseConversionValue).toFormatSum(
              accuracy: sSignalRModules.baseCurrency.accuracy,
            )}',
            secondarySymbol: sSignalRModules.baseCurrency.symbol,
            showSwopButton: false,
            onSwap: () {},
            errorText: geftSendAmountStore.withAmmountInputError.isActive
                ? geftSendAmountStore.withAmmountInputError == InputError.limitError
                    ? geftSendAmountStore.limitError
                    : geftSendAmountStore.withAmmountInputError.value()
                : null,
            showMaxButton: true,
            onMaxTap: geftSendAmountStore.onSandAll,
            pasteLabel: intl.paste,
            onPaste: () async {
              final data = await Clipboard.getData('text/plain');
              if (data?.text != null) {
                final n = double.tryParse(data!.text!);
                if (n != null) {
                  geftSendAmountStore.pasteAmount(n.toString().trim());
                }
              }
            },
          ),
          const Spacer(),
          SuggestionButtonWidget(
            title: widget.sendGiftInfo.selectedContactType == ReceiverContacrType.email
                ? widget.sendGiftInfo.email
                : '${widget.sendGiftInfo.phoneCountryCode} ${widget.sendGiftInfo.phoneBody}',
            subTitle: intl.send_gift_send_gift_to,
            icon: Assets.svg.assets.fiat.gift.simpleSvg(
              width: 24,
            ),
            onTap: () {},
          ),
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
                },
                buttonType: SButtonType.primary2,
                submitButtonActive:
                    geftSendAmountStore.withAmmountInputError == InputError.none && geftSendAmountStore.withValid,
                submitButtonName: intl.addCircleCard_continue,
                onSubmitPressed: () {
                  final tempSendGiftInfo = widget.sendGiftInfo.copyWith(
                    amount: Decimal.tryParse(geftSendAmountStore.withAmount),
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
