import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/send_gift/model/send_gift_info_model.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../core/l10n/i10n.dart';
import '../../pin_screen/model/pin_flow_union.dart';
import '../store/general_send_gift_store.dart';

@RoutePage(name: 'GiftOrderSummuryRouter')
class GiftOrderSummury extends StatefulWidget {
  const GiftOrderSummury({super.key, required this.sendGiftInfo});

  final SendGiftInfoModel sendGiftInfo;

  @override
  State<GiftOrderSummury> createState() => _GiftOrderSummuryState();
}

class _GiftOrderSummuryState extends State<GiftOrderSummury> {
  late final GeneralSendGiftStore sendGiftStore;

  @override
  void initState() {
    super.initState();
    sendGiftStore = GeneralSendGiftStore()..init(widget.sendGiftInfo);
  }

  @override
  Widget build(BuildContext context) {
    final formatService = getIt.get<FormatService>();

    return Observer(
      builder: (context) {
        return SPageFrameWithPadding(
          loaderText: intl.loader_please_wait,
          loading: sendGiftStore.loader,
          customLoader: const WaitingScreen(),
          header: SSmallHeader(
            title: intl.buy_confirmation_title,
            subTitle: intl.send_gift_small_title,
            subTitleStyle: sBodyText2Style.copyWith(
              color: sKit.colors.grey1,
            ),
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: AssetRowWidget(
                        isLoading: false,
                        assetIconUrl: sendGiftStore.currency.iconUrl,
                        assetDescription: sendGiftStore.currency.description,
                        assetValue: sendGiftStore.amount.toFormatCount(
                          accuracy: sendGiftStore.currency.accuracy,
                          symbol: sendGiftStore.currency.symbol,
                        ),
                        assetBaseAmount: formatService
                            .convertOneCurrencyToAnotherOne(
                              fromCurrency: sendGiftStore.currency.symbol,
                              fromCurrencyAmmount: sendGiftStore.amount,
                              toCurrency: sSignalRModules.baseCurrency.symbol,
                              baseCurrency: sSignalRModules.baseCurrency.symbol,
                              isMin: false,
                            )
                            .toFormatCount(
                              accuracy: sSignalRModules.baseCurrency.accuracy,
                              symbol: sSignalRModules.baseCurrency.symbol,
                            ),
                      ),
                    ),
                    const SDivider(),
                    const SpaceH16(),
                    TwoColumnCell(
                      label: intl.date,
                      value: DateFormat('dd.MM.yyyy, hh:mm').format(DateTime.now()),
                      needHorizontalPadding: false,
                    ),
                    TwoColumnCell(
                      label: intl.to1,
                      value: sendGiftStore.receiverContact,
                      needHorizontalPadding: false,
                    ),
                    TwoColumnCell(
                      label: intl.operationName_sent,
                      value: sendGiftStore.amount.toFormatCount(
                        accuracy: sendGiftStore.currency.accuracy,
                        symbol: sendGiftStore.currency.symbol,
                      ),
                      needHorizontalPadding: false,
                    ),
                    ProcessingFeeRowWidget(
                      fee: (sendGiftStore.currency.fees.withdrawalFee?.size ?? Decimal.zero).toFormatCount(
                        accuracy: sendGiftStore.currency.accuracy,
                        symbol: sendGiftStore.currency.symbol,
                      ),
                      onTabListener: () {},
                      onBotomSheetClose: (_) {},
                      needPadding: true,
                    ),
                    const SpaceH16(),
                    const SDivider(),
                    const SpaceH32(),
                    SPrimaryButton2(
                      active: true,
                      name: intl.previewBuyWithAsset_confirm,
                      onTap: () {
                        sAnalytics.tapOnTheButtonConfirmOrderSummarySend(
                          giftSubmethod: sendGiftStore.selectedContactType.name,
                          asset: sendGiftStore.currency.symbol,
                          totalSendAmount: sendGiftStore.amount.toString(),
                          paymentFee: (sendGiftStore.currency.fees.withdrawalFee?.size ?? Decimal.zero).toFormatCount(
                            accuracy: sendGiftStore.currency.accuracy,
                            symbol: sendGiftStore.currency.symbol,
                          ),
                        );

                        sRouter.push(
                          PinScreenRoute(
                            union: const Change(),
                            isChangePhone: true,
                            onChangePhone: (String newPin) async {
                              await sendGiftStore.confirmSendGift(
                                newPin: newPin,
                              );
                            },
                            onWrongPin: (error) {
                              sAnalytics.errorWrongPin(
                                asset: sendGiftStore.currency.symbol,
                                giftSubmethod: sendGiftStore.selectedContactType.name,
                                errorText: error,
                                sendMethod: AnalyticsSendMethods.gift,
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
