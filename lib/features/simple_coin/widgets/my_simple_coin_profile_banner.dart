import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class MySimpleCoinProfileBanner extends StatelessWidget {
  const MySimpleCoinProfileBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final balance = volumeFormat(
          decimal: sSignalRModules.smplWalletModel.profile.balance,
          symbol: 'SMPL',
        );
        return SafeGesture(
          onTap: () {
            sAnalytics.tapOnTheButtonMySimplecoinOnProfileOrSimpleSpaceScreens();
            sRouter.push(const MySimpleCoinsRouter());
          },
          child: Container(
            padding: const EdgeInsets.only(
              top: 16,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              gradient: const LinearGradient(
                end: Alignment(1.00, -3.00),
                begin: Alignment(-0.9, 3),
                colors: [
                  Color.fromRGBO(252, 234, 187, 0.86),
                  Color.fromRGBO(248, 191, 231, 0.86),
                  Color.fromRGBO(193, 241, 245, 0.86),
                ],
                stops: [0.3, 0.55, 0.9],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      intl.simplecoin_my_simplecoin,
                      style: STStyles.body1Bold,
                    ),
                    Text(
                      balance,
                      style: STStyles.body1Medium,
                    ),
                  ],
                ),
                Assets.svg.assets.crypto.smpl.simpleSvg(
                  width: 48,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
