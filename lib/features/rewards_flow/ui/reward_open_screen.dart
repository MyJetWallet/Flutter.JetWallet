import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/rewards_flow/ui/widgets/reward_closed_card.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:mobx/mobx.dart';

part 'reward_open_screen.g.dart';

class RewardOpenStore extends _RewardOpenStoreBase with _$RewardOpenStore {
  RewardOpenStore() : super();

  static RewardOpenStore of(BuildContext context) =>
      Provider.of<RewardOpenStore>(context, listen: false);
}

abstract class _RewardOpenStoreBase with Store {
  @observable
  String subtitleText = intl.reward_open_subtitile;
  @action
  void updateSubtitleText(String text) => subtitleText = text;

  @observable
  bool firstCardShow = true;
  @observable
  bool secondCardShow = true;
  @observable
  bool thirdCardShow = true;

  @observable
  double scale = 1;

  @action
  void openCard(int index) {
    subtitleText = intl.reward_open_openings;
    scale = 2.3;

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

    print(scale);
  }
}

@RoutePage(name: 'RewardOpenRouter')
class RewardOpenScreen extends StatelessWidget {
  const RewardOpenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<RewardOpenStore>(
      create: (context) => RewardOpenStore(),
      builder: (context, child) => const _RewardOpenScreenBody(),
    );
  }
}

class _RewardOpenScreenBody extends StatelessObserverWidget {
  const _RewardOpenScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final store = RewardOpenStore.of(context);

    return SPageFrameWithPadding(
      header: SSmallHeader(
        title: 'Simple Reward',
        subTitle: store.subtitleText,
        subTitleStyle: sBodyText1Style.copyWith(
          color: sKit.colors.grey1,
        ),
        showRCloseButton: true,
        showBackButton: false,
        onCLoseButton: () => sRouter.back(),
      ),
      child: Column(
        children: [
          const SpaceH80(),
          Wrap(
            spacing: 17,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              Opacity(
                opacity: store.firstCardShow ? 1 : 0,
                child: AnimatedScale(
                  scale: store.scale,
                  duration: const Duration(seconds: 2),
                  child: GestureDetector(
                    onTap: () {
                      store.openCard(1);
                    },
                    child: const RewardClosedCard(
                      type: 2,
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: store.secondCardShow ? 1 : 0,
                child: AnimatedScale(
                  scale: store.scale,
                  duration: const Duration(seconds: 2),
                  child: GestureDetector(
                    onTap: () {
                      store.openCard(2);
                    },
                    child: const RewardClosedCard(
                      type: 3,
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: store.thirdCardShow ? 1 : 0,
                child: AnimatedScale(
                  scale: store.scale,
                  duration: const Duration(seconds: 2),
                  child: GestureDetector(
                    onTap: () {
                      store.openCard(3);
                    },
                    child: const RewardClosedCard(
                      type: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
