import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:jetwallet/features/earn/widgets/deposit_card.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

class EarnPositionsListWidget extends StatelessWidget {
  const EarnPositionsListWidget({
    super.key,
    required this.earnPositions,
  });
  final List<EarnOfferClientModel> earnPositions;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SBasicHeader(
            title: intl.earn_active_earns,
            buttonTitle: intl.earn_view_all,
            onTap: () {},
          ),
          ...earnPositions.map((e) => SDepositCard(earnPosition: e)).toList(),
        ],
      ),
    );
  }
}
