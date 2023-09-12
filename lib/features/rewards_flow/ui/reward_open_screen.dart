import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/rewards_flow/store/rewards_flow_store.dart';
import 'package:jetwallet/features/rewards_flow/ui/widgets/reward_closed_card.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/wallet_api/models/rewards/reward_spin_response.dart';

part 'reward_open_screen.g.dart';

class RewardOpenStore extends _RewardOpenStoreBase with _$RewardOpenStore {
  RewardOpenStore() : super();

  static RewardOpenStore of(BuildContext context) =>
      Provider.of<RewardOpenStore>(context, listen: false);
}

abstract class _RewardOpenStoreBase with Store {
  FlipCardController cardController = FlipCardController();
  @observable
  bool firstCardShow = true;

  @observable
  double scale = 1;

  @observable
  double width = 155;

  @observable
  double height = 200;

  @observable
  RewardSpinResponse? spinData;

  @observable
  bool secondCardShow = true;

  @observable
  String titleText = intl.reward_open_title;
  @observable
  String subtitleText = intl.reward_open_subtitile;

  @observable
  bool thirdCardShow = true;

  @observable
  bool showShareButton = false;

  @observable
  bool showBottomButton = false;

  @action
  void updateSubtitleText(String text) => subtitleText = text;

  @action
  Future<void> openCard(int index) async {
    subtitleText = intl.reward_open_openings;
    scale = 1.1;

    width = 288;
    height = 377;

    if (index == 1) {
      secondCardShow = false;
      thirdCardShow = false;
    } else if (index == 2) {
      firstCardShow = false;
      thirdCardShow = false;
    } else {
      firstCardShow = false;
      secondCardShow = false;
    }

    await sendSpinRequest();

    Future.delayed(const Duration(seconds: 1), () {
      subtitleText = intl.reward_open_youve_got;
      titleText = intl.reward_open_congratulations;
      showShareButton = true;

      cardController.flip();

      showBottomButton = true;
    });
  }

  @action
  Future<void> sendSpinRequest() async {
    final response = await sNetwork.getWalletModule().postRewardSpin();

    if (!response.hasError) {
      spinData = response.data;
    }
  }
}

@RoutePage(name: 'RewardOpenRouter')
class RewardOpenScreen extends StatelessWidget {
  const RewardOpenScreen({
    super.key,
    required this.rewardStore,
  });

  final RewardsFlowStore rewardStore;

  @override
  Widget build(BuildContext context) {
    return Provider<RewardOpenStore>(
      create: (context) => RewardOpenStore(),
      builder: (context, child) => _RewardOpenScreenBody(
        rewardStore: rewardStore,
      ),
    );
  }
}

class _RewardOpenScreenBody extends StatelessObserverWidget {
  const _RewardOpenScreenBody({
    super.key,
    required this.rewardStore,
  });

  final RewardsFlowStore rewardStore;

  @override
  Widget build(BuildContext context) {
    final store = RewardOpenStore.of(context);

    return SPageFrameWithPadding(
      header: SSmallHeader(
        title: store.titleText,
        subTitle: store.subtitleText,
        subTitleStyle: sBodyText1Style.copyWith(
          color: sKit.colors.grey1,
        ),
        showShareButton: store.showShareButton,
        showRCloseButton: true,
        showBackButton: false,
        onCLoseButton: () => sRouter.back(),
      ),
      child: Column(
        children: [
          const SpaceH80(),
          AnimatedContainer(
            width: store.width,
            height: store.height,
            duration: const Duration(seconds: 1),
            child: GestureDetector(
              onTap: () {
                store.openCard(3);
              },
              child: RewardClosedCard(
                controller: store.cardController,
                type: 1,
                spinData: store.spinData,
              ),
            ),
          ),
          /*Wrap(
            spacing: 17,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              Opacity(
                opacity: store.firstCardShow ? 1 : 0,
                child: AnimatedContainer(
                  //scale: store.scale,
                  width: 155,
                  height: 200,
                  alignment: Alignment.bottomRight,
                  duration: const Duration(seconds: 1),
                  child: GestureDetector(
                    onTap: () {
                      store.openCard(1);
                    },
                    child: RewardClosedCard(
                      controller: store.cardController,
                      type: 2,
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: store.secondCardShow ? 1 : 0,
                child: AnimatedScale(
                  scale: store.scale,
                  alignment: Alignment.topCenter,
                  duration: const Duration(seconds: 1),
                  child: GestureDetector(
                    onTap: () {
                      store.openCard(2);
                    },
                    child: RewardClosedCard(
                      controller: store.cardController,
                      type: 3,
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: store.thirdCardShow ? 1 : 0,
                child: AnimatedScale(
                  scale: store.scale,
                  duration: const Duration(seconds: 1),
                  child: GestureDetector(
                    onTap: () {
                      store.openCard(3);
                    },
                    child: RewardClosedCard(
                      controller: store.cardController,
                      type: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          */
          const SizedBox(
            height: 62 * 2.5,
          ),
          if (store.showBottomButton) ...[
            if (rewardStore.availableSpins != 0) ...[
              SPrimaryButton1(
                active: true,
                onTap: () async {
                  sRouter.back();
                },
                name: intl.reward_open_next_reward,
              ),
              const SpaceH24(),
              Text(
                '${intl.reward_you_have} ${rewardStore.availableSpins} ${intl.reward_more_to_claim}',
                textAlign: TextAlign.center,
                style: sBodyText1Style.copyWith(
                  color: sKit.colors.grey1,
                ),
              ),
            ] else ...[
              SPrimaryButton1(
                active: true,
                onTap: () async {
                  sRouter.back();
                },
                name: intl.reward_close,
              ),
            ],
          ],
        ],
      ),
    );
  }
}
