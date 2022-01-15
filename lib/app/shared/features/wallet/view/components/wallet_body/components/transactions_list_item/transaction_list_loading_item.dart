import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

class TransactionListLoadingItem extends HookWidget {
  const TransactionListLoadingItem({
    Key? key,
    this.removeDivider = false,
  }) : super(key: key);

  final bool removeDivider;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: SizedBox(
        height: 80,
        child: Column(
          children: [
            const SpaceH18(),
            Row(
              children: const [
                SpaceW2(),
                SSkeletonTextLoader(
                  height: 16,
                  width: 16,
                ),
                SpaceW12(),
                SSkeletonTextLoader(
                  height: 16,
                  width: 80,
                ),
                Spacer(),
                SSkeletonTextLoader(
                  height: 16,
                  width: 80,
                ),
              ],
            ),
            const SpaceH12(),
            Row(
              children: const [
                SpaceW30(),
                SSkeletonTextLoader(
                  height: 10,
                  width: 109,
                ),
                Spacer(),
                SSkeletonTextLoader(
                  height: 10,
                  width: 60,
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
