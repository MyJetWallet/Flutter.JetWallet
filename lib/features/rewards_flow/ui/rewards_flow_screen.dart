import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/rewards_flow/store/rewards_flow_store.dart';
import 'package:jetwallet/features/rewards_flow/ui/widgets/reward_share_card.dart';
import 'package:jetwallet/features/rewards_flow/ui/widgets/rewards_header.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'RewardsFlowRouter')
class RewardsFlowScreen extends StatelessWidget {
  const RewardsFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<RewardsFlowStore>(
      create: (context) => RewardsFlowStore(),
      builder: (context, child) => _RewardsFlowScreenBody(),
    );
  }
}

class _RewardsFlowScreenBody extends StatelessWidget {
  const _RewardsFlowScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      header: const RewardsHeader(),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RewardShareCard(),
                const SpaceH32(),
                SPaddingH24(
                  child: Text(
                    intl.rewards_flow_your_rewards,
                    style: sTextH4Style,
                    maxLines: 3,
                  ),
                ),
                SPaddingH24(
                  child: Text(
                    'Total received rewards 0 EUR. New reward balances will be shown here.',
                    style: sBodyText1Style,
                    maxLines: 8,
                  ),
                ),
                const SpaceH45(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
