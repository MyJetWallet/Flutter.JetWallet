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
              network: store.networkController.text,
              amount: Decimal.parse(store.withAmount),
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

    final formatService = getIt.get<FormatService>();

    final feeSize = store.withdrawalInputModel!.currency!.withdrawalFeeSize(
      network: store.addressIsInternal ? 'internal-send' : store.networkController.text,
      amount: Decimal.parse(store.withAmount),
    );

    final feeSizeWithSymbol = feeSize.toFormatCount(
      symbol: store.withdrawalInputModel?.currency?.symbol ?? '',
      accuracy: store.withdrawalInputModel?.currency?.accuracy ?? 2,
    );
    return SPageFrameWithPadding(
      loaderText: intl.register_pleaseWait,
      loading: store.previewLoader,
      customLoader: store.withdrawalType == WithdrawalType.nft
          ? store.previewIsProcessing
              ? const WaitingScreen()
              : null
          : null,
      header: SSmallHeader(
        title: intl.buy_confirmation_title,
        subTitle: intl.sendOptions_send,
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
                    assetIconUrl: store.withdrawalInputModel!.currency!.iconUrl,
                    assetDescription: store.withdrawalInputModel!.currency!.description,
                    assetValue: store.addressIsInternal
                        ? Decimal.parse(store.withAmount).toFormatCount(
                            accuracy: store.withdrawalInputModel!.currency!.accuracy,
                            symbol: store.withdrawalInputModel!.currency!.symbol,
                          )
                        : (Decimal.parse(store.withAmount) + feeSize).toFormatCount(
                            accuracy: store.withdrawalInputModel!.currency!.accuracy,
                            symbol: store.withdrawalInputModel!.currency!.symbol,
                          ),
                    assetBaseAmount: formatService
                        .convertOneCurrencyToAnotherOne(
                          fromCurrency: store.withdrawalInputModel!.currency!.symbol,
                          fromCurrencyAmmount: store.addressIsInternal
                              ? Decimal.parse(store.withAmount)
                              : Decimal.parse(store.withAmount) + feeSize,
                          toCurrency: sSignalRModules.baseCurrency.symbol,
                          baseCurrency: sSignalRModules.baseCurrency.symbol,
                          isMin: false,
                        )
                        .toFormatSum(
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
                      '''${store.withAmount} ${store.withdrawalType == WithdrawalType.asset ? store.withdrawalInputModel!.currency!.symbol : store.withdrawalInputModel!.nft!.name}''',
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
                SPrimaryButton2(
                  active: !store.previewLoading && isUserEnoughMaticForWithdraw,
                  name: intl.withdrawalPreview_confirm,
                  onTap: () {
                    sAnalytics.cryptoSendTapConfirmOrder(
                      asset: store.withdrawalInputModel!.currency!.symbol,
                      network: store.network.description,
                      sendMethodType: '0',
                      totalSendAmount: store.withAmount,
                      paymentFee: store.addressIsInternal ? intl.noFee : feeSizeWithSymbol,
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
                            paymentFee: store.addressIsInternal ? intl.noFee : feeSizeWithSymbol,
                          );

                          sRouter.maybePop();

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
