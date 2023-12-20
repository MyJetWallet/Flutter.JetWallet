import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../pin_screen/model/pin_flow_union.dart';

@RoutePage(name: 'WithdrawalPreviewRouter')
class WithdrawalPreviewScreen extends StatefulObserverWidget {
  const WithdrawalPreviewScreen({super.key});

  @override
  State<WithdrawalPreviewScreen> createState() => _WithdrawalPreviewScreenState();
}

class _WithdrawalPreviewScreenState extends State<WithdrawalPreviewScreen> {
  @override
  void initState() {
    final store = WithdrawalStore.of(context);

    sAnalytics.cryptoSendOrderSummarySend(
      asset: store.withdrawalInputModel!.currency!.symbol,
      network: store.network.description,
      sendMethodType: '0',
      totalSendAmount: store.withAmount,
      paymentFee: store.addressIsInternal
          ? intl.noFee
          : store.withdrawalInputModel!.currency!.withdrawalFeeWithSymbol(
              store.networkController.text,
            ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final store = WithdrawalStore.of(context);

    final matic = currencyFrom(
      sSignalRModules.currenciesList,
      store.nftInfo?.feeAssetSymbol ?? 'MATIC',
    );

    final isUserEnoughMaticForWithdraw =
        store.withdrawalType != WithdrawalType.nft || matic.assetBalance > (store.nftInfo?.feeAmount ?? Decimal.zero);

    return SPageFrameWithPadding(
      loaderText: intl.register_pleaseWait,
      loading: store.previewLoader,
      customLoader: store.withdrawalType == WithdrawalType.nft
          ? store.previewIsProcessing
              ? WaitingScreen(
                  onSkip: () {},
                )
              : null
          : null,
      header: SSmallHeader(
        title: intl.buy_confirmation_title,
        subTitle: intl.sendOptions_send,
        subTitleStyle: sBodyText2Style.copyWith(
          color: sKit.colors.grey1,
        ),
        onBackButtonTap: () {
          sRouter.back();
        },
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
                    assetIconUrl: store.withdrawalInputModel!.currency!.iconUrl,
                    assetDescription: store.withdrawalInputModel!.currency!.description,
                    assetValue: store.addressIsInternal
                        ? store.withAmount
                        : volumeFormat(
                            decimal: Decimal.parse(store.withAmount) -
                                store.withdrawalInputModel!.currency!.withdrawalFeeSize(
                                  store.networkController.text,
                                ),
                            accuracy: store.withdrawalInputModel!.currency!.accuracy,
                            symbol: store.withdrawalInputModel!.currency!.symbol,
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
                  value: store.address,
                  needHorizontalPadding: false,
                ),
                TwoColumnCell(
                  label: intl.cryptoDeposit_network,
                  value: store.networkController.text,
                  needHorizontalPadding: false,
                ),
                TwoColumnCell(
                  label: intl.operationName_sent,
                  value:
                      '''${store.withAmount} ${store.withdrawalType == WithdrawalType.asset ? store.withdrawalInputModel!.currency!.symbol : store.withdrawalInputModel!.nft!.name}''',
                  needHorizontalPadding: false,
                ),
                TwoColumnCell(
                  label: intl.send_globally_processing_fee,
                  value: store.addressIsInternal
                      ? intl.noFee
                      : store.withdrawalInputModel!.currency!.withdrawalFeeWithSymbol(
                          store.networkController.text,
                        ),
                  needHorizontalPadding: false,
                ),
                const SpaceH16(),
                const SDivider(),
                const SpaceH32(),
                SPrimaryButton2(
                  active: !store.previewLoading && isUserEnoughMaticForWithdraw,
                  name: intl.withdrawalPreview_confirm,
                  onTap: () {
                    sAnalytics.cryptoSendTapConfirmOrder(
                      asset: store.withdrawalInputModel!.currency!.symbol,
                      network: store.network.description,
                      sendMethodType: '0',
                      totalSendAmount: store.withAmount,
                      paymentFee: store.addressIsInternal
                          ? intl.noFee
                          : store.withdrawalInputModel!.currency!.withdrawalFeeWithSymbol(
                              store.networkController.text,
                            ),
                    );

                    sRouter.push(
                      PinScreenRoute(
                        union: const Change(),
                        isChangePhone: true,
                        onChangePhone: (String newPin) {
                          sAnalytics.cryptoSendBioApprove(
                            asset: store.withdrawalInputModel!.currency!.symbol,
                            network: store.network.description,
                            sendMethodType: '0',
                            totalSendAmount: store.withAmount,
                            paymentFee: store.addressIsInternal
                                ? intl.noFee
                                : store.withdrawalInputModel!.currency!.withdrawalFeeWithSymbol(
                                    store.networkController.text,
                                  ),
                          );

                          sRouter.pop();

                          store.withdraw(newPin: newPin);
                        },
                        onWrongPin: (String error) {
                          sAnalytics.errorWrongPin(
                            asset: store.withdrawalInputModel!.currency!.symbol,
                            errorText: error,
                            sendMethod: AnalyticsSendMethods.cryptoWallet,
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
  }
}
