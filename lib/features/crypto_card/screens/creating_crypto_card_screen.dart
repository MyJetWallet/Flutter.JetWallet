import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/prevent_duplication_events_servise.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:visibility_detector/visibility_detector.dart';

@RoutePage(name: 'CreatingCryptoCardRoute')
class CreatingCryptoCardScreen extends StatelessWidget {
  const CreatingCryptoCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('CreatingCryptoCardScreen'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          getIt.get<PreventDuplicationEventsService>().sendEvent(
                id: 'CreatingCryptoCardScreen',
                event: () {
                  sAnalytics.viewProcessingScreen();
                },
              );
        }
      },
      child: SPageFrame(
        loaderText: '',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 233,
                  height: 211,
                  child: Image.asset(
                    cryptoCardAlmostTher,
                  ),
                ),
                const SpaceH23(),
                SizedBox(
                  width: 185,
                  child: Text(
                    intl.crypto_card_on_the_way,
                    style: STStyles.body2Semibold.copyWith(
                      color: SColorsLight().gray10,
                    ),
                    maxLines: 5,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
