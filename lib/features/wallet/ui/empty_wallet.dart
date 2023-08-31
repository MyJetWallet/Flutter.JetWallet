import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_buy/widgets/buy_payment_currency.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/wallet/ui/widgets/empty_wallet_with_history.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/empty_wallet_body.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_request_model.dart';

import '../../../core/router/app_router.dart';
import '../../../core/services/simple_networking/simple_networking.dart';
import '../../actions/circle_actions/circle_actions.dart';
import '../../kyc/helper/kyc_alert_handler.dart';
import '../../kyc/kyc_service.dart';
import '../../kyc/models/kyc_operation_status_model.dart';

@RoutePage(name: 'EmptyWalletRouter')
class EmptyWallet extends StatefulObserverWidget {
  const EmptyWallet({
    super.key,
    required this.currency,
  });

  final CurrencyModel currency;

  @override
  State<EmptyWallet> createState() => _EmptyWalletState();
}

class _EmptyWalletState extends State<EmptyWallet>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  int lengthOfHistory = 0;

  @override
  void initState() {
    // animationController intentionally is not disposed,
    // because bottomSheet will dispose it on its own
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    sNetwork
        .getWalletModule()
        .getOperationHistory(
          OperationHistoryRequestModel(
            assetId: widget.currency.symbol,
            batchSize: 20,
          ),
        )
        .then((value) {
      setState(() {
        lengthOfHistory = value.data?.operationHistory.length ?? 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentAsset =
        currencyFrom(sSignalRModules.currenciesList, widget.currency.symbol);
    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    if (lengthOfHistory > 0) {
      return EmptyWalletWithHistory(currency: widget.currency);
    }

    return Scaffold(
      bottomNavigationBar: (currentAsset.supportsAtLeastOneBuyMethod ||
              currentAsset.supportsCryptoDeposit)
          ? SizedBox(
              height: 127,
              child: Column(
                children: [
                  const SDivider(),
                  const SpaceH16(),
                  CircleActionButtons(
                    showBuy: currentAsset.supportsAtLeastOneBuyMethod,
                    showReceive: currentAsset.supportsCryptoDeposit,
                    showExchange: false,
                    showSend: false,
                    onBuy: () {
                      sAnalytics.newBuyTapBuy(
                        source: 'My Assets - Asset -  Buy',
                      );
                      if (kycState.depositStatus ==
                          kycOperationStatus(KycStatus.allowed)) {
                        showBuyPaymentCurrencyBottomSheet(
                            context, currentAsset);
                      } else {
                        kycAlertHandler.handle(
                          status: kycState.depositStatus,
                          isProgress: kycState.verificationInProgress,
                          navigatePop: true,
                          currentNavigate: () {
                            showBuyPaymentCurrencyBottomSheet(
                                context, currentAsset);
                          },
                          requiredDocuments: kycState.requiredDocuments,
                          requiredVerifications: kycState.requiredVerifications,
                        );
                      }
                    },
                    onReceive: () {
                      if (currentAsset.type == AssetType.crypto) {
                        if (kycState.depositStatus ==
                            kycOperationStatus(KycStatus.allowed)) {
                          sRouter.navigate(
                            CryptoDepositRouter(
                              header: intl.balanceActionButtons_receive,
                              currency: currentAsset,
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
                                  currency: currentAsset,
                                ),
                              );
                            },
                            requiredDocuments: kycState.requiredDocuments,
                            requiredVerifications:
                                kycState.requiredVerifications,
                          );
                        }
                      } else {
                        sRouter.popUntilRoot();
                        getIt<AppStore>().setHomeTab(2);
                        if (getIt<AppStore>().tabsRouter != null) {
                          getIt<AppStore>().tabsRouter!.setActiveIndex(2);
                        }
                      }
                    },
                  ),
                  const SpaceH34(),
                ],
              ),
            )
          : null,
      body: Observer(
        builder: (context) {
          return SShadeAnimationStack(
            showShade: getIt.get<AppStore>().actionMenuActive,
            //controller: animationController,
            child: SPageFrameWithPadding(
              loaderText: intl.register_pleaseWait,
              header: SSmallHeader(
                title: intl.portfolioHeader_balance,
              ),
              child: EmptyWalletBody(
                assetName: widget.currency.description,
              ),
            ),
          );
        },
      ),
    );
  }
}
