import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/market/ui/widgets/fade_on_scroll.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';

@RoutePage(name: 'EarnPositionActiveRouter')
class EarnPositionActiveScreen extends StatefulWidget {
  const EarnPositionActiveScreen({required this.earnPosition, super.key});

  final EarnPositionClientModel earnPosition;

  @override
  State<EarnPositionActiveScreen> createState() => _EarnScreenState();
}

class _EarnScreenState extends State<EarnPositionActiveScreen> {
  final ScrollController controller = ScrollController();

  @override
  void dispose() {
    controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<EarnStore>(
      create: (context) => EarnStore(),
      builder: (context, child) {
        return _EarnView(controller: controller);
      },
    );
  }
}

class _EarnView extends StatelessWidget {
  const _EarnView({
    required this.controller,
  });

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final store = EarnStore.of(context);
    final colors = sKit.colors;

    return Scaffold(
      body: NestedScrollView(
        controller: controller,
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              backgroundColor: colors.white,
              pinned: true,
              elevation: 0,
              expandedHeight: 120,
              collapsedHeight: 120,
              primary: false,
              flexibleSpace: FadeOnScroll(
                scrollController: controller,
                fullOpacityOffset: 50,
                fadeInWidget: const SDivider(
                  width: double.infinity,
                ),
                fadeOutWidget: const SizedBox.shrink(),
                permanentWidget: SMarketHeaderClosed(
                  title: intl.earn_earn,
                ),
              ),
            ),
          ];
        },
        body: CustomScrollView(
          slivers: [],
        ),
      ),
    );
  }
}
