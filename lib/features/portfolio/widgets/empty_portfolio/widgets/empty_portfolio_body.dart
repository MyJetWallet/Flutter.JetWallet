import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_buy/action_buy.dart';
import 'package:jetwallet/features/actions/action_receive/action_receive.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

class EmptyPortfolioBody extends StatefulObserverWidget {
  const EmptyPortfolioBody({
    Key? key,
  }) : super(key: key);

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
    final deviceSize = sDeviceSize;

    final bool isShowBuy = sSignalRModules.currenciesList
        .where((element) => element.buyMethods.isNotEmpty)
        .isNotEmpty;
    final bool isShowReceive = sSignalRModules.currenciesList
        .where((element) => element.supportsCryptoDeposit)
        .isNotEmpty;

    return SPaddingH24(
      child: Column(
        children: [
          const SpaceH56(),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              deviceSize.when(
                small: () {
                  return Image.asset(
                    simpleEllipseAsset,
                    width: 160,
                  );
                },
                medium: () {
                  return Image.asset(
                    simpleEllipseAsset,
                    width: 280,
                  );
                },
              ),
              Center(
                child: Text(
                  volumeFormat(
                    decimal: Decimal.zero,
                    accuracy: baseCurrency.accuracy,
                    symbol: baseCurrency.symbol,
                    prefix: baseCurrency.prefix,
                  ),
                  style: sTextH0Style.copyWith(
                    color: colors.white,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            intl.emptyEarnWalletBody_mainTextNew,
            textAlign: TextAlign.center,
            style: sTextH3Style.copyWith(
              height: 1.28,
            ),
            maxLines: 2,
          ),
          Text(
            intl.emptyEarnWalletBody_mainTextNew2,
            textAlign: TextAlign.center,
            style: sTextH3Style.copyWith(
              height: 1.28,
            ),
            maxLines: 2,
          ),
          const SpaceH38(),
          if (isShowBuy) ...[
            SPrimaryButton1(
              active: true,
              name: intl.emptyEarnWalletBody_buyCrypto,
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
                showReceiveAction(
                  context,
                  shouldPop: false,
                  checkKYC: true,
                );
              },
            ),
          ],
          const SpaceH8(),
        ],
      ),
    );
  }
}
