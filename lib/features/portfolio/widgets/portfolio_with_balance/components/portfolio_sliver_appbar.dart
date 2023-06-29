import 'dart:math';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
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
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/kyc/models/kyc_verified_model.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:jetwallet/utils/helpers/are_balances_empty.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_buy.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_exchange.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_receive.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_send.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/bottom_navigation_bar/components/notification_box.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

import '../../../../rewards/store/reward_store.dart';

class PortfolioSliverAppBar extends StatelessObserverWidget {
  const PortfolioSliverAppBar({
    super.key,
    required this.shrinkOffset,
    required this.max,
    required this.min,
  });

  final double shrinkOffset;

  final double max;
  final double min;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;
    final currencies = sSignalRModules.currenciesList;
    final itemsWithBalance = currenciesWithBalanceFrom(currencies);

    final isNotEmptyBalance = !areBalancesEmpty(currencies);

    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    final expendPercentage = (shrinkOffset.clamp(min, max) - min) / (max - min);
    final viewedRewards =
        sSignalRModules.keyValue.viewedRewards?.value ?? <String>[];
    var counterOfRewards = 0;
    final rewStore = RewardStore();
    for (final campaign in rewStore.sortedCampaigns) {
      if (campaign.campaign != null &&
          !viewedRewards.contains(campaign.campaign!.campaignId)) {
        counterOfRewards++;
      }
    }
    if (!viewedRewards.contains('referral')) {
      counterOfRewards++;
    }

    final interpolatedTextStyle = TextStyle.lerp(
      sTextH1Style,
      sTextH3Style,
      expendPercentage,
    );

    final bool isShowBuy = sSignalRModules.currenciesList
        .where((element) => element.buyMethods.isNotEmpty)
        .isNotEmpty;
    final bool isShowSend = sSignalRModules.currenciesList
        .where((element) =>
            element.isSupportAnyWithdrawal && element.isAssetBalanceNotEmpty)
        .isNotEmpty;
    final bool isShowReceive = sSignalRModules.currenciesList
        .where((element) => element.supportsCryptoDeposit)
        .isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpaceH54(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpaceW24(),
            Row(
              children: [
                Text(
                  intl.portfolioHeader_balance,
                  style: sTextH5Style,
                ),
                const SpaceW8(),
                SIconButton(
                  defaultIcon: !getIt<AppStore>().isBalanceHide
                      ? SEyeCloseIcon(
                          color: colors.black,
                        )
                      : SEyeOpenIcon(
                          color: colors.black,
                        ),
                  pressedIcon: !getIt<AppStore>().isBalanceHide
                      ? SEyeCloseIcon(
                          color: colors.black.withOpacity(0.7),
                        )
                      : SEyeOpenIcon(
                          color: colors.black.withOpacity(0.7),
                        ),
                  onTap: () {
                    if (getIt<AppStore>().isBalanceHide) {
                      getIt<AppStore>().setIsBalanceHide(false);
                    } else {
                      getIt<AppStore>().setIsBalanceHide(true);
                    }
                  },
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: 56.0,
              height: 56.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SIconButton(
                    defaultIcon: SNotificationsIcon(
                      color: colors.black,
                    ),
                    pressedIcon: SNotificationsIcon(
                      color: colors.black.withOpacity(0.7),
                    ),
                    onTap: () {
                      sRouter.push(RewardsRouter(actualRewards: viewedRewards));
                    },
                  ),
                  NotificationBox(
                    notifications: counterOfRewards,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 56.0,
              height: 56.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SIconButton(
                    defaultIcon: SProfileDetailsIcon(
                      color: colors.black,
                    ),
                    pressedIcon: SProfileDetailsIcon(
                      color: colors.black.withOpacity(0.7),
                    ),
                    onTap: () {
                      sRouter.push(const AccountRouter());
                    },
                  ),
                  NotificationBox(
                    notifications: _profileNotificationLength(
                      KycModel(
                        depositStatus: kycState.depositStatus,
                        sellStatus: kycState.sellStatus,
                        withdrawalStatus: kycState.withdrawalStatus,
                        requiredDocuments: kycState.requiredDocuments,
                        requiredVerifications: kycState.requiredVerifications,
                        verificationInProgress: kycState.verificationInProgress,
                      ),
                      true,
                    ),
                  ),
                ],
              ),
            ),
            const SpaceW8(),
          ],
        ),
        const SpaceH15(),
        SPaddingH24(
          child: Text(
            !getIt<AppStore>().isBalanceHide
                ? _price(itemsWithBalance, baseCurrency)
                : '${baseCurrency.prefix}*******',
            style: interpolatedTextStyle,
          ),
        ),
        const SpaceH24(),
        const SpaceH16(),
        Opacity(
          opacity: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (isShowBuy) ...[
                CircleActionBuy(
                  onTap: () {
                    sAnalytics.newBuyTapBuy(
                      source: 'My Assets - Buy',
                    );
                    showBuyAction(
                      fromCard: true,
                      shouldPop: false,
                      context: context,
                    );
                  },
                ),
              ],
              if (isShowReceive) ...[
                CircleActionReceive(
                  onTap: () {
                    if (kycState.depositStatus ==
                        kycOperationStatus(KycStatus.allowed)) {
                      showReceiveAction(context, shouldPop: false);
                    } else {
                      kycAlertHandler.handle(
                        status: kycState.depositStatus,
                        isProgress: kycState.verificationInProgress,
                        currentNavigate: () => showReceiveAction(
                          context,
                          shouldPop: false,
                        ),
                        navigatePop: false,
                        requiredDocuments: kycState.requiredDocuments,
                        requiredVerifications: kycState.requiredVerifications,
                      );
                    }
                  },
                ),
              ],
              if (isShowSend) ...[
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
              ],
              CircleActionExchange(
                onTap: () {
                  if (kycState.sellStatus ==
                      kycOperationStatus(KycStatus.allowed)) {
                    showSendTimerAlertOr(
                      context: context,
                      or: () => sRouter.push(ConvertRouter()),
                      from: BlockingType.trade,
                    );
                  } else {
                    kycAlertHandler.handle(
                      status: kycState.sellStatus,
                      isProgress: kycState.verificationInProgress,
                      currentNavigate: () => showSendTimerAlertOr(
                        context: context,
                        or: () => sRouter.push(ConvertRouter()),
                        from: BlockingType.trade,
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
    );
  }

  int _profileNotificationLength(KycModel kycState, bool twoFaEnable) {
    var notificationLength = 0;

    final passed = checkKycPassed(
      kycState.depositStatus,
      kycState.sellStatus,
      kycState.withdrawalStatus,
    );

    if (!passed) {
      notificationLength += 1;
    }

    if (!twoFaEnable) {
      notificationLength += 1;
    }

    return notificationLength;
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
