import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_buy/action_buy.dart';
import 'package:jetwallet/features/actions/action_receive/action_receive.dart';
import 'package:jetwallet/features/actions/action_send/action_send.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:jetwallet/utils/helpers/are_balances_empty.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_buy.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_exchange.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_receive.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_send.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'dart:math' as math;

class PortfolioSliverAppBar extends StatelessObserverWidget {
  const PortfolioSliverAppBar({
    super.key,
    required this.isShrink,
  });

  final bool isShrink;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;
    final currencies = sSignalRModules.currenciesList;
    final itemsWithBalance = currenciesWithBalanceFrom(currencies);

    final isNotEmptyBalance = !areBalancesEmpty(currencies);

    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [const SpaceH64(),
        Row(
          children: [
            const SpaceW24(),
            Row(
              children: [
                Text(
                  intl.portfolioHeader_balance,
                  style: sTextH5Style,
                ),
                const SpaceW8(),
                GestureDetector(
                  onTap: () {
                    if (getIt<AppStore>().isBalanceHide) {
                      getIt<AppStore>().setIsBalanceHide(false);
                    } else {
                      getIt<AppStore>().setIsBalanceHide(true);
                    }
                  },
                  child: getIt<AppStore>().isBalanceHide
                      ? const SEyeCloseIcon()
                      : SEyeOpenIcon(
                          color: colors.black,
                        ),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                sAnalytics.rewardsScreenView(Source.giftIcon);

                sRouter.push(const RewardsRouter());
              },
              child: const SNotificationsIcon(),
            ),
            const SpaceW34(),
            GestureDetector(
              onTap: () {
                sRouter.push(AccountRouter());
              },
              child: const SProfileDetailsIcon(),
            ),
            const SpaceW26(),
          ],
        ),
        const SpaceH15(),
        SPaddingH24(
          child: Text(
            !getIt<AppStore>().isBalanceHide
                ? _price(itemsWithBalance, baseCurrency)
                : '€*******',
            style: sTextH1Style,
          ),
        ),
        const SpaceH24(),
        if (!isShrink) ...[
          const SpaceH16(),
          Opacity(
            opacity: 1,
            child: Row(
              children: [
                CircleActionBuy(
                  onTap: () {
                    showBuyAction(
                      fromCard: true,
                      shouldPop: false,
                      context: context,
                    );
                  },
                ),
                CircleActionReceive(
                  onTap: () {
                    if (kycState.depositStatus ==
                        kycOperationStatus(KycStatus.allowed)) {
                      showReceiveAction(context, shouldPop: false);
                    } else {
                      kycAlertHandler.handle(
                        status: kycState.depositStatus,
                        isProgress: kycState.verificationInProgress,
                        currentNavigate: () => showSendAction(
                          context,
                          isNotEmptyBalance: isNotEmptyBalance,
                          shouldPop: false,
                        ),
                        navigatePop: false,
                        requiredDocuments: kycState.requiredDocuments,
                        requiredVerifications: kycState.requiredVerifications,
                      );
                    }
                  },
                ),
                CircleActionSend(
                  onTap: () {
                    if (kycState.withdrawalStatus ==
                        kycOperationStatus(KycStatus.allowed)) {
                      showSendAction(
                        context,
                        isNotEmptyBalance: isNotEmptyBalance,
                        shouldPop: false,
                      );
                    } else {
                      kycAlertHandler.handle(
                        status: kycState.withdrawalStatus,
                        isProgress: kycState.verificationInProgress,
                        currentNavigate: () => showSendAction(
                          context,
                          isNotEmptyBalance: isNotEmptyBalance,
                          shouldPop: false,
                        ),
                        navigatePop: false,
                        requiredDocuments: kycState.requiredDocuments,
                        requiredVerifications: kycState.requiredVerifications,
                      );
                    }
                  },
                ),
                CircleActionExchange(
                  onTap: () {
                    if (kycState.sellStatus ==
                        kycOperationStatus(KycStatus.allowed)) {
                      sRouter.push(ConvertRouter());
                    } else {
                      kycAlertHandler.handle(
                        status: kycState.sellStatus,
                        isProgress: kycState.verificationInProgress,
                        currentNavigate: () => sRouter.push(
                          ConvertRouter(),
                        ),
                        navigatePop: false,
                        requiredDocuments: kycState.requiredDocuments,
                        requiredVerifications: kycState.requiredVerifications,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _price(
    List<CurrencyModel> items,
    BaseCurrencyModel baseCurrency,
  ) {
    var totalBalance = Decimal.zero;

    for (final item in items) {
      totalBalance += item.baseBalance;
    }

    return marketFormat(
      prefix: baseCurrency.prefix,
      decimal: totalBalance,
      accuracy: baseCurrency.accuracy,
      symbol: baseCurrency.symbol,
    );
  }
}
