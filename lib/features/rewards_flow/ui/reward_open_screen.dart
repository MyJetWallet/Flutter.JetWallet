import 'dart:async';
import 'dart:ui' as ui;

import 'package:animated_background/animated_background.dart';
import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/rewards_flow/store/rewards_flow_store.dart';
import 'package:jetwallet/features/rewards_flow/ui/widgets/reward_animated_card.dart';
import 'package:jetwallet/features/rewards_flow/ui/widgets/reward_closed_card.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/rewards/reward_spin_response.dart';

part 'reward_open_screen.g.dart';

final FlipCardController cardController1 = FlipCardController();
final FlipCardController cardController2 = FlipCardController();
final FlipCardController cardController3 = FlipCardController();

class RewardOpenStore extends _RewardOpenStoreBase with _$RewardOpenStore {
  RewardOpenStore() : super();

  static RewardOpenStore of(BuildContext context) => Provider.of<RewardOpenStore>(context, listen: false);
}

abstract class _RewardOpenStoreBase with Store {
  final card1 = GlobalKey();
  final card2 = GlobalKey();
  final card3 = GlobalKey();

  @observable
  bool showBackgroundStars = false;

  @observable
  bool firstCardShow = true;

  @observable
  double width = 155;

  @observable
  double height = 200;

  @observable
  double offsetX = 0;

  @observable
  double offsetY = 0;

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

  GlobalKey getKey(int index) {
    if (index == 1) {
      return card1;
    } else if (index == 2) {
      return card2;
    } else {
      return card3;
    }
  }

  FlipCardController getFlipController(int index) {
    if (index == 1) {
      return cardController1;
    } else if (index == 2) {
      return cardController2;
    } else if (index == 3) {
      return cardController3;
    } else {
      return cardController3;
    }
  }

  bool showCard(int cardID) {
    if (cardID == 1) {
      return firstCardShow;
    } else if (cardID == 2) {
      return secondCardShow;
    } else {
      return thirdCardShow;
    }
  }

  @observable
  bool isCardOpened = false;

  int lastIndex = -1;
  AnimationController? lastController;

  @action
  Future<void> openCard(int index, AnimationController controller, String source) async {
    lastIndex = index;
    lastController = controller;
    showBackgroundStars = true;

    sAnalytics.rewardsOpenRewardTapCard(cardNumber: index, source: source);

    subtitleText = intl.reward_open_openings;

    isCardOpened = true;

    unawaited(controller.forward());

    if (index == 1) {
      firstCardShow = true;
      secondCardShow = false;
      thirdCardShow = false;
    } else if (index == 2) {
      secondCardShow = true;
      firstCardShow = false;
      thirdCardShow = false;
    } else {
      thirdCardShow = true;
      firstCardShow = false;
      secondCardShow = false;
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      width = 288;
      height = 377;
    });

    sAnalytics.rewardsOpenCardProcesing(source: source);

    await sendSpinRequest();

    Future.delayed(const Duration(seconds: 1), () {
      subtitleText = intl.reward_open_youve_got;
      titleText = intl.reward_open_congratulations;
      showShareButton = true;

      if (index == 1) {
        cardController1.flip();
      } else if (index == 2) {
        cardController2.flip();
      } else if (index == 3) {
        cardController3.flip();
      }

      showBottomButton = true;

      sAnalytics.rewardsCardFlipSuccess(
        rewardToClaime: '${sSignalRModules.rewardsData?.availableSpins ?? 0}',
        winAsset: spinData?.assetSymbol ?? '',
        winAmount: '${spinData?.amount ?? ''}',
        source: source,
      );
    });
  }

  @action
  Future<void> sendSpinRequest() async {
    try {
      final response = await sNetwork.getWalletModule().postRewardSpin();

      if (!response.hasError) {
        spinData = response.data;
      } else {
        sNotification.showError(
          intl.something_went_wrong_try_again2,
          id: 1,
        );
      }
    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong_try_again,
        id: 1,
      );
    }
  }

  @action
  void updateLastController(AnimationController controller) {
    lastController = controller;
  }

  Future<void> shareCard(String source) async {
    sAnalytics.rewardsCardShare(source: source);

    final currency = currencyFrom(
      sSignalRModules.currenciesWithHiddenList,
      spinData != null ? spinData?.assetSymbol ?? 'BTC' : 'BTC',
    );

    RenderRepaintBoundary? boundary;
    if (lastIndex == 1) {
      boundary = card1.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    } else if (lastIndex == 2) {
      boundary = card2.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    } else {
      boundary = card3.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    }

    final image = await boundary.toImage(pixelRatio: 3.0);

    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final buffer = byteData!.buffer;

    await Share.shareXFiles(
      [
        XFile.fromData(
          buffer.asUint8List(
            byteData.offsetInBytes,
            byteData.lengthInBytes,
          ),
          name: 'share_gift.png',
          mimeType: 'image/png',
        ),
      ],
      text: '${intl.reward_share_text} ${volumeFormat(
        decimal: spinData?.amount ?? Decimal.zero,
        accuracy: currency.accuracy,
        symbol: currency.symbol,
      )} ${intl.reward_share_text_2} ${sSignalRModules.rewardsData?.referralLink ?? ''}',
    );
  }

  @action
  void nextReward() {
    if (lastIndex != -1) {
      if (lastIndex == 1) {
        cardController1.flipBack();
      } else if (lastIndex == 2) {
        cardController2.flipBack();
      } else {
        cardController3.flipBack();
      }
    }

    if (lastController != null) {
      lastController!.reset();
    }

    isCardOpened = false;

    Future.delayed(const Duration(milliseconds: 500), () {
      lastController = null;
      lastIndex = -1;
      showBackgroundStars = false;
      firstCardShow = true;
      width = 155;
      height = 200;
      offsetX = 0;
      offsetY = 0;
      spinData = null;
      secondCardShow = true;
      titleText = intl.reward_open_title;
      subtitleText = intl.reward_open_subtitile;
      thirdCardShow = true;
      showShareButton = false;
      showBottomButton = false;
    });
  }
}

@RoutePage(name: 'RewardOpenRouter')
class RewardOpenScreen extends StatelessWidget {
  const RewardOpenScreen({
    super.key,
    required this.rewardStore,
    required this.source,
  });

  final RewardsFlowStore rewardStore;
  final String source;

  @override
  Widget build(BuildContext context) {
    return Provider<RewardOpenStore>(
      create: (context) => RewardOpenStore(),
      builder: (context, child) => _RewardOpenScreenBody(
        rewardStore: rewardStore,
        source: source,
      ),
    );
  }
}

class _RewardOpenScreenBody extends StatefulObserverWidget {
  const _RewardOpenScreenBody({
    required this.rewardStore,
    required this.source,
  });

  final RewardsFlowStore rewardStore;
  final String source;

  @override
  State<_RewardOpenScreenBody> createState() => _RewardOpenScreenBodyState();
}

class _RewardOpenScreenBodyState extends State<_RewardOpenScreenBody> with TickerProviderStateMixin {
  @override
  void initState() {
    sAnalytics.rewardsChooseRewardCard(
      source: widget.source,
    );
    super.initState();
  }

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
        onCLoseButton: () {
          sRouter.back();

          if (store.showBottomButton) {
            sAnalytics.rewardsCloseFlowAfterCardFlip(source: widget.source);
          } else {
            sAnalytics.rewardsOpenRewardClose(source: widget.source);
          }
        },
        onShareButtonTap: () => store.shareCard(widget.source),
      ),
      loaderText: intl.register_pleaseWait,
      child: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            particleCount: 35,
            spawnMinSpeed: 50,
            spawnMaxSpeed: 125,
            spawnOpacity: store.showBackgroundStars ? 1 : 0,
            minOpacity: store.showBackgroundStars ? 1 : 0,
            maxOpacity: store.showBackgroundStars ? 1 : 0,
            image: Image.asset(simpleRewardSmallStar),
          ),
        ),
        vsync: this,
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SpaceH70(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (store.secondCardShow) ...[
                      RewardAnimatedCard(
                        cardID: 2,
                        offsetX: 8.0,
                        offsetY: 30.0,
                        source: widget.source,
                      ),
                      const SizedBox(width: 17),
                    ],
                    if (store.thirdCardShow) ...[
                      RewardAnimatedCard(
                        cardID: 3,
                        offsetX: -8.0,
                        offsetY: 30.0,
                        source: widget.source,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 17),
                if (store.firstCardShow)
                  RewardAnimatedCard(
                    cardID: 1,
                    offsetX: 0.0,
                    offsetY: -30.0,
                    source: widget.source,
                  ),
                const SizedBox(
                  height: 60,
                ),
                if (store.showBottomButton) ...[
                  if (widget.rewardStore.availableSpins != 0) ...[
                    SPrimaryButton1(
                      active: true,
                      onTap: () async {
                        sAnalytics.rewardsClickNextReward(source: widget.source);

                        store.nextReward();
                      },
                      name: intl.reward_open_next_reward,
                    ),
                    const SpaceH24(),
                    Text(
                      '${intl.reward_you_have} ${widget.rewardStore.availableSpins} ${intl.reward_more_to_claim}',
                      textAlign: TextAlign.center,
                      style: sBodyText1Style.copyWith(
                        color: sKit.colors.grey1,
                      ),
                    ),
                  ] else ...[
                    SPrimaryButton1(
                      active: true,
                      onTap: () async {
                        sAnalytics.rewardsCloseFlowAfterCardFlip(source: widget.source);

                        sRouter.back();
                      },
                      name: intl.reward_close,
                    ),
                  ],
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
