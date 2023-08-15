import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/l10n/i10n.dart';
import '../../pin_screen/model/pin_flow_union.dart';
import '../store/general_send_gift_store.dart';
import '../widgets/simple_action_confirm_text_with_icon.dart';

@RoutePage(name: 'GiftOrderSummuryRouter')
class GiftOrderSummury extends StatelessWidget {
  const GiftOrderSummury({super.key, required this.sendGiftStore});
  final GeneralSendGiftStore sendGiftStore;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return SPageFrameWithPadding(
          loading: sendGiftStore.loader,
          customLoader: WaitingScreen(
            primaryText: intl.waitingScreen_processing,
            onSkip: () {},
          ),
          header: SSmallHeader(
            title: intl.send_gift_order_summary,
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          intl.send_gift_your_gift,
                          style: const TextStyle(
                            color: Color(0xFF777C85),
                            fontSize: 16,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          volumeFormat(
                            prefix: sendGiftStore.currency.prefixSymbol,
                            decimal: sendGiftStore.amount,
                            accuracy: sendGiftStore.currency.accuracy,
                            symbol: sendGiftStore.currency.symbol,
                          ),
                          style: const TextStyle(
                            color: Color(0xFF374CFA),
                            fontSize: 24,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SpaceH24(),
                    const SDivider(),
                    const SpaceH19(),
                    SActionConfirmText(
                      name: intl.to1,
                      value: sendGiftStore.receiverContact,
                      baseline: 24,
                    ),
                    const SpaceH16(),
                    SActionConfirmTextWiyhIcon(
                      name: intl.send_gift_payment_method,
                      value: intl.send_gift_simple_gift,
                      baseline: 24,
                      icon: const SizedBox(
                        width: 16,
                        height: 16,
                        child: SGiftSendIcon(),
                      ),
                    ),
                    const SpaceH16(),
                    SActionConfirmText(
                      name: intl.fee,
                      value: volumeFormat(
                        prefix: sendGiftStore.currency.prefixSymbol,
                        decimal:
                            sendGiftStore.currency.fees.withdrawalFee?.size ??
                                Decimal.zero,
                        accuracy: sendGiftStore.currency.accuracy,
                        symbol: sendGiftStore.currency.symbol,
                      ),
                      baseline: 24,
                    ),
                    const SpaceH19(),
                    const SDivider(),
                    const SpaceH19(),
                    SActionConfirmText(
                      name: intl.send_gift_total_pay,
                      value: volumeFormat(
                        prefix: sendGiftStore.currency.prefixSymbol,
                        decimal: sendGiftStore.amount,
                        accuracy: sendGiftStore.currency.accuracy,
                        symbol: sendGiftStore.currency.symbol,
                      ),
                      baseline: 24,
                      valueColor: const Color(0xFF374CFA),
                    ),
                    const SpaceH56(),
                    SPrimaryButton2(
                      active: true,
                      name: intl.previewBuyWithAsset_confirm,
                      onTap: () {
                        sAnalytics.tapOnTheButtonConfirmOrderSummarySend(
                          giftSubmethod: sendGiftStore.selectedContactType.name,
                          asset: sendGiftStore.currency.symbol,
                          totalSendAmount: sendGiftStore.amount.toString(),
                          paymentFee: volumeFormat(
                            prefix: sendGiftStore.currency.prefixSymbol,
                            decimal: sendGiftStore
                                    .currency.fees.withdrawalFee?.size ??
                                Decimal.zero,
                            accuracy: sendGiftStore.currency.accuracy,
                            symbol: sendGiftStore.currency.symbol,
                          ),
                        );
                        sAnalytics.confirmWithPINScreenView();
                        sRouter.push(
                          PinScreenRoute(
                            union: const Change(),
                            isChangePhone: true,
                            onChangePhone: (String newPin) async {
                              await sRouter.pop();
                              await sendGiftStore.confirmSendGift(
                                newPin: newPin,
                              );
                            },
                            onError: () {
                              sAnalytics.errorWrongPin(
                                asset: sendGiftStore.currency.symbol,
                                giftSubmethod:
                                    sendGiftStore.selectedContactType.name,
                              );
                            },
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
      },
    );
  }
}
