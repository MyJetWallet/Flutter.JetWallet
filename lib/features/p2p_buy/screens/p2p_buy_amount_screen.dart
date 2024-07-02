import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/prevent_duplication_events_servise.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';
import 'package:jetwallet/features/p2p_buy/store/buy_p2p_amount_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/wallet_api/models/p2p_methods/p2p_methods_responce_model.dart';
import 'package:visibility_detector/visibility_detector.dart';

@RoutePage(name: 'P2PBuyAmountRouter')
class P2PBuyAmountScreen extends StatelessWidget {
  const P2PBuyAmountScreen({
    super.key,
    required this.currency,
    required this.paymentCurrecy,
    required this.p2pMethod,
  });

  final CurrencyModel currency;
  final PaymentAsset paymentCurrecy;
  final P2PMethodModel p2pMethod;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;

    return VisibilityDetector(
      key: const Key('P2PBuyAmountScreen'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          getIt.get<PreventDuplicationEventsService>().sendEvent(
                id: 'P2PBuyAmountScreen',
                event: () {
                  sAnalytics.buyAmountScreenView(
                    destinationWallet: currency.symbol,
                    pmType: PaymenthMethodType.ptp,
                    buyPM: 'PTP',
                    sourceCurrency: paymentCurrecy.asset,
                  );
                },
              );
        }
      },
      child: Provider<BuyP2PAmountStore>(
        create: (context) => BuyP2PAmountStore()
          ..init(
            inputAsset: currency,
            inputP2pMethod: p2pMethod,
            inputPaymentAsset: paymentCurrecy,
          ),
        builder: (context, child) {
          final store = BuyP2PAmountStore.of(context);

          return SPageFrame(
            loaderText: '',
            header: SPaddingH24(
              child: SSmallHeader(
                title: intl.operationName_buy,
                onBackButtonTap: () {
                  sAnalytics.tapOnTheBackFromAmountScreenButton(
                    destinationWallet: currency.symbol,
                    pmType: PaymenthMethodType.ptp,
                    buyPM: 'PTP',
                    sourceCurrency: paymentCurrecy.asset,
                  );
                  sRouter.maybePop();
                },
              ),
            ),
            child: Observer(
              builder: (context) {
                return Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        physics: const ClampingScrollPhysics(),
                        slivers: [
                          SliverFillRemaining(
                             hasScrollBody: false,
                            child: Column(
                              children: [
                                deviceSize.when(
                                  small: () => const SpaceH40(),
                                  medium: () => const Spacer(),
                                ),
                                SNewActionPriceField(
                                  widgetSize: widgetSizeFrom(deviceSize),
                                  primaryAmount: formatCurrencyStringAmount(
                                    value: store.primaryAmount,
                                  ),
                                  primarySymbol: store.primarySymbol,
                                  secondaryAmount: store.asset != null
                                      ? '${intl.earn_est} ${volumeFormat(
                                          decimal: Decimal.parse(store.secondaryAmount),
                                          symbol: '',
                                          accuracy: store.secondaryAccuracy,
                                        )}'
                                      : null,
                                  secondarySymbol: store.asset != null ? store.secondarySymbol : null,
                                  onSwap: () {
                                    store.swapAssets();
                                    sAnalytics.tapOnTheChangeInputBuyButton(
                                      pmType: PaymenthMethodType.ptp,
                                      buyPM: 'PTP',
                                      sourceCurrency: store.paymentAsset?.asset ?? '',
                                      destinationWallet: store.asset?.symbol ?? '',
                                      nowInput: store.isFiatEntering ? NowInputType.fiat : NowInputType.crypro,
                                    );
                                  },
                                  errorText: store.paymentMethodInputError,
                                  optionText: store.fiatInputValue == '0'
                                      ? '''${intl.p2p_buy_max} ${getIt<AppStore>().isBalanceHide ? '**** ${store.asset?.symbol}' : volumeFormat(decimal: store.maxBuyAmount, accuracy: store.asset?.accuracy ?? 1, symbol: store.asset?.symbol ?? '')}'''
                                      : null,
                                  optionOnTap: () {
                                    store.onBuyAll();
                                  },
                                  pasteLabel: intl.paste,
                                  onPaste: () async {
                                    final data = await Clipboard.getData('text/plain');

                                    if (data?.text != null) {
                                      final n = double.tryParse(data!.text!);
                                      if (n != null) {
                                        store.pasteValue(n.toString().trim());
                                      }
                                    }
                                  },
                                ),
                                const Spacer(),
                                SuggestionButtonWidget(
                                  title: store.asset?.description,
                                  subTitle: intl.amount_screen_buy,
                                  icon: SNetworkSvg24(
                                    url: store.asset?.iconUrl ?? '',
                                  ),
                                  showArrow: false,
                                  onTap: () {},
                                ),
                                const SpaceH8(),
                                SuggestionButtonWidget(
                                  title: store.p2pMethod?.name,
                                  subTitle: intl.p2p_buy_with,
                                  icon: SNetworkCachedSvg(
                                    url: iconForPaymentMethod(
                                      methodId: store.p2pMethod?.methodId ?? '',
                                    ),
                                    width: 24,
                                    height: 24,
                                    placeholder: const SizedBox(),
                                  ),
                                  showArrow: false,
                                  onTap: () {},
                                ),
                                const SpaceH20(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SNumericKeyboardAmount(
                      widgetSize: widgetSizeFrom(deviceSize),
                      onKeyPressed: (value) {
                        store.updateInputValue(value);
                      },
                      buttonType: SButtonType.primary2,
                      submitButtonActive: store.isContinueAvaible,
                      submitButtonName: intl.addCircleCard_continue,
                      onSubmitPressed: () {
                        sAnalytics.tapOnTheContinueWithBuyAmountButton(
                          pmType: PaymenthMethodType.ptp,
                          buyPM: 'PTP',
                          sourceCurrency: store.paymentAsset?.asset ?? '',
                          destinationWallet: store.asset?.symbol ?? '',
                          sourceBuyAmount: store.fiatInputValue,
                          destinationBuyAmount: store.cryptoInputValue,
                        );
                        sRouter.push(
                          BuyP2PConfirmationRoute(
                            asset: store.asset!,
                            paymentAsset: store.paymentAsset!,
                            p2pMethod: store.p2pMethod!,
                            isFromFixed: store.isFiatEntering,
                            fromAmount: store.fiatInputValue,
                            toAmount: store.cryptoInputValue,
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
