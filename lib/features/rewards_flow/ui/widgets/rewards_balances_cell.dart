import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class RewardsBalancesCell extends StatelessObserverWidget {
  const RewardsBalancesCell({super.key});

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: Column(
        children: [
          _BalanceCell(),
        ],
      ),
    );
  }
}

class _BalanceCell extends StatelessWidget {
  const _BalanceCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SpaceH22(),
        SizedBox(
          height: 88,
          child: Row(
            children: [
              Text(
                'Dogecoin',
                style: sSubtitle2Style,
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: sKit.colors.grey4),
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: SRewardTrophyIcon(color: sKit.colors.confetti1),
                    ),
                    const SpaceW10(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        '40.80 USDT',
                        textAlign: TextAlign.right,
                        style: sSubtitle2Style,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SpaceH20(),
        const Divider(),
      ],
    );
  }
}
