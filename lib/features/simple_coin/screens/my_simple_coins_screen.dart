import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/simple_coin/widgets/simple_coin_roadmap.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage(name: 'MySimpleCoinsRouter')
class MySimpleCoinsScreen extends StatelessWidget {
  const MySimpleCoinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    final balance = volumeFormat(
      decimal: sSignalRModules.smplWalletModel.profile.balance,
      symbol: 'SMPL',
    );

    return SPageFrame(
      loaderText: '',
      header: GlobalBasicAppBar(
        onRightIconTap: () {
          sRouter.push(const SimpleCoinTransactionHistoryRoute());
        },
        title: intl.simplecoin_simplecoin,
        rightIcon: Assets.svg.medium.history.simpleSvg(),
      ),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SPriceHeader(
              lable: intl.simplecoin_my_balance,
              value: balance,
            ),
          ),
          SliverToBoxAdapter(
            child: SPaddingH24(
              child: Text(
                intl.simplecoin_description,
                style: STStyles.body1Medium.copyWith(
                  color: colors.gray10,
                ),
                maxLines: 10,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SpaceH16(),
          ),
          SliverToBoxAdapter(
            child: SPaddingH24(
              child: SHyperlink(
                text: intl.simplecoin_join_simple_tap,
                onTap: () {
                  launchURL(
                    context,
                    simpleTapLink,
                    launchMode: LaunchMode.externalApplication,
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: STableHeader(
              size: SHeaderSize.m,
              title: intl.simplecoin_roadmap,
            ),
          ),
          SimpleCoinRoadmap(),
          const SliverToBoxAdapter(
            child: SpaceH100(),
          ),
        ],
      ),
    );
  }
}
