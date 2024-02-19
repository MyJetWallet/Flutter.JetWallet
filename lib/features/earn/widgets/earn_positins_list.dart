import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:jetwallet/features/earn/widgets/deposit_card.dart';
import 'package:simple_kit_updated/widgets/table/placeholder/simple_placeholder.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';

class EarnPositionsListWidget extends StatelessWidget {
  const EarnPositionsListWidget({
    super.key,
    required this.earnPositions,
    required this.earnPositionsClosed,
  });
  final List<EarnPositionClientModel> earnPositions;
  final List<EarnPositionClientModel> earnPositionsClosed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SBasicHeader(
            title: intl.earn_active_earns,
            buttonTitle: intl.earn_view_all,
            showLinkButton: earnPositionsClosed.isNotEmpty,
            onTap: () => context.router.push(EarnsArchiveRouter(earnPositionsClosed: earnPositionsClosed)),
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
                  onTap: () => context.router.push(
                    EarnPositionActiveRouter(earnPosition: e),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
