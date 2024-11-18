import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/prevent_duplication_events_servise.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/simple_coin/widgets/simple_coin_roadmap.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

@RoutePage(name: 'MySimpleCoinsRouter')
class MySimpleCoinsScreen extends StatelessWidget {
  const MySimpleCoinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    final balance = sSignalRModules.smplWalletModel.profile.balance.toFormatCount(
      symbol: 'SMPL',
    );

    return VisibilityDetector(
      key: const Key('my_simple_coins-screen-key'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          getIt.get<PreventDuplicationEventsService>().sendEvent(
                id: 'my_simple_coins-screen-key',
                event: sAnalytics.simplecoinLandingScreenView,
              );
        }
      },
      child: SPageFrame(
        loaderText: '',
        header: GlobalBasicAppBar(
          onRightIconTap: () {
            sAnalytics.tapOnTheButtonTrxHistoryOnSimplecoinLandingScreen();
            sRouter.push(const SimpleCoinTransactionHistoryRoute());
          },
          onLeftIconTap: () {
            sAnalytics.tapOnTheButtonBackOnSimplecoinLandingScreen();
            sRouter.maybePop();
          },
          rightIcon: Assets.svg.medium.history.simpleSvg(),
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 12,
                    ),
                    child: Image.asset(simpleCoinHeader),
                  ),
                  SPriceHeader(
                    lable: intl.simplecoin_my_simplecoins,
                    value: getIt<AppStore>().isBalanceHide ? '**** SMPL' : balance,
                    icon: Assets.svg.assets.crypto.smpl.simpleSvg(
                      width: 32,
                    ),
                  ),
                  SPaddingH24(
                    child: Text(
                      intl.simplecoin_description,
                      style: STStyles.body1Medium.copyWith(
                        color: colors.gray10,
                      ),
                      maxLines: 10,
                    ),
                  ),
                  const SpaceH16(),
                  SPaddingH24(
                    child: SHyperlink(
                      text: intl.simplecoin_join_simple_tap,
                      onTap: () {
                        sAnalytics.tapOnTheButtonJoinSimpleTapOnSimplecoinLandingScreen();
                        launchURL(
                          context,
                          simpleTapLink,
                          launchMode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                  ),
                  STableHeader(
                    size: SHeaderSize.m,
                    title: intl.simplecoin_roadmap,
                  ),
                  const SimpleCoinRoadmap(),
                  const SpaceH100(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
