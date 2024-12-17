import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/rewards_flow/store/rewards_flow_store.dart';
import 'package:jetwallet/features/rewards_flow/ui/widgets/reward_share_card.dart';
import 'package:jetwallet/features/rewards_flow/ui/widgets/rewards_balances_cell.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/rewards_profile_model.dart';

import '../../app/store/app_store.dart';

@RoutePage(name: 'RewardsFlowRouter')
class RewardsFlowScreen extends StatelessWidget {
  const RewardsFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<RewardsFlowStore>(
      create: (context) => RewardsFlowStore()
        ..updateData(
          sSignalRModules.rewardsData ?? RewardsProfileModel(),
        ),
      builder: (context, child) => const _RewardsFlowScreenBody(),
    );
  }
}

class _RewardsFlowScreenBody extends StatefulObserverWidget {
  const _RewardsFlowScreenBody();

  @override
  State<_RewardsFlowScreenBody> createState() => _RewardsFlowScreenBodyState();
}

class _RewardsFlowScreenBodyState extends State<_RewardsFlowScreenBody> {
  @override
  Widget build(BuildContext context) {
    final store = RewardsFlowStore.of(context);

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SimpleLargeAltAppbar(
        title: intl.rewards_flow_tab_title,
        showLabelIcon: false,
        hasRightIcon: false,
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceH6(),
                const RewardShareCard(),
                if (store.availableSpins > 0) ...[
                  const SpaceH16(),
                  SPaddingH24(
                    child: InkWell(
                      onTap: () {
                        sRouter.push(
                          RewardOpenRouter(
                            rewardStore: store,
                            source: 'tabbar',
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: SColorsLight().gray4),
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
                                  colors: [
                                    Color(0xFFCBB9FF),
                                    Color(0xFF9575F3),
                                  ],
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
                                  '${store.availableSpins}',
                                  style: STStyles.header6,
                                ),
                                Text(
                                  intl.rewards_to_claim,
                                  style: STStyles.body1Medium.copyWith(
                                    color: SColorsLight().gray10,
                                  ),
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
                ],
                const SpaceH32(),
                SPaddingH24(
                  child: Text(
                    '${intl.reward_your_reward_subtitle_1} ${getIt<AppStore>().isBalanceHide ? '**** ${getIt.get<FormatService>().baseCurrency.symbol}' : store.totalEarnedBaseCurrency.toFormatCount(
                        accuracy: getIt.get<FormatService>().baseCurrency.accuracy,
                        symbol: getIt.get<FormatService>().baseCurrency.symbol,
                      )}',
                    style: STStyles.header5,
                    maxLines: 3,
                  ),
                ),
                if (store.totalEarnedBaseCurrency == Decimal.zero || isAnyValidItemInRewardBalanceList(store)) ...[
                  SPaddingH24(
                    child: Text(
                      intl.reward_your_reward_subtitle_2,
                      style: STStyles.body1Medium.copyWith(
                        color: SColorsLight().gray10,
                      ),
                      maxLines: 8,
                    ),
                  ),
                ] else ...[
                  SPaddingH24(
                    child: Text(
                      intl.reward_your_reward_subtitle_2,
                      style: STStyles.body1Medium.copyWith(
                        color: SColorsLight().gray10,
                      ),
                      maxLines: 8,
                    ),
                  ),
                ],
                const RewardsBalancesCell(),
                const SpaceH45(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

bool isAnyValidItemInRewardBalanceList(RewardsFlowStore store) {
  if (store.balances.isEmpty) return false;

  return store.balances.where((element) => element.amount != Decimal.zero).isEmpty;
}
