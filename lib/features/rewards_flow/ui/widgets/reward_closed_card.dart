import 'package:flutter/material.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit/simple_kit.dart';

class RewardClosedCard extends StatelessWidget {
  const RewardClosedCard({
    super.key,
    required this.type,
  });

  final int type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      height: 200,
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
          image: AssetImage(simpleRewardCard),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          if (type == 1) ...[
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
          ] else if (type == 2) ...[
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
    );
  }
}
