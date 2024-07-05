import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/prepaid_card/widgets/prepaid_card_profile_banner.dart';
import 'package:jetwallet/features/simple_coin/widgets/my_simple_coin_profile_banner.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

// TODO (Yaroslav): this widget isn't using
@RoutePage(name: 'SimpleSpaceRouter')
class SimpleSpaceScreen extends StatelessWidget {
  const SimpleSpaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: '',
      header: GlobalBasicAppBar(
        title: intl.simplecoin_simple_space,
        hasRightIcon: false,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Observer(
          builder: (context) {
            final isPrepaidCardAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
              (element) => element.id == AssetPaymentProductsEnum.prepaidCard,
            );

            final isSimpleCoinAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
              (element) => element.id == AssetPaymentProductsEnum.simpleTapToken,
            );

            return CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                if (isPrepaidCardAvaible)
                  const SliverToBoxAdapter(
                    child: PrepaidCardProfileBanner(),
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 8),
                ),
                if (isSimpleCoinAvaible)
                  const SliverToBoxAdapter(
                    child: MySimpleCoinProfileBanner(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
