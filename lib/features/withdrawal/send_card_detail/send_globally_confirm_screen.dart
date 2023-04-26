import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/store/send_globally_confirm_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_card_response.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_request_model.dart';

@RoutePage(name: 'SendGloballyConfirmRouter')
class SendGloballyConfirmScreen extends StatelessWidget {
  const SendGloballyConfirmScreen({
    super.key,
    required this.data,
  });

  final SendToBankCardResponse data;

  @override
  Widget build(BuildContext context) {
    return Provider<SendGloballyConfirmStore>(
      create: (context) => SendGloballyConfirmStore(),
      builder: (context, child) => SendGloballyConfirmScreenBody(
        data: data,
      ),
    );
  }
}

class SendGloballyConfirmScreenBody extends StatelessObserverWidget {
  const SendGloballyConfirmScreenBody({
    super.key,
    required this.data,
  });

  final SendToBankCardResponse data;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final state = SendGloballyConfirmStore.of(context);

    return SPageFrameWithPadding(
      loading: state.loader,
      customLoader: WaitingScreen(
        onSkip: () {},
      ),
      header: const SSmallHeader(
        isShortVersion: true,
        title: '',
      ),
      child: Stack(
        children: [
          ListView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.only(
              bottom: widgetSizeFrom(deviceSize) == SWidgetSize.small
                  ? 310.0
                  : 260.0,
            ),
            children: [
              Column(
                children: [
                  deviceSize.when(
                    small: () => const SpaceH8(),
                    medium: () => const SpaceH3(),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          disclaimerAsset,
                          width: 80,
                          height: 80,
                        ),
                        const SpaceH16(),
                        Text(
                          intl.previewBuy_orderSummary,
                          style: sTextH5Style,
                        ),
                        const SpaceH34(),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colors.blueLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: SProfileDetailsIcon(),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              'Receiver will get ≈ ${data.estimatedReceiveAmount!} UAH',
                              style: sSubtitle3Style,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SActionConfirmText(
                    name: intl.send_globally_date,
                    value: DateFormat('dd.MM.y, HH:mm').format(DateTime.now()),
                  ),
                  SActionConfirmText(
                    name: intl.send_globally_card,
                    value: data.cardNumber!,
                  ),
                  SActionConfirmText(
                    name: intl.send_globally_con_rate,
                    contentLoading: state.loader.loading,
                    value:
                        '${state.eurCurrency.prefixSymbol}1 = ${data.estimatedPrice} UAH',
                  ),
                  SActionConfirmText(
                    name: intl.send_globally_processing_fee,
                    value: volumeFormat(
                      prefix: state.eurCurrency.prefixSymbol,
                      decimal: data.feeAmount ?? Decimal.zero,
                      accuracy: state.eurCurrency.accuracy,
                      symbol: state.eurCurrency.symbol,
                    ),
                    maxValueWidth: 140,
                  ),
                  const SpaceH17(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      intl.send_globally_transfer_info,
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      style: sCaptionTextStyle.copyWith(
                        color: colors.grey3,
                      ),
                    ),
                  ),
                  const SpaceH15(),
                  deviceSize.when(
                    small: () {
                      return const SizedBox();
                    },
                    medium: () {
                      return Column(
                        children: [
                          const SDivider(),
                          SActionConfirmText(
                            name: intl.currencyBuy_total,
                            contentLoading: state.loader.loading,
                            valueColor: colors.blue,
                            value: volumeFormat(
                              prefix: state.eurCurrency.prefixSymbol,
                              decimal: data.amount ?? Decimal.zero,
                              accuracy: state.eurCurrency.accuracy,
                              symbol: state.eurCurrency.symbol,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SpaceH20(),
                ],
              ),
            ],
          ),
          SFloatingButtonFrame(
            hidePadding: true,
            button: Column(
              children: [
                deviceSize.when(
                  small: () {
                    return Column(
                      children: [
                        const SDivider(),
                        SActionConfirmText(
                          name: intl.currencyBuy_total,
                          contentLoading: state.loader.loading,
                          valueColor: colors.blue,
                          value: 'test',
                        ),
                      ],
                    );
                  },
                  medium: () {
                    return const SizedBox();
                  },
                ),
                const SpaceH20(),
                const SpaceH24(),
                SPrimaryButton2(
                  active: true,
                  name: intl.previewBuyWithAsset_confirm,
                  onTap: () {
                    state.confirmSendGlobally(
                      SendToBankRequestModel(
                        countryCode: 'UA',
                        cardNumber: data.cardNumber,
                        asset: 'EUR',
                        amount: data.amount,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
