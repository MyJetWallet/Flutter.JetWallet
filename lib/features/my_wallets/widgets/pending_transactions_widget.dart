import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class PendingTransactionsWidget extends StatelessWidget {
  const PendingTransactionsWidget({
   required this.countOfTransactions,
   required this.onTap,
  });

  final int countOfTransactions;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpaceH16(),
            Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.grey1,
                  ),
                ),
                const SpaceW8(),
                Text(
                  intl.my_wallets_pending_transactions,
                  style: sSubtitle3Style.copyWith(
                    color: colors.grey2,
                  ),
                ),
                const Spacer(),
                Text(
                  countOfTransactions.toString(),
                  style: sSubtitle3Style.copyWith(
                    color: colors.black,
                  ),
                ),
                SizedBox(
                  width: 17,
                  height: 17,
                  child: SBlueRightArrowIcon(
                    color: colors.grey1,
                  ),
                ),
              ],
            ),
            const SpaceH16(),
            const SDivider(),
          ],
        ),
      ),
    );
  }
}
