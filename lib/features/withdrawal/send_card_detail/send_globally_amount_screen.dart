import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/store/send_globally_amount_store.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/utils/send_globally_limits.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/global_send_methods_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_request_model.dart';

import '../../../core/di/di.dart';
import '../../../utils/formatting/base/market_format.dart';
import '../../app/store/app_store.dart';
import 'widgets/payment_method_card.dart';

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
      create: (context) => SendGloballyAmountStore()..setCardNumber(data, method),
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
  State<SendGloballyAmountScreenBody> createState() => _SendGloballyAmountScreenBodyState();
}

class _SendGloballyAmountScreenBodyState extends State<SendGloballyAmountScreenBody> {
  @override
  void initState() {
    super.initState();

    final store = SendGloballyAmountStore.of(context);

    sAnalytics.globalSendAmountScreenView(
      asset: widget.data.asset ?? '',
      sendMethodType: '1',
      destCountry: widget.data.countryCode ?? '',
      paymentMethod: store.method?.name ?? '',
      globalSendType: widget.method.methodId ?? '',
    );

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
      header: GlobalBasicAppBar(
        title: intl.send_globally,
        subtitle: '${intl.withdrawalAmount_available}: '
            '${getIt<AppStore>().isBalanceHide ? '**** ${store.sendCurrency!.symbol}' : volumeFormat(
                decimal: store.availableBalabce,
                accuracy: store.sendCurrency!.accuracy,
                symbol: store.sendCurrency!.symbol,
              )}',
        hasRightIcon: false,
      ),
      child: Column(
        children: [
          const Spacer(),
          Baseline(
            baseline: deviceSize.when(
              small: () => 20,
              medium: () => 48,
            ),
            baselineType: TextBaseline.alphabetic,
            child: SActionPriceField(
              widgetSize: widgetSizeFrom(deviceSize),
              price: formatCurrencyStringAmount(
                value: store.withAmount,
                symbol: store.sendCurrency!.symbol,
              ),
              helper: '≈ ${marketFormat(
                accuracy: store.baseCurrency.accuracy,
                decimal: Decimal.parse(store.baseConversionValue),
                symbol: store.baseCurrency.symbol,
              )}',
              error: store.withAmmountInputError == InputError.limitError
                  ? store.limitError
                  : store.withAmmountInputError.value(),
              isErrorActive: store.withAmmountInputError.isActive,
              pasteLabel: intl.paste,
              onPaste: () async {
                final data = await Clipboard.getData('text/plain');
                if (data?.text != null) {
                  final n = double.tryParse(data!.text!);
                  if (n != null) {
                    store.pasteAmount(n.toString().trim());
                  }
                }
              },
            ),
          ),
          const Spacer(),
          SPaddingH24(
            child: InkWell(
              onTap: () {
                sAnalytics.globalSendAmountLimitsSV(
                  asset: widget.data.asset ?? '',
                  sendMethodType: '1',
                  destCountry: widget.data.countryCode ?? '',
                  paymentMethod: store.method?.name ?? '',
                  globalSendType: widget.method.methodId ?? '',
                );

                showGlobalSendLimits(
                  context: context,
                  minAmount: store.minLimitAmount,
                  maxAmount: store.maxLimitAmount,
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
                      children: [
                        const SpaceW19(), // 1 px border
                        if (store.cardNetwork != CircleCardNetwork.unsupported) ...[
                          getNetworkIcon(context),
                        ] else ...[
                          SNetworkCachedSvg(
                            url: iconForPaymentMethod(
                              methodId: store.method?.methodId ?? '',
                            ),
                            width: 30,
                            height: 30,
                            placeholder: MethodPlaceholder(
                              name: widget.method.name ?? 'M',
                            ),
                          ),
                        ],
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
            onKeyPressed: (value) {
              store.updateAmount(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: store.withValid && store.withAmmountInputError == InputError.none,
            submitButtonName: intl.addCircleCard_continue,
            onSubmitPressed: () {
              sAnalytics.globalSendContinueAmountSc(
                asset: widget.data.asset ?? '',
                sendMethodType: '1',
                destCountry: widget.data.countryCode ?? '',
                paymentMethod: store.method?.name ?? '',
                globalSendType: widget.method.methodId ?? '',
                totalSendAmount: store.withAmount,
                preset: 'false',
              );

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
