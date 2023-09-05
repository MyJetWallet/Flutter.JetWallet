import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_buy/action_buy.dart';
import 'package:jetwallet/features/actions/action_receive/action_receive.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

class EmptyPortfolioBody extends StatefulObserverWidget {
  const EmptyPortfolioBody({
    super.key,
  });

  @override
  State<EmptyPortfolioBody> createState() => _EmptyPortfolioBodyState();
}

class _EmptyPortfolioBodyState extends State<EmptyPortfolioBody> {
  bool analyticSent = false;

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 1),
      () {
        if (!analyticSent) {
          analyticSent = true;

          sAnalytics.newBuyZeroScreenView();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;

    final isShowBuy = sSignalRModules.currenciesList
        .where((element) => element.buyMethods.isNotEmpty)
        .isNotEmpty;
    final isShowReceive = sSignalRModules.currenciesList
        .where((element) => element.supportsCryptoDeposit)
        .isNotEmpty;

    return SPaddingH24(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '0.00 ${baseCurrency.symbol}',
                style: sTextH1Style.copyWith(
                  color: colors.black,
                ),               
              ),
            ],
          ),
          const Spacer(),
          Image.asset(
            smileAsset,
            width: 74,
            height: 40,
          ),
          const SpaceH24(),
          Text(
            intl.start_your_journey,
            textAlign: TextAlign.center,
            style: sTextH4Style.copyWith(
              color: colors.grey2,
            ),
            maxLines: 2,
          ),
          const Spacer(),
          if (isShowBuy) ...[
            SPrimaryButton1(
              active: true,
              name: intl.buy_crypto,
              onTap: () {
                sAnalytics.newBuyTapBuy(
                  source: 'My Assets - Zero Balance - Buy',
                );

                showSendTimerAlertOr(
                  context: context,
                  or: () {
                    showBuyAction(
                      shouldPop: false,
                      context: context,
                      from: Source.profile,
                    );
                  },
                  from: BlockingType.deposit,
                );
              },
            ),
            const SpaceH8(),
          ],
          if (isShowReceive) ...[
            STextButton1(
              active: true,
              name: intl.actionReceive_receive_crypto,
              onTap: () {
                sAnalytics.tapOnTheReceiveButton(
                  source: 'My Assets - Zero Balance - Receive',
                );

                showReceiveAction(
                  context,
                  shouldPop: false,
                  checkKYC: true,
                );
              },
            ),
          ],
          const SpaceH25(),
        ],
      ),
    );
  }
}
