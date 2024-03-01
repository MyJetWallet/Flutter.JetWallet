import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:jetwallet/features/earn/widgets/deposit_card.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/widgets/table/placeholder/simple_placeholder.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';

class EarnPositionsListWidget extends StatelessWidget {
  const EarnPositionsListWidget({
    super.key,
    required this.earnPositions,
    required this.showLinkButton,
  });
  final List<EarnPositionClientModel> earnPositions;
  final bool showLinkButton;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SBasicHeader(
            title: intl.earn_active_earns,
            buttonTitle: intl.earn_history,
            showLinkButton: showLinkButton,
            onTap: () => context.router.push(const EarnsArchiveRouter()),
          ),
          if (earnPositions.isEmpty)
            SPlaceholder(
              size: SPlaceholderSize.l,
              text: intl.wallet_simple_account_empty,
            ),
          ...earnPositions
              .map(
                (e) => SDepositCard(
                  earnPosition: e,
                  onTap: () {
                    sAnalytics.tapOnTheAnyActiveEarnButton(
                      assetName: e.assetId,
                      earnAPYrate: getHighestApyRateAsString(e.offers) ?? '',
                      earnDepositAmount: e.baseAmount.toStringAsFixed(2),
                      earnOfferStatus: e.status.name,
                      earnPlanName: e.offers.first.description ?? '',
                      earnWithdrawalType: e.withdrawType.name,
                      revenue: e.incomeAmount.toStringAsFixed(2),
                    );
                    context.router.push(
                      EarnPositionActiveRouter(earnPosition: e),
                    );
                  },
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
