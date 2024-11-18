import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class PendingTransactionsWidget extends HookWidget {
  const PendingTransactionsWidget({
    required this.countOfTransactions,
    required this.onTap,
  });

  final int countOfTransactions;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final isHighlated = useState(false);

    return SafeGesture(
      highlightColor: colors.gray2,
      onHighlightChanged: (p0) {
        isHighlated.value = p0;
      },
      onTap: onTap,
      child: ColoredBox(
        color: isHighlated.value ? colors.gray2 : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.gray10,
                    ),
                  ),
                  const SpaceW8(),
                  Text(
                    intl.my_wallets_pending_transactions,
                    style: STStyles.subtitle2.copyWith(
                      color: colors.gray10,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    countOfTransactions.toString(),
                    style: STStyles.body2Semibold.copyWith(
                      color: colors.black,
                    ),
                  ),
                  const SpaceW8(),
                  Assets.svg.medium.shevronRight.simpleSvg(
                    width: 20,
                    height: 20,
                    color: colors.gray10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
