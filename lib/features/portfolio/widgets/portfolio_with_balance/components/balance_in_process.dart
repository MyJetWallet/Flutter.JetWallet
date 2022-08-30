import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/widgets/dash_line.dart';
import 'package:simple_kit/simple_kit.dart';

class BalanceInProcess extends StatelessWidget {
  const BalanceInProcess({
    this.removeDivider = false,
    required this.text,
    required this.leadText,
    required this.icon,
  });

  final bool removeDivider;
  final String leadText;
  final String text;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SPaddingH24(
      child: SizedBox(
        height: 54,
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(
                  child: DashLine(),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: icon,
                ),
                const SpaceW12(),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Baseline(
                          baseline: 27.0,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            leadText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: sBodyText2Style.copyWith(
                              color: colors.grey2,
                            ),
                          ),
                        ),
                      ),
                      const SpaceW2(),
                      Baseline(
                        baseline: 27.0,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          text,
                          style: sBodyText2Style.copyWith(
                            color: colors.grey2,
                          ),
                        ),
                      ),
                      const SpaceW4(),
                    ],
                  ),
                ),
                Baseline(
                  baseline: 27.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    '${intl.balanceInProcess_balanceInProcess}...',
                    style: sBodyText2Style.copyWith(
                      color: colors.grey2,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (!removeDivider) const SDivider(),
          ],
        ),
      ),
    );
  }
}
