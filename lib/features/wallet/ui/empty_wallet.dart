import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/wallet/ui/widgets/action_button/action_button.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/empty_earn_wallet_body.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/empty_wallet_body.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/router/app_router.dart';
import '../../../widgets/circle_action_buttons/circle_action_buy.dart';
import '../../../widgets/circle_action_buttons/circle_action_receive.dart';
import '../../kyc/helper/kyc_alert_handler.dart';
import '../../kyc/kyc_service.dart';
import '../../kyc/models/kyc_operation_status_model.dart';

class EmptyWallet extends StatefulObserverWidget {
  const EmptyWallet({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  State<EmptyWallet> createState() => _EmptyWalletState();
}

class _EmptyWalletState extends State<EmptyWallet>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    // animationController intentionally is not disposed,
    // because bottomSheet will dispose it on its own
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentAsset =
        currencyFrom(sSignalRModules.currenciesList, widget.currency.symbol);
    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 127,
        child: Column(
          children: [
            const SDivider(),
            const SpaceH16(),
            SPaddingH24(
              child: Row(
                children: [
                  const Spacer(),
                  CircleActionBuy(
                    onTap: () {
                      sAnalytics.newBuyTapBuy(
                        source: 'My Assets - Asset -  Buy',
                      );
                      if (kycState.depositStatus ==
                          kycOperationStatus(KycStatus.allowed)) {
                        sRouter.push(
                          PaymentMethodRouter(currency: currentAsset),
                        );
                      } else {
                        kycAlertHandler.handle(
                          status: kycState.depositStatus,
                          isProgress: kycState.verificationInProgress,
                          navigatePop: true,
                          currentNavigate: () {
                            sRouter.push(
                              PaymentMethodRouter(currency: currentAsset),
                            );
                          },
                          requiredDocuments: kycState.requiredDocuments,
                          requiredVerifications:
                          kycState.requiredVerifications,
                        );
                      }
                    },
                  ),
                  const SpaceW37(),
                  CircleActionReceive(
                    onTap: () {
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
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SpaceH34(),
          ],
        ),
      ),
      body: Observer(
        builder: (context) {
          return SShadeAnimationStack(
            showShade: getIt.get<AppStore>().actionMenuActive,
            //controller: animationController,
            child: SPageFrameWithPadding(
              loaderText: intl.register_pleaseWait,
              header: SSmallHeader(
                title: '${widget.currency.description} '
                    '${intl.emptyWallet_balance}',
              ),
              child: (widget.currency.apy.toDouble() == 0.0)
                  ? EmptyWalletBody(
                      assetName: widget.currency.description,
                    )
                  : EmptyEarnWalletBody(
                      assetName: widget.currency.description,
                      apy: widget.currency.apy,
                    ),
            ),
          );
        },
      ),
    );
  }
}
