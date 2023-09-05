import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/rewards_flow/store/rewards_flow_store.dart';
import 'package:jetwallet/features/rewards_flow/ui/widgets/reward_share_card.dart';
import 'package:jetwallet/features/rewards_flow/ui/widgets/rewards_balances_cell.dart';
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
                const SpaceH6(),
                const RewardShareCard(),
                const SpaceH16(),
                SPaddingH24(
                  child: InkWell(
                    onTap: () {
                      sRouter.push(RewardOpenRouter());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: sKit.colors.grey4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(0.51, -0.86),
                                end: Alignment(-0.51, 0.86),
                                colors: [Color(0xFFCBB9FF), Color(0xFF9575F3)],
                              ),
                              shape: OvalBorder(),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: SRewardTrophyIcon(),
                            ),
                          ),
                          const SpaceW16(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${sSignalRModules.rewardsData?.availableSpins ?? 0}',
                                style: sTextH5Style,
                              ),
                              Text(
                                intl.rewards_to_claim,
                                style: sBodyText1Style,
                              ),
                            ],
                          ),
                          const Spacer(),
                          const SBlueRightArrowIcon(color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),
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
                RewardsBalancesCell(),
                const SpaceH45(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
