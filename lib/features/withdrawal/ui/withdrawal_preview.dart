import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

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

    if (store.withdrawalType == WithdrawalType.jar) {
      sAnalytics.jarScreenViewOrderSummaryWithdrawJar(
        asset: store.withdrawalInputModel!.jar!.assetSymbol,
        network: 'TRC20',
        target: store.withdrawalInputModel!.jar!.target.toInt(),
        balance: store.withdrawalInputModel!.jar!.balanceInJarAsset,
        isOpen: store.withdrawalInputModel!.jar!.status == JarStatus.active,
      );
    }

    if (store.withdrawalType == WithdrawalType.asset) {
      sAnalytics.cryptoSendOrderSummarySend(
        asset: store.withdrawalInputModel!.currency!.symbol,
        network: store.network.description,
        sendMethodType: '0',
        totalSendAmount: store.withAmount,
        paymentFee: store.withdrawalInputModel!.currency!
            .withdrawalFeeSize(
              network: store.getNetworkForFee(),
              amount: Decimal.parse(store.withAmount),
            )
            .toString(),
      );
    }

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

    final formatService = getIt.get<FormatService>();

    final feeSize = store.feeAmount;

    final feeSizeWithSymbol = feeSize.toFormatCount(
      symbol: store.withdrawalInputModel?.currency?.symbol ?? '',
      accuracy: store.withdrawalInputModel?.currency?.accuracy ?? 2,
    );
    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      loading: store.previewLoader,
      customLoader: store.withdrawalType == WithdrawalType.nft
          ? store.previewIsProcessing
              ? const WaitingScreen()
              : null
          : null,
      header: GlobalBasicAppBar(
        title: intl.buy_confirmation_title,
        subtitle: intl.sendOptions_send,
        hasRightIcon: false,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  STransaction(
                    isLoading: false,
                    hasSecondAsset: false,
                    fromAssetIconUrl: store.withdrawalInputModel!.currency!.iconUrl,
                    fromAssetDescription: store.withdrawalInputModel!.currency!.description,
                    fromAssetValue: store.youSendAmount.toFormatCount(
                      accuracy: store.withdrawalInputModel!.currency!.accuracy,
                      symbol: store.withdrawalInputModel!.currency!.symbol,
                    ),
                    fromAssetBaseAmount: formatService
                        .convertOneCurrencyToAnotherOne(
                          fromCurrency: store.withdrawalInputModel!.currency!.symbol,
                          fromCurrencyAmmount: store.youSendAmount,
                          toCurrency: sSignalRModules.baseCurrency.symbol,
                          baseCurrency: sSignalRModules.baseCurrency.symbol,
                          isMin: false,
                        )
                        .toFormatSum(
                          accuracy: sSignalRModules.baseCurrency.accuracy,
                          symbol: sSignalRModules.baseCurrency.symbol,
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
                    valueMaxLines: 3,
                  ),
                  TwoColumnCell(
                    label: intl.cryptoDeposit_network,
                    value: store.networkController.text,
                    needHorizontalPadding: false,
                  ),
                  TwoColumnCell(
                    label: intl.withdrawal_recipient_gets,
                    value:
                        '''${store.recepientGetsAmount} ${store.withdrawalType != WithdrawalType.nft ? store.withdrawalInputModel!.currency!.symbol : store.withdrawalInputModel!.nft!.name}''',
                    needHorizontalPadding: false,
                  ),
                  ProcessingFeeRowWidget(
                    fee: feeSize == Decimal.zero ? intl.noFee : feeSizeWithSymbol,
                    onTabListener: () {},
                    onBotomSheetClose: (_) {},
                    needPadding: true,
                  ),
                  const SpaceH16(),
                  const SDivider(),
                  const SpaceH32(),
                  SButton.blue(
                    text: intl.withdrawalPreview_confirm,
                    callback: !store.previewLoading && isUserEnoughMaticForWithdraw && !store.previewError
                        ? () {
                            if (store.withdrawalType == WithdrawalType.jar) {
                              sAnalytics.jarTapOnButtonConfirmJarWithdrawOnOrderSummary(
                                asset: store.withdrawalInputModel!.jar!.assetSymbol,
                                network: 'TRC20',
                                target: store.withdrawalInputModel!.jar!.target.toInt(),
                                balance: store.withdrawalInputModel!.jar!.balanceInJarAsset,
                                isOpen: store.withdrawalInputModel!.jar!.status == JarStatus.active,
                              );
                            } else {
                              sAnalytics.cryptoSendTapConfirmOrder(
                                asset: store.withdrawalInputModel!.currency!.symbol,
                                network: store.network.description,
                                sendMethodType: '0',
                                totalSendAmount: store.withAmount,
                                paymentFee: feeSize == Decimal.zero ? intl.noFee : feeSizeWithSymbol,
                              );
                            }

                            sRouter.push(
                              PinScreenRoute(
                                union: const Change(),
                                isChangePhone: true,
                                onChangePhone: (String newPin) {
                                  if (store.withdrawalType == WithdrawalType.jar) {
                                    sRouter.maybePop();

                                    store.withdrawJar(newPin: newPin);
                                  } else {
                                    sAnalytics.cryptoSendBioApprove(
                                      asset: store.withdrawalInputModel!.currency!.symbol,
                                      network: store.network.description,
                                      sendMethodType: '0',
                                      totalSendAmount: store.withAmount,
                                      paymentFee: feeSize == Decimal.zero ? intl.noFee : feeSizeWithSymbol,
                                    );

                                    sRouter.maybePop();

                                    store.withdraw(newPin: newPin);
                                  }
                                },
                                onWrongPin: (String error) {},
                              ),
                            );
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
