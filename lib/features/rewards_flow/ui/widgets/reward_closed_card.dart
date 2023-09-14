import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/rewards/reward_spin_response.dart';

class FlipCardController {
  RewardClosedCardState? _state;

  Future flip() async => _state?.flip();

  Future flipBack() async => _state?.flipBack();
}

class RewardClosedCard extends StatefulWidget {
  const RewardClosedCard({
    super.key,
    this.spinData,
    required this.controller,
    required this.type,
    required this.shareKey,
  });

  final RewardSpinResponse? spinData;
  final FlipCardController controller;
  final int type;
  final Key shareKey;

  @override
  State<RewardClosedCard> createState() => RewardClosedCardState();
}

class RewardClosedCardState extends State<RewardClosedCard> with TickerProviderStateMixin {
  late AnimationController controller;

  bool isFront = true;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    widget.controller._state = this;
  }

  Future flip() async {
    isFront = !isFront;

    await controller.forward();
  }

  Future flipBack() async {
    isFront = !isFront;

    controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final angle = controller.value * -pi;
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: isFrontImage(angle.abs())
              ? Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-0.63, -0.78),
                      end: Alignment(0.63, 0.78),
                      colors: [Color(0xFFCBB9FF), Color(0xFF9575F3)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    image: const DecorationImage(
                      image: AssetImage(
                        simpleRewardCard,
                      ),
                      scale: 4,
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Stack(
                    children: [
                      if (widget.type == 1) ...[
                        const Positioned(
                          top: 22,
                          left: 15,
                          child: SRewardStarIcon(
                            width: 30,
                            height: 30,
                          ),
                        ),
                        const Positioned(
                          bottom: 40,
                          right: 16,
                          child: SRewardStarIcon(
                            width: 22,
                            height: 22,
                          ),
                        ),
                        const Positioned(
                          bottom: 32,
                          right: 41,
                          child: SRewardStarIcon(
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ] else if (widget.type == 2) ...[
                        const Positioned(
                          bottom: 31,
                          right: 19,
                          child: SRewardStarIcon(
                            width: 30,
                            height: 30,
                          ),
                        ),
                        const Positioned(
                          top: 30,
                          left: 39,
                          child: SRewardStarIcon(
                            width: 22,
                            height: 22,
                          ),
                        ),
                        const Positioned(
                          top: 44,
                          left: 20,
                          child: SRewardStarIcon(
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ] else ...[
                        const Positioned(
                          bottom: 31,
                          left: 15,
                          child: SRewardStarIcon(
                            width: 30,
                            height: 30,
                          ),
                        ),
                        const Positioned(
                          top: 30,
                          right: 16,
                          child: SRewardStarIcon(
                            width: 22,
                            height: 22,
                          ),
                        ),
                        const Positioned(
                          top: 44,
                          right: 41,
                          child: SRewardStarIcon(
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ]
                    ],
                  ),
                )
              : Transform(
                  transform: Matrix4.identity()..rotateY(pi),
                  alignment: Alignment.center,
                  child: backSideCard(),
                ),
        );
      },
    );
  }

  Widget backSideCard() {
    final currency = currencyFrom(
      sSignalRModules.currenciesWithHiddenList,
      widget.spinData != null ? widget.spinData?.assetSymbol ?? 'BTC' : 'BTC',
    );

    return RepaintBoundary(
      key: widget.shareKey,
      child: Container(
        width: 288,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment(-0.63, -0.78),
            end: Alignment(0.63, 0.78),
            colors: [Color(0xFFCBB9FF), Color(0xFF9575F3)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          image: const DecorationImage(
            image: AssetImage(simpleRewardDots),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            if (widget.spinData != null) ...[
              SNetworkCachedSvg(
                url: currency.iconUrl,
                width: 120,
                height: 120,
                placeholder: const SizedBox.shrink(),
              ),
            ] else ...[
              const SSkeletonTextLoader(
                height: 120,
                width: 120,
              ),
            ],
            const SizedBox(
              height: 17.53,
            ),
            if (widget.spinData != null) ...[
              Text(
                volumeFormat(
                  prefix: currency.prefixSymbol,
                  decimal: widget.spinData?.amount ?? Decimal.zero,
                  accuracy: currency.accuracy,
                  symbol: currency.symbol,
                ),
                style: sTextH5Style.copyWith(
                  fontSize: 32,
                  color: sKit.colors.white,
                ),
              ),
            ] else ...[
              const SSkeletonTextLoader(
                height: 30,
                width: 160,
              ),
            ],
            const Spacer(),
            SvgPicture.asset(
              simpleSmileLogo,
              width: 104,
              height: 48,
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }

  bool isFrontImage(double angle) {
    const degrees90 = pi / 2;
    const degrees270 = 3 * pi / 2;

    return angle <= degrees90 || angle >= degrees270;
  }
}
