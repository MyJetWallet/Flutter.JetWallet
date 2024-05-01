import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/earn/widgets/check_title.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_analytics/simple_analytics.dart';
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
  @override
  void initState() {
    sAnalytics.earnWithdrawTypeScreenView(
      assetName: widget.earnPosition.assetId,
      earnWithdrawalType: widget.earnPosition.withdrawType.name,
      earnOfferId: widget.earnPosition.offerId,
      earnPlanName: widget.earnPosition.offers.first.name ?? '',
    );
    super.initState();
  }

  bool isPartialWithdrawal = true;

  @override
  Widget build(BuildContext context) {
    final minAccountAmount = widget.earnPosition.offers.first.minAmount ?? Decimal.zero;
    final formatedMinAccountAmount = volumeFormat(
      decimal: minAccountAmount,
      symbol: widget.earnPosition.assetId,
    );

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
              description: '${intl.earn_the_minimum_amount_of_earn} $formatedMinAccountAmount',
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
                    sAnalytics.tapOnTheContinueWithEarnWithdrawTypeButton(
                      assetName: widget.earnPosition.assetId,
                      earnWithdrawalType: widget.earnPosition.withdrawType.name,
                      earnOfferId: widget.earnPosition.offerId,
                      earnPlanName: widget.earnPosition.offers.first.name ?? '',
                      fullWithdrawType: !isPartialWithdrawal,
                    );
                    sRouter.push(
                      EarnWithdrawalAmountRouter(earnPosition: widget.earnPosition),
                    );
                  } else {
                    sAnalytics.tapOnTheContinueWithEarnWithdrawTypeButton(
                      assetName: widget.earnPosition.assetId,
                      earnWithdrawalType: widget.earnPosition.withdrawType.name,
                      earnOfferId: widget.earnPosition.offerId,
                      earnPlanName: widget.earnPosition.offers.first.name ?? '',
                      fullWithdrawType: !isPartialWithdrawal,
                    );
                    sAnalytics.sureFullEarnWithdrawPopupView(
                      assetName: widget.earnPosition.assetId,
                      earnWithdrawalType: widget.earnPosition.withdrawType.name,
                      earnOfferId: widget.earnPosition.offerId,
                      earnPlanName: widget.earnPosition.offers.first.name ?? '',
                    );
                    showWithdrawalTypeAreYouSurePopUp(
                      earnPosition: widget.earnPosition,
                      amount: widget.earnPosition.baseAmount + widget.earnPosition.incomeAmount,
                      isPartialWithdrawal: isPartialWithdrawal,
                    );
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

Future<void> showWithdrawalTypeAreYouSurePopUp({
  required Decimal amount,
  required EarnPositionClientModel earnPosition,
  required bool isPartialWithdrawal,
}) async {
  final context = sRouter.navigatorKey.currentContext!;

  await sShowAlertPopup(
    context,
    primaryText: intl.earn_are_you_sure,
    secondaryText: intl.earn_full_withdraw,
    primaryButtonName: intl.earn_continue_earning,
    secondaryButtonName: intl.earn_yes_withdraw,
    image: Image.asset(
      infoLightAsset,
      width: 80,
      height: 80,
      package: 'simple_kit',
    ),
    onPrimaryButtonTap: () {
      sAnalytics.tapOnTheContinueEarningButton(
        assetName: earnPosition.assetId,
        earnOfferId: earnPosition.offerId,
        earnPlanName: earnPosition.offers.first.name ?? '',
        earnWithdrawalType: earnPosition.withdrawType.name,
      );
      sRouter.maybePop();
    },
    onSecondaryButtonTap: () {
      sAnalytics.tapOnTheYesWithdrawButton(
        assetName: earnPosition.assetId,
        earnOfferId: earnPosition.offerId,
        earnPlanName: earnPosition.offers.first.name ?? '',
        earnWithdrawalType: earnPosition.withdrawType.name,
      );
      sRouter.push(
        EarnWithdrawOrderSummaryRouter(
          amount: amount,
          earnPosition: earnPosition,
          isClosing: true,
        ),
      );
    },
  );
}
