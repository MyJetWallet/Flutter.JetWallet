import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/store/send_globally_amount_store.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/utils/send_globally_limits.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/signal_r/models/global_send_methods_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_request_model.dart';

@RoutePage(name: 'SendGloballyAmountRouter')
class SendGloballyAmountScreen extends StatelessWidget {
  const SendGloballyAmountScreen({
    super.key,
    required this.data,
    required this.method,
  });

  final SendToBankRequestModel data;
  final GlobalSendMethodsModelMethods method;

  @override
  Widget build(BuildContext context) {
    return Provider<SendGloballyAmountStore>(
      create: (context) =>
          SendGloballyAmountStore()..setCardNumber(data, method),
      builder: (context, child) => SendGloballyAmountScreenBody(
        data: data,
        method: method,
      ),
    );
  }
}

class SendGloballyAmountScreenBody extends StatefulObserverWidget {
  const SendGloballyAmountScreenBody({
    super.key,
    required this.data,
    required this.method,
  });

  final SendToBankRequestModel data;
  final GlobalSendMethodsModelMethods method;

  @override
  State<SendGloballyAmountScreenBody> createState() =>
      _SendGloballyAmountScreenBodyState();
}

class _SendGloballyAmountScreenBodyState
    extends State<SendGloballyAmountScreenBody> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = SendGloballyAmountStore.of(context);

    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    return SPageFrame(
      loading: store.loader,
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.send_globally,
          subTitle: '${intl.withdrawalAmount_available}: '
              '${volumeFormat(
            decimal: store.availableBalabce,
            accuracy: store.sendCurrency!.accuracy,
            symbol: store.sendCurrency!.symbol,
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
          Baseline(
            baseline: deviceSize.when(
              small: () => 20,
              medium: () => 48,
            ),
            baselineType: TextBaseline.alphabetic,
            child: SActionPriceField(
              widgetSize: widgetSizeFrom(deviceSize),
              price: formatCurrencyStringAmount(
                prefix: store.sendCurrency!.prefixSymbol,
                value: store.withAmount,
                symbol: store.sendCurrency!.symbol,
              ),
              helper: '',
              error: store.withAmmountInputError == InputError.limitError
                  ? store.limitError
                  : store.withAmmountInputError.value(),
              isErrorActive: store.withAmmountInputError.isActive,
            ),
          ),
          //const SizedBox(height: 40),
          const Spacer(),
          SPaddingH24(
            child: InkWell(
              onTap: () {
                showGlobalSendLimits(
                  context: context,
                  minAmount: store.method!.minAmount!,
                  maxAmount: store.method!.maxAmount!,
                  currency: store.sendCurrency!,
                );
              },
              highlightColor: sKit.colors.grey4,
              splashColor: Colors.transparent,
              borderRadius: BorderRadius.circular(16.0),
              child: Ink(
                height: 88,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: colors.grey4,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SpaceW19(), // 1 px border
                        getNetworkIcon(context),
                        const SpaceW12(),
                        Flexible(
                          child: Baseline(
                            baseline: 18,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              widget.method.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: sSubtitle2Style,
                            ),
                          ),
                        ),
                        const SpaceW19(), // 1 px border
                      ],
                    ),
                  ],
                ),
              ),
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

  Widget getNetworkIcon(BuildContext context) {
    switch (SendGloballyAmountStore.of(context).cardNetwork) {
      case CircleCardNetwork.VISA:
        return const SVisaCardIcon(
          width: 40,
          height: 25,
        );
      case CircleCardNetwork.MASTERCARD:
        return const SMasterCardIcon(
          width: 40,
          height: 25,
        );
      default:
        return SizedBox(
          width: 40,
          height: 25,
          child: Center(
            child: SActionDepositIcon(
              color: sKit.colors.blue,
            ),
          ),
        );
    }
  }
}
