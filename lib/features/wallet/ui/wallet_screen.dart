import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/wallet/ui/widgets/action_button/action_button.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/wallet_body.dart';
import 'package:jetwallet/utils/helpers/contains_single_element.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/l10n/i10n.dart';
import '../../../core/router/app_router.dart';
import '../../../widgets/circle_action_buttons/circle_action_buy.dart';
import '../../../widgets/circle_action_buttons/circle_action_exchange.dart';
import '../../../widgets/circle_action_buttons/circle_action_receive.dart';
import '../../../widgets/circle_action_buttons/circle_action_send.dart';
import '../../actions/action_send/widgets/send_options.dart';
import '../../actions/circle_actions/circle_actions.dart';
import '../../kyc/helper/kyc_alert_handler.dart';
import '../../kyc/kyc_service.dart';
import '../../kyc/models/kyc_operation_status_model.dart';
import '../../market/market_details/ui/widgets/balance_block/components/balance_action_buttons.dart';
import '../../market/model/market_item_model.dart';

class Wallet extends StatefulObserverWidget {
  const Wallet({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late AnimationController _animationController;
  late PageController _pageController;
  late CurrencyModel currentAsset;

  @override
  void initState() {
    super.initState();

    // animationController intentionally is not disposed,
    // because bottomSheet will dispose it on its own
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    final itemsWithBalance = nonIndicesWithBalanceFrom(
      currenciesWithBalanceFrom(
        sSignalRModules.currenciesList,
      ),
    );
    final initialPage = itemsWithBalance.indexOf(widget.currency);
    currentAsset = widget.currency;

    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final colors = sKit.colors;
    final currencies = sSignalRModules.currenciesList;
    final currenciesWithBalance = nonIndicesWithBalanceFrom(
      currenciesWithBalanceFrom(currencies),
    );
    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    return Scaffold(
      bottomNavigationBar: Material(
        color: colors.white,
        child: SizedBox(
          height: 127,
          child: Column(
            children: [
              const SDivider(),
              const SpaceH16(),
              CircleActionButtons(
                showBuy: currentAsset.supportsAtLeastOneBuyMethod,
                showReceive: currentAsset.supportsCryptoDeposit,
                showExchange: currentAsset.isAssetBalanceNotEmpty,
                showSend: currentAsset.isAssetBalanceNotEmpty &&
                    currentAsset.supportsCryptoWithdrawal,
                onBuy: () {
                  sAnalytics.newBuyTapBuy(
                    source: 'My Assets - Asset -  Buy',
                  );
                  final actualAsset = currenciesWithBalance[
                  _pageController.page?.round() ?? 0];
                  if (kycState.depositStatus ==
                      kycOperationStatus(KycStatus.allowed)) {
                    sRouter.push(
                      PaymentMethodRouter(currency: actualAsset),
                    );
                  } else {
                    kycAlertHandler.handle(
                      status: kycState.depositStatus,
                      isProgress: kycState.verificationInProgress,
                      navigatePop: true,
                      currentNavigate: () {
                        sRouter.push(
                          PaymentMethodRouter(currency: actualAsset),
                        );
                      },
                      requiredDocuments: kycState.requiredDocuments,
                      requiredVerifications:
                      kycState.requiredVerifications,
                    );
                  }
                },
                onReceive: () {
                  final actualAsset = currenciesWithBalance[
                  _pageController.page?.round() ?? 0];
                  if (kycState.depositStatus ==
                      kycOperationStatus(KycStatus.allowed)) {
                    sRouter.navigate(
                      CryptoDepositRouter(
                        header: intl.balanceActionButtons_receive,
                        currency: actualAsset,
                      ),
                    );
                  } else {
                    kycAlertHandler.handle(
                      status: kycState.depositStatus,
                      isProgress: kycState.verificationInProgress,
                      currentNavigate: () {
                        sRouter.navigate(
                          CryptoDepositRouter(
                            header: intl.balanceActionButtons_receive,
                            currency: actualAsset,
                          ),
                        );
                      },
                      requiredDocuments: kycState.requiredDocuments,
                      requiredVerifications:
                      kycState.requiredVerifications,
                    );
                  }
                },
                onSend: () {
                  final actualAsset = currenciesWithBalance[
                  _pageController.page?.round() ?? 0];
                  if (kycState.sellStatus ==
                      kycOperationStatus(KycStatus.allowed)) {
                    showSendOptions(
                      context,
                      actualAsset,
                      navigateBack: false,
                    );
                  } else {
                    kycAlertHandler.handle(
                      status: kycState.sellStatus,
                      isProgress: kycState.verificationInProgress,
                      currentNavigate: () {
                        showSendOptions(context, actualAsset);
                      },
                      requiredDocuments: kycState.requiredDocuments,
                      requiredVerifications:
                      kycState.requiredVerifications,
                    );
                  }
                },
                onExchange: () {
                  final actualAsset = currenciesWithBalance[
                  _pageController.page?.round() ?? 0];
                  if (kycState.sellStatus ==
                      kycOperationStatus(KycStatus.allowed)) {
                    sRouter.push(ConvertRouter(
                      fromCurrency: actualAsset,
                    ));
                  } else {
                    kycAlertHandler.handle(
                      status: kycState.sellStatus,
                      isProgress: kycState.verificationInProgress,
                      currentNavigate: () => sRouter.push(
                        ConvertRouter(
                          fromCurrency: actualAsset,
                        ),
                      ),
                      navigatePop: false,
                      requiredDocuments: kycState.requiredDocuments,
                      requiredVerifications:
                      kycState.requiredVerifications,
                    );
                  }
                },
              ),
              const SpaceH34(),
            ],
          ),
        ),
      ),
      body: Material(
        color: Colors.transparent,
        child: Observer(
          builder: (context) {
            return SShadeAnimationStack(
              showShade: getIt.get<AppStore>().actionMenuActive,
              //controller: _animationController,
              child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    onPageChanged: (page) {
                      currentAsset = currenciesWithBalance[page];
                    },
                    children: [
                      for (final currency in currenciesWithBalance)
                        WalletBody(
                          key: Key(currency.symbol),
                          currency: currency,
                        ),
                    ],
                  ),
                  if (!containsSingleElement(currenciesWithBalance))
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 118),
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: currenciesWithBalance.length,
                          effect: ScrollingDotsEffect(
                            spacing: 2,
                            radius: 4,
                            dotWidth: 8,
                            dotHeight: 2,
                            maxVisibleDots: 11,
                            activeDotScale: 1,
                            dotColor: colors.black.withOpacity(0.1),
                            activeDotColor: colors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
