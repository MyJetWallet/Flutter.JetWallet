import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/earn/widgets/check_title.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';

@RoutePage(name: 'EarnWithdrawnTypeRouter')
class EarnWithdrawnTypeScreen extends StatefulWidget {
  const EarnWithdrawnTypeScreen({super.key, required this.earnPosition});

  final EarnPositionClientModel earnPosition;

  @override
  State<EarnWithdrawnTypeScreen> createState() => _EarnWithdrawnTypeScreenState();
}

class _EarnWithdrawnTypeScreenState extends State<EarnWithdrawnTypeScreen> {
  bool isPartialWithdrawal = true;

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: '',
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.withdraw,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Column(
          children: [
            CheckTitle(
              radioValue: true,
              radiogroupValue: isPartialWithdrawal,
              title: intl.earn_partial_withdrawal,
              description: intl.earn_the_minimum_amount_of_earn,
              onTap: () {
                setState(() {
                  isPartialWithdrawal = true;
                });
              },
            ),
            CheckTitle(
              radioValue: false,
              radiogroupValue: isPartialWithdrawal,
              title: intl.earn_full_withdrawal,
              description: intl.earn_closing_an_earn_account,
              onTap: () {
                setState(() {
                  isPartialWithdrawal = false;
                });
              },
            ),
            const Spacer(),
            SPaddingH24(
              child: SButton.blue(
                text: intl.earn_confirm,
                callback: () {
                  if (isPartialWithdrawal) {
                    sRouter.push(
                      EarnWithdrawalAmountRouter(earnPosition: widget.earnPosition),
                    );
                  } else {
                    //TODO (Yaroslav): complet this variant
                  }
                },
              ),
            ),
            const SpaceH16(),
          ],
        ),
      ),
    );
  }
}
